import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../design_system/ouro_colors.dart';
import '../../../design_system/design_tokens.dart';
import '../../../design_system/glassmorphism.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final isSearchingProvider = StateProvider<bool>((ref) => false);

class SearchDelegate {
  static List<T> filterByQuery<T>(List<T> items, String query, String Function(T) field) {
    if (query.isEmpty) return items;
    final q = query.toLowerCase();
    return items.where((item) => field(item).toLowerCase().contains(q)).toList();
  }

  static List<T> filterByTags<T>(List<T> items, List<String> tags, List<String> Function(T) getTags) {
    if (tags.isEmpty) return items;
    return items.where((item) {
      final itemTags = getTags(item).map((t) => t.toLowerCase());
      return tags.any((tag) => itemTags.contains(tag.toLowerCase()));
    }).toList();
  }
}

class SearchInput extends ConsumerWidget {
  final String hint;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  const SearchInput({
    super.key,
    this.hint = 'Rechercher...',
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: 16,
      child: TextField(
        autofocus: autofocus,
        style: const TextStyle(color: OuroColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5)),
          prefixIcon: Icon(Icons.search, color: OuroColors.textSecondary, size: 20),
          suffixIcon: query.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    ref.read(searchQueryProvider.notifier).state = '';
                    ref.read(isSearchingProvider.notifier).state = false;
                  },
                  child: Icon(Icons.close, color: OuroColors.textSecondary, size: 18),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (v) {
          ref.read(searchQueryProvider.notifier).state = v;
          ref.read(isSearchingProvider.notifier).state = v.isNotEmpty;
        },
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class FilterBar extends ConsumerWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onChanged;

  const FilterBar({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.grid2x),
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: EdgeInsets.only(right: DesignTokens.gridSm),
            child: GestureDetector(
              onTap: () => onChanged(filter),
              child: AnimatedContainer(
                duration: DesignTokens.durationFast,
                padding: EdgeInsets.symmetric(horizontal: DesignTokens.gridMd, vertical: DesignTokens.gridSm),
                decoration: BoxDecoration(
                  color: isSelected ? OuroColors.meshBlue.withValues(alpha: 0.15) : OuroColors.glassBg,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                  border: Border.all(
                    color: isSelected ? OuroColors.meshBlue.withValues(alpha: 0.3) : OuroColors.glassBorder,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? OuroColors.meshBlue : OuroColors.textSecondary,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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

class SearchResultTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const SearchResultTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: OuroColors.textSecondary.withValues(alpha: 0.3), size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResults extends StatelessWidget {
  final List<Widget> results;
  final String emptyMessage;

  const SearchResults({
    super.key,
    required this.results,
    this.emptyMessage = 'Aucun résultat trouvé',
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.grid4x),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, color: OuroColors.textSecondary.withValues(alpha: 0.3), size: 48),
              const SizedBox(height: 16),
              Text(emptyMessage, style: TextStyle(color: OuroColors.textSecondary, fontSize: 14)),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      separatorBuilder: (_, __) => Divider(color: OuroColors.glassBorder.withValues(alpha: 0.1), height: 1),
      itemBuilder: (_, i) => results[i],
    );
  }
}
