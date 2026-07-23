#!/usr/bin/env bash
set -euo pipefail

# ============================================
# OURO PREP — Build Script (Silicon Valley Grade)
# ============================================
# Usage: ./scripts/build.sh [analyze|debug|release|release_obfuscated|ios]
#   ./scripts/build.sh                    # debug APK (arm64)
#   ./scripts/build.sh release            # release APK (obfuscated, shrunk)
#   ./scripts/build.sh release_obfuscated # release APK (obfuscated + shrunk)
#   ./scripts/build.sh ios                # iOS build (requires macOS + Xcode)
#   ./scripts/build.sh analyze            # run flutter analyze only
# ============================================

FLUTTER="${FLUTTER:-flutter}"
BUILD_MODE="${1:-debug}"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

cd "$PROJECT_DIR"

echo "═══════════════════════════════════════════"
echo "  OURO PREP — Build ($BUILD_MODE)"
echo "  Project: $PROJECT_DIR"
echo "  Flutter: $($FLUTTER --version | head -1)"
echo "═══════════════════════════════════════════"

analyze() {
    echo "→ Running flutter analyze..."
    $FLUTTER analyze lib/
}

clean() {
    echo "→ Cleaning previous builds..."
    $FLUTTER clean
    rm -rf build/
}

build_android_debug() {
    echo "→ Building Android debug APK..."
    $FLUTTER build apk --debug --target-platform android-arm64
    echo "✓ APK: build/app/outputs/flutter-apk/app-debug.apk"
}

build_android_release() {
    echo "→ Building Android release APK (obfuscated)..."
    $FLUTTER build apk --release \
        --target-platform android-arm64 \
        --obfuscate \
        --split-debug-info=build/debug-info
    echo "✓ APK: build/app/outputs/flutter-apk/app-release.apk"
}

build_android_appbundle() {
    echo "→ Building Android App Bundle (Google Play)..."
    $FLUTTER build appbundle --release \
        --target-platform android-arm64,android-arm \
        --obfuscate \
        --split-debug-info=build/debug-info
    echo "✓ AAB: build/app/outputs/bundle/release/app-release.aab"
}

build_ios() {
    echo "→ Building iOS (requires macOS + Xcode)..."
    if [[ "$(uname)" != "Darwin" ]]; then
        echo "✗ iOS build is only available on macOS"
        exit 1
    fi
    $FLUTTER build ios --release --no-codesign
    echo "✓ iOS build complete"
}

case "$BUILD_MODE" in
    debug)
        analyze
        clean
        build_android_debug
        ;;
    release)
        analyze
        clean
        build_android_release
        build_android_appbundle
        ;;
    release_obfuscated)
        analyze
        clean
        echo "→ Building obfuscated + shrunk APK..."
        $FLUTTER build apk --release --target-platform android-arm64 --obfuscate --split-debug-info=build/debug-info
        echo "✓ APK: build/app/outputs/flutter-apk/app-release.apk"
        ;;
    ios)
        analyze
        build_ios
        ;;
    analyze)
        analyze
        ;;
    *)
        echo "Usage: $0 {debug|release|release_obfuscated|ios|analyze}"
        exit 1
        ;;
esac

echo "═══════════════════════════════════════════"
echo "  ✓ Build completed successfully!"
echo "═══════════════════════════════════════════"
