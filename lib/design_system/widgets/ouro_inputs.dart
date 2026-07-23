import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';

// ─────────────────────────────────────────────────────────────
//  TEXT INPUT  (Focus glow + label float — iOS/Duolingo feel)
// ─────────────────────────────────────────────────────────────
class OuroTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int maxLines;
  final bool autofocus;
  final Color? accentColor;

  const OuroTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.autofocus = false,
    this.accentColor,
  });

  @override
  State<OuroTextField> createState() => _OuroTextFieldState();
}

class _OuroTextFieldState extends State<OuroTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusCtrl;
  late FocusNode _focusNode;
  bool _hasFocus = false;
  bool _obscure  = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _obscure     = widget.obscureText;
    _focusCtrl   = AnimationController(vsync: this, duration: 200.ms);
    _focusNode   = FocusNode();
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
      if (_focusNode.hasFocus) _focusCtrl.forward();
      else _focusCtrl.reverse();
    });
  }

  @override
  void dispose() {
    _focusCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final col = widget.accentColor ?? OuroColors.meshBlue;

    return AnimatedBuilder(
      animation: _focusCtrl,
      builder: (ctx, child) {
        final v = CurvedAnimation(parent: _focusCtrl, curve: Curves.easeInOut).value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated border container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: v > 0 ? DesignTokens.glow(col, radius: 14 * v) : null,
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: _obscure,
                keyboardType: widget.keyboardType,
                maxLines: widget.maxLines,
                autofocus: widget.autofocus,
                onChanged: (v) {
                  widget.onChanged?.call(v);
                  if (_error != null) setState(() => _error = null);
                },
                onFieldSubmitted: widget.onSubmitted,
                validator: (v) {
                  final err = widget.validator?.call(v);
                  setState(() => _error = err);
                  return null; // handle manually for custom styling
                },
                style: const TextStyle(
                  color: OuroColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  labelStyle: TextStyle(
                    color: _hasFocus ? col : OuroColors.textSecondary,
                    fontSize: 13,
                  ),
                  hintStyle: const TextStyle(
                    color: OuroColors.textTertiary, fontSize: 14),
                  filled: true,
                  fillColor: OuroColors.cardDark,
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: _hasFocus ? col : OuroColors.textSecondary,
                          size: 18,
                        )
                      : null,
                  suffixIcon: widget.obscureText
                      ? IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: OuroColors.textSecondary, size: 18,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        )
                      : widget.suffix,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: _error != null
                          ? OuroColors.errorRed.withValues(alpha: 0.5)
                          : OuroColors.glassBorder,
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: col, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: OuroColors.errorRed, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: OuroColors.errorRed, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            // Error message
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 6),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: OuroColors.errorRed, fontSize: 11),
                ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.3),
              ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SEARCH BAR  (TikTok / YouTube style)
// ─────────────────────────────────────────────────────────────
class OuroSearchBar extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;

  const OuroSearchBar({
    super.key,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  @override
  State<OuroSearchBar> createState() => _OuroSearchBarState();
}

class _OuroSearchBarState extends State<OuroSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late FocusNode _focus;
  bool _hasText = false;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: 200.ms);
    _focus = FocusNode();
    _focus.addListener(() {
      setState(() => _hasFocus = _focus.hasFocus);
      if (_focus.hasFocus) _ctrl.forward();
      else _ctrl.reverse();
    });
    widget.controller?.addListener(() {
      setState(() => _hasText = (widget.controller?.text.isNotEmpty ?? false));
    });
  }

  @override
  void dispose() { _ctrl.dispose(); _focus.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, _) {
        final v = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut).value;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            boxShadow: v > 0
                ? DesignTokens.glow(OuroColors.meshBlue, radius: 12 * v)
                : null,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: TextField(
              controller: widget.controller,
              focusNode: _focus,
              onChanged: (s) {
                widget.onChanged?.call(s);
                setState(() => _hasText = s.isNotEmpty);
              },
              onSubmitted: widget.onSubmitted,
              style: const TextStyle(color: OuroColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: widget.hint ?? 'Rechercher...',
                hintStyle: const TextStyle(color: OuroColors.textTertiary, fontSize: 14),
                filled: true,
                fillColor: OuroColors.cardDark,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: _hasFocus ? OuroColors.meshBlue : OuroColors.textSecondary,
                  size: 18,
                ),
                suffixIcon: _hasText
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded,
                          color: OuroColors.textSecondary, size: 16),
                        onPressed: () {
                          widget.controller?.clear();
                          widget.onClear?.call();
                          setState(() => _hasText = false);
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: const BorderSide(color: OuroColors.glassBorder, width: 0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: const BorderSide(color: OuroColors.glassBorder, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: const BorderSide(color: OuroColors.meshBlue, width: 1),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        );
      },
    );
  }
}
