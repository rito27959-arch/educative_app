import 'package:flutter/material.dart';
import '../ouro_colors.dart';
import '../design_tokens.dart';
import '../glassmorphism.dart';

class OuroListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const OuroListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        onTap: onTap,
        child: GlassContainer(
          padding: DesignTokens.hPaddingMd,
          borderRadius: DesignTokens.radiusLg,
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Container(
                  padding: DesignTokens.paddingSm,
                  decoration: BoxDecoration(
                    color: (iconColor ?? OuroColors.meshBlue).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: Icon(leadingIcon, color: iconColor ?? OuroColors.meshBlue, size: DesignTokens.iconMd),
                ),
                SizedBox(width: DesignTokens.gridMd),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: OuroColors.textPrimary, fontSize: DesignTokens.textMd)),
                    if (subtitle != null) ...[
                      SizedBox(height: DesignTokens.gridSm / 2),
                      Text(subtitle!, style: TextStyle(color: OuroColors.textSecondary, fontSize: DesignTokens.textSm)),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
              if (trailing == null && onTap != null)
                Icon(Icons.chevron_right, color: OuroColors.textSecondary.withValues(alpha: 0.3), size: DesignTokens.iconMd),
            ],
          ),
        ),
      ),
    );
  }
}

class OuroSettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const OuroSettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.grid2x, vertical: DesignTokens.gridMd),
          child: Row(
            children: [
              Container(
                padding: DesignTokens.paddingSm,
                decoration: BoxDecoration(
                  color: OuroColors.glassBg,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Icon(icon, color: OuroColors.meshBlue, size: DesignTokens.iconMd),
              ),
              SizedBox(width: DesignTokens.gridMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: OuroColors.textPrimary, fontSize: DesignTokens.textMd)),
                    if (subtitle != null) ...[
                      SizedBox(height: 2),
                      Text(subtitle!, style: TextStyle(color: OuroColors.textSecondary, fontSize: DesignTokens.textSm)),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class OuroInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const OuroInfoTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: OuroColors.meshBlue, size: DesignTokens.iconSm),
        SizedBox(width: DesignTokens.gridSm),
        Text(label, style: TextStyle(color: OuroColors.textSecondary, fontSize: DesignTokens.textSm)),
        Spacer(),
        Text(value, style: TextStyle(color: OuroColors.textPrimary, fontSize: DesignTokens.textSm, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
