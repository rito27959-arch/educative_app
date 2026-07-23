import 'package:flutter/material.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';

class CourseFilters {
  final String? subject;
  final String? type;
  final String? level;
  final String? sortBy;

  CourseFilters({this.subject, this.type, this.level, this.sortBy});

  CourseFilters copyWith({String? subject, String? type, String? level, String? sortBy}) {
    return CourseFilters(
      subject: subject ?? this.subject,
      type: type ?? this.type,
      level: level ?? this.level,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters => subject != null || type != null || level != null;
}

class FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? selectedColor;

  const FilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = selectedColor ?? OuroColors.meshBlue;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: DesignTokens.durationFast,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : OuroColors.glassBg,
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          border: Border.all(
            color: isSelected ? color.withValues(alpha: 0.3) : OuroColors.glassBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : OuroColors.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class FilterPanel extends StatelessWidget {
  final CourseFilters currentFilters;
  final ValueChanged<CourseFilters> onChanged;
  final VoidCallback? onClear;

  const FilterPanel({
    super.key,
    required this.currentFilters,
    required this.onChanged,
    this.onClear,
  });

  static const subjects = ['Tous', 'Mathématiques', 'Physique', 'Informatique', 'SVT', 'Littérature', 'Philosophie'];
  static const types = ['Tous', 'PDF', 'Vidéo', 'Quiz', 'Exercice'];
  static const levels = ['Tous', 'Débutant', 'Intermédiaire', 'Avancé'];

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(4),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filtres', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                if (currentFilters.hasActiveFilters)
                  GestureDetector(
                    onTap: onClear,
                    child: const Text('Effacer', style: TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
                  ),
              ],
            ),
          ),
          _buildSection('Matière', subjects, currentFilters.subject, (v) => onChanged(currentFilters.copyWith(subject: v == 'Tous' ? null : v))),
          _buildSection('Type', types, currentFilters.type, (v) => onChanged(currentFilters.copyWith(type: v == 'Tous' ? null : v))),
          _buildSection('Niveau', levels, currentFilters.level, (v) => onChanged(currentFilters.copyWith(level: v == 'Tous' ? null : v))),
          SizedBox(height: DesignTokens.gridSm),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> options, String? selected, ValueChanged<String> onSelect) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5), fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((opt) => FilterChip(
              label: opt,
              isSelected: (selected == null && opt == 'Tous') || selected == opt,
              onTap: () => onSelect(opt),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class SortSelector extends StatelessWidget {
  final String currentSort;
  final ValueChanged<String> onChanged;

  const SortSelector({super.key, required this.currentSort, required this.onChanged});

  static const options = [
    ('Récent', 'recent'),
    ('Populaire', 'popular'),
    ('Progression', 'progress'),
    ('Alphabétique', 'alpha'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Trier par:', style: TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
        const SizedBox(width: 8),
        ...options.map((opt) => Padding(
          padding: const EdgeInsets.only(right: 6),
          child: FilterChip(
            label: opt.$1,
            isSelected: currentSort == opt.$2,
            onTap: () => onChanged(opt.$2),
          ),
        )),
      ],
    );
  }
}
