import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../design_system/ouro_colors.dart';
import '../../core/utils/extensions.dart';

class OuroBottomSheet extends StatelessWidget {
  final Widget child;
  final double? maxHeight;
  final double? minHeight;
  final String? title;
  final bool showDragHandle;

  const OuroBottomSheet({
    super.key,
    required this.child,
    this.maxHeight,
    this.minHeight,
    this.title,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? context.screenHeight * 0.85,
        minHeight: minHeight ?? 200,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: OuroColors.surface.withValues(alpha: 0.95),
              border: Border.all(
                color: OuroColors.glassBorder,
                width: 0.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showDragHandle) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: OuroColors.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (title != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Divider(color: OuroColors.glassBorder),
                ],
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .slideY(begin: 1, end: 0, duration: 300.ms, curve: Curves.easeOutCubic)
        .fadeIn(duration: 200.ms);
  }
}

class ShareSheet extends StatelessWidget {
  const ShareSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return OuroBottomSheet(
      title: 'Partager',
      child: Column(
        children: [
          _shareOption(Icons.wifi_tethering, 'Partager via Mesh', OuroColors.meshBlue, 'mesh', context),
          const SizedBox(height: 8),
          _shareOption(Icons.download, 'Télécharger localement', OuroColors.localGreen, 'download', context),
          const SizedBox(height: 8),
          _shareOption(Icons.upload_file, 'Exporter le fichier', OuroColors.ouroOrange, 'export', context),
          const SizedBox(height: 8),
          _shareOption(Icons.link, 'Copier le lien', Colors.purple, 'link', context),
        ],
      ),
    );
  }

  void _onShareOption(String option, BuildContext context) {
    switch (option) {
      case 'mesh':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Partage mesh — scannez les appareils à proximité')),
        );
        break;
      case 'download':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Téléchargement en cours...')),
        );
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fichier exporté')),
        );
        break;
      case 'link':
        Clipboard.setData(const ClipboardData(text: 'https://ouro-prep.app/share/...'));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lien copié')),
        );
        break;
    }
    Navigator.of(context).pop();
  }

  Widget _shareOption(IconData icon, String label, Color color, String action, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _onShareOption(action, context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterSheet extends StatelessWidget {
  final String currentFilter;
  final ValueChanged<String> onFilterChanged;

  const FilterSheet({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    const filters = ['Tous', 'PDF', 'Vidéo', 'Quiz', 'Local', 'Mesh', 'Cloud'];

    return OuroBottomSheet(
      title: 'Filtres',
      child: Column(
        children: filters.map((filter) {
          final isSelected = currentFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  onFilterChanged(filter);
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? OuroColors.meshBlue.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: isSelected ? OuroColors.meshBlue : OuroColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? OuroColors.meshBlue : Colors.white,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
