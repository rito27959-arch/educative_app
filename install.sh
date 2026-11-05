#!/bin/bash
# Install rive-cli from https://releases.rive.app/cli
#
#   curl -fsSL https://releases.rive.app/cli/install.sh | sh
#
# Optional env:
#   RIVE_VERSION       pin a release (e.g. 0.1.0); default is the stream head
#   RIVE_STREAM        stable (default), ea, or uat
#   RIVE_HOME          install home (versions/, current, default); default $HOME/.rive
#   RIVE_INSTALL_DIR   muxer path's directory; default $RIVE_HOME/bin
#   RIVE_BASE_URL      override the CDN (tests / mirrors)
#
# Trust: SHA-256 the tarball against the manifest, extract only `rive`,
# reject a symlink. After that ~/.rive is user-owned — no sidecar, no
# world-writable fail-closed, no hash of a copied PATH muxer.

# `| sh` is dash on Debian and Ubuntu, and the rest of this script needs bash.
# Piped input is already partly consumed, so fetch the script again for bash.
if [ -z "${BASH_VERSION:-}" ]; then
    if ! command -v bash >/dev/null 2>&1; then
        echo "rive-cli's installer needs bash. Install bash, then run it again." >&2
        exit 1
    fi
    if [ -f "$0" ] && grep -q '^# Install rive-cli from' "$0" 2>/dev/null; then
        exec bash "$0" "$@"
    fi
    rive_script="$(mktemp)" || exit 1
    if ! curl -fsSL "${RIVE_BASE_URL:-https://releases.rive.app/cli}/install.sh" -o "$rive_script"; then
        rm -f "$rive_script"
        exit 1
    fi
    bash "$rive_script" "$@"
    rive_status=$?
    rm -f "$rive_script"
    exit "$rive_status"
fi

set -euo pipefail

BASE_URL="${RIVE_BASE_URL:-https://releases.rive.app/cli}"

HOME_DIR="${RIVE_HOME:-${HOME:-.}/.rive}"
INSTALL_DIR="${RIVE_INSTALL_DIR:-$HOME_DIR/bin}"

uname_s="$(uname -s)"
uname_m="$(uname -m)"
case "$uname_s" in
Darwin)
    case "$uname_m" in
    arm64) artifact_key="darwin-arm64" ;;
    *)
        echo "rive-cli is not shipped for macOS $uname_m yet (Apple Silicon only)." >&2
        exit 1
        ;;
    esac
    ;;
Linux)
    case "$uname_m" in
    x86_64 | amd64) artifact_key="linux-x64" ;;
    *)
        echo "rive-cli is not shipped for Linux $uname_m yet (x86_64 only)." >&2
        exit 1
        ;;
    esac
    ;;
MINGW* | MSYS* | CYGWIN*)
    echo "Use install.ps1 on Windows:" >&2
    echo "  irm https://releases.rive.app/cli/install.ps1 | iex" >&2
    exit 1
    ;;
*)
    echo "rive-cli is not shipped for $uname_s yet." >&2
    exit 1
    ;;
esac

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "install.sh needs '$1' on PATH" >&2
        exit 1
    }
}
need_cmd curl
need_cmd tar

sha256_file() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{print $1}'
    else
        shasum -a 256 "$1" | awk '{print $1}'
    fi
}

install_binary() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    local tmp_bin="$dest.new"
    cp "$src" "$tmp_bin"
    chmod 755 "$tmp_bin"
    mv -f "$tmp_bin" "$dest"
    if [[ "$uname_s" == "Darwin" ]]; then
        xattr -d com.apple.quarantine "$dest" 2>/dev/null || true
    fi
}

stream="${RIVE_STREAM:-stable}"
case "$stream" in
stable | ea | uat) ;;
*)
    echo "RIVE_STREAM must be stable, ea, or uat (got '$stream')" >&2
    exit 1
    ;;
esac

if [[ -n "${RIVE_VERSION:-}" ]]; then
    manifest_url="$BASE_URL/v${RIVE_VERSION}/manifest.json"
elif [[ "$stream" == "stable" ]]; then
    manifest_url="$BASE_URL/latest/manifest.json"
else
    manifest_url="$BASE_URL/$stream/manifest.json"
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Fetching $manifest_url"
curl -fsSL "$manifest_url" -o "$tmp/manifest.json"

# The manifest's root object holds a "version" string and an "artifacts"
# object with a {path, sha256} object per platform. awk reads it, so the
# installer needs no python3 (on a Mac without the Command Line Tools,
# /usr/bin/python3 only offers to install them). Integrity comes from the
# sha256 check below; the parsing only has to pick the right members or fail.
# Line breaks become tabs: whitespace between tokens, and rejected inside a
# string like any raw control character. Deleting them would join "ri" and
# "ve.tar.gz", or 1 and 2, into something valid. NUL becomes \001 for the
# same reason: $(...) drops NUL bytes, and \001 is rejected wherever it is.
manifest="$(tr '\000\n\r' '\001\t\t' <"$tmp/manifest.json")"

# A JSON scan: it checks the document's structure (one root object, keys,
# colons, commas, brackets, literals, escapes, no raw control characters in
# strings) and reads members by exact, decoded name at exact depth, so a
# look-alike nested anywhere else is never read. A repeated name replaces the
# earlier value whatever its type, as a JSON parser does. Escapes decode to
# printable ASCII; anything else becomes a byte no check accepts, so a
# decoded line break cannot split the output below. Prints OK, the version,
# 1 if this platform's entry is an object, its path and its sha256; or
# INVALID for anything that is not exactly one well-formed object.
parsed="$(printf '%s\n' "$manifest" | awk -v want="$artifact_key" '
function value_start(is_object) { # a value begins at the current depth
    if (depth == 0) {
        if (seen || !is_object) return 0
        seen = 1; return 1
    }
    if (state[depth] != 2) return 0
    state[depth] = 3; count[depth]++
    # A repeated name replaces what came before, whatever the new type.
    if (depth == 1 && key[1] == "version") version = ""
    if (depth == 1 && key[1] == "artifacts") { found = 0; path = ""; sha = "" }
    if (in_artifacts && depth == 2 && key[2] == want) {
        found = 0; path = ""; sha = ""
    }
    if (in_entry && depth == 3 && key[3] == "path") path = ""
    if (in_entry && depth == 3 && key[3] == "sha256") sha = ""
    return 1
}
function hex4(h,   v, k, d) { # the value of 4 hex digits, or -1
    if (length(h) != 4) return -1
    h = tolower(h); v = 0
    for (k = 1; k <= 4; k++) {
        d = index("0123456789abcdef", substr(h, k, 1))
        if (d == 0) return -1
        v = v * 16 + d - 1
    }
    return v
}
BEGIN {
    for (k = 1; k < 32; k++) ctl = ctl sprintf("%c", k)
    odd = sprintf("%c", 1)
}
{
    n = length($0); depth = 0; instr = 0; ok = 1; seen = 0
    version = ""; found = 0; path = ""; sha = ""; in_artifacts = 0; in_entry = 0
    for (i = 1; i <= n; i++) {
        c = substr($0, i, 1)
        if (instr) {
            if (index(ctl, c)) { ok = 0; break } # raw control character
            if (c == "\\") {
                e = substr($0, i + 1, 1)
                if (e == "u") {
                    v = hex4(substr($0, i + 2, 4))
                    if (v < 0) { ok = 0; break }
                    buf = buf ((v >= 32 && v < 127) ? sprintf("%c", v) : odd)
                    i += 5; continue
                }
                j = index("\"\\/bfnrt", e)
                if (j == 0) { ok = 0; break }
                buf = buf ((j <= 3) ? e : odd); i++; continue
            }
            if (c != "\"") { buf = buf c; continue }
            instr = 0
            if (type[depth] == "o" && state[depth] == 0) {
                key[depth] = buf; state[depth] = 1; continue
            }
            if (!value_start(0)) { ok = 0; break }
            if (depth == 1 && key[1] == "version") version = buf
            if (in_entry && depth == 3 && key[3] == "path") path = buf
            if (in_entry && depth == 3 && key[3] == "sha256") sha = buf
            continue
        }
        if (c == " " || c == "\t") continue
        if (c == "\"") { instr = 1; buf = ""; continue }
        if (c == "{" || c == "[") {
            if (!value_start(c == "{")) { ok = 0; break }
            if (c == "{" && depth == 1 && key[1] == "artifacts") {
                in_artifacts = 1; found = 0; path = ""; sha = ""
            }
            if (c == "{" && in_artifacts && depth == 2 && key[2] == want) {
                in_entry = 1; found = 1; path = ""; sha = ""
            }
            depth++; type[depth] = (c == "{") ? "o" : "a"; count[depth] = 0
            state[depth] = (c == "{") ? 0 : 2; key[depth] = ""
            continue
        }
        if (c == "}" || c == "]") {
            if (depth == 0 || type[depth] != ((c == "}") ? "o" : "a")) { ok = 0; break }
            # Closing after a value, or straight after opening ({} or []).
            if (!(state[depth] == 3 ||
                  (count[depth] == 0 && state[depth] == ((c == "}") ? 0 : 2)))) {
                ok = 0; break
            }
            depth--
            if (depth == 2) in_entry = 0
            if (depth == 1) in_artifacts = 0
            continue
        }
        if (c == ":") {
            if (type[depth] != "o" || state[depth] != 1) { ok = 0; break }
            state[depth] = 2; continue
        }
        if (c == ",") {
            if (depth == 0 || state[depth] != 3) { ok = 0; break }
            state[depth] = (type[depth] == "o") ? 0 : 2; continue
        }
        # Anything else must be a bare literal: true, false, null or a number.
        rest = substr($0, i)
        if (!match(rest, /^[-+.0-9A-Za-z]+/)) { ok = 0; break }
        lit = substr(rest, 1, RLENGTH)
        if (lit !~ /^(true|false|null|-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][-+]?[0-9]+)?)$/) {
            ok = 0; break
        }
        if (!value_start(0)) { ok = 0; break }
        i += RLENGTH - 1
    }
    if (!ok || instr || depth != 0 || !seen) { print "INVALID"; exit }
    print "OK"; print version; print found; print path; print sha
}')"
# By line number, not `read`: $(...) drops trailing empty lines, and a read
# past the end would stop the script under set -e without saying why.
line() { printf '%s\n' "$parsed" | sed -n "$1p"; }
if [[ "$(line 1)" != OK ]]; then
    echo "$manifest_url is not a valid manifest" >&2
    exit 1
fi
if [[ "$(line 3)" != 1 ]]; then
    echo "$manifest_url has no artifact '$artifact_key'" >&2
    exit 1
fi
version="$(line 2)"
rel_path="$(line 4)"
expect_sha="$(line 5 | tr 'A-F' 'a-f')"

# A version, or a file name under v<version>/: no separators, no `..`.
safe_segment() {
    [[ ${#1} -ge 1 && ${#1} -le 64 && "$1" != *..* &&
        "$1" =~ ^[0-9A-Za-z._-]+$ ]]
}

if ! safe_segment "$version"; then
    echo "invalid version in $manifest_url" >&2
    exit 1
fi
if [[ "$rel_path" != "v$version/"* ]] ||
    ! safe_segment "${rel_path#"v$version/"}"; then
    echo "invalid artifact path in $manifest_url" >&2
    exit 1
fi
if [[ ! "$expect_sha" =~ ^[0-9a-f]{64}$ ]]; then
    echo "invalid sha256 in $manifest_url" >&2
    exit 1
fi
if [[ -n "${RIVE_VERSION:-}" && "$version" != "$RIVE_VERSION" ]]; then
    echo "manifest version $version does not match requested $RIVE_VERSION" >&2
    exit 1
fi

tarball_url="$BASE_URL/$rel_path"
archive="$tmp/rive.tar.gz"

echo "Downloading rive $version ($artifact_key)"
curl -fsSL "$tarball_url" -o "$archive"

got_sha="$(sha256_file "$archive")"
if [[ "$got_sha" != "$expect_sha" ]]; then
    echo "checksum mismatch for $tarball_url" >&2
    echo "  expected $expect_sha" >&2
    echo "  got      $got_sha" >&2
    exit 1
fi

# Validate the member list before writing anything. Selecting `-- docs` matches
# by prefix, so `docs/../../x` is inside the selection; tar refuses those itself,
# but relying on that makes a rejection indistinguishable from an absent member.
members="$(tar -tzf "$archive")"
if printf '%s\n' "$members" | grep -Eq '(^/|(^|/)\.\.(/|$)|\\|:)'; then
    echo "archive contains an unsafe path" >&2
    exit 1
fi
tar -xzf "$archive" -C "$tmp" -- rive
# Absent, not hostile: anything hostile was refused above.
for tree in docs samples; do
    # Two patterns rather than an alternation: "\$" is a literal dollar in BRE
    # by spec, so an escaped end-of-line anchor is implementation-dependent.
    if printf '%s\n' "$members" | grep -q -e "^$tree/" -e "^$tree\$"; then
        tar -xzf "$archive" -C "$tmp" -- "$tree"
    fi
done
if [[ -L "$tmp/rive" || ! -f "$tmp/rive" ]]; then
    echo "tarball did not contain a 'rive' binary" >&2
    exit 1
fi
# A symlink anywhere under docs -- including docs itself -- would be followed
# by the copy below. Test -L before -d, since -d follows the link and would
# happily report a link to /etc as a directory.
for tree in docs samples; do
    if [[ -L "$tmp/$tree" ]]; then
        echo "refusing $tree: not a directory" >&2
        exit 1
    fi
    if [[ -d "$tmp/$tree" ]] && find "$tmp/$tree" -type l | read -r _; then
        echo "refusing $tree containing symlinks" >&2
        exit 1
    fi
done

# Payload in the version cache. PATH muxer is a hardlink to that file
# (copy if the filesystem cannot hardlink). A copy is not hashed against
# the payload; replacing the PATH binary is already past that boundary.
payload="$HOME_DIR/versions/$version/rive"
install_binary "$tmp/rive" "$payload"

# Docs sit beside the payload, which is where `rive docs` looks. An older
# tarball has none; the command then reports that rather than failing here.
for tree in docs samples; do
    if [[ -d "$tmp/$tree" ]]; then
        rm -rf "$HOME_DIR/versions/$version/$tree"
        cp -R "$tmp/$tree" "$HOME_DIR/versions/$version/$tree"
    fi
done
mkdir -p "$INSTALL_DIR"
muxer="$INSTALL_DIR/rive"
# Hardlink via a temp name, then rename, so PATH `rive` is never unlinked
# out from under a concurrent exec (same pattern as install_binary).
if ln -f "$payload" "$muxer.new" 2>/dev/null; then
    mv -f "$muxer.new" "$muxer"
    if [[ "$uname_s" == "Darwin" ]]; then
        xattr -d com.apple.quarantine "$muxer" 2>/dev/null || true
    fi
else
    rm -f "$muxer.new"
    install_binary "$payload" "$muxer"
fi
mkdir -p "$HOME_DIR"
printf '%s\n' "$version" >"$HOME_DIR/current.new"
mv -f "$HOME_DIR/current.new" "$HOME_DIR/current"
printf '%s\n' "$version" >"$HOME_DIR/default.new"
mv -f "$HOME_DIR/default.new" "$HOME_DIR/default"
printf '%s\n' "$stream" >"$HOME_DIR/stream.new"
mv -f "$HOME_DIR/stream.new" "$HOME_DIR/stream"

echo "Installed rive $version to $INSTALL_DIR/rive"
echo "Version cache: $HOME_DIR/versions/$version/rive"

case ":$PATH:" in
*":$INSTALL_DIR:"*) ;;
*)
    echo
    echo "Add $INSTALL_DIR to your PATH:"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    ;;
esac

if [[ "$uname_s" == "Linux" ]]; then
    echo
    echo "Watch mode needs libEGL, libGLESv2, and libX11 at runtime."
    echo "--verify / --test do not."
fi

# Every row of the card a bare `rive` prints, plus `rive login` -- this is the
# one moment we know they have never signed in, and --publish needs it -- and
# `rive --help`, which the card carries as a footer line rather than a row.
# Keep the shared rows and the skills block in step with printFirstRun().
echo
echo "Get started:"
echo "  rive create myproject   scaffold a project in ./myproject"
echo "  rive myproject          preview it in a window, rebuilding on save"
echo "  rive docs               documentation; new to Rive, start here"
echo "  rive samples            runnable examples to copy from"
echo "  rive --help             every command and flag"
echo "  rive login              only for --publish, --rev and rive push"
echo
echo "For coding agents (Claude Code, Codex, Cursor and others):"
echo "  npx skills add rive-app/skills"
