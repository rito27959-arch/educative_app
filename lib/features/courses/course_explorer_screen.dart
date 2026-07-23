import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/extensions.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../design_system/widgets/ouro_inputs.dart';
import '../../design_system/widgets/ouro_chips.dart';
import '../../core/models/course_model.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/content_service.dart';
import '../../shared/widgets/ouro_bottom_nav.dart';
import '../../shared/widgets/loading_widgets.dart';
import '../../shared/widgets/sheets.dart';
import '../../design_system/widgets/ouro_animations.dart';

class CourseExplorerScreen extends ConsumerStatefulWidget {
  const CourseExplorerScreen({super.key});

  @override
  ConsumerState<CourseExplorerScreen> createState() => _CourseExplorerScreenState();
}

class _CourseExplorerScreenState extends ConsumerState<CourseExplorerScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'Tous';
  final _filters = ['Tous', 'PDF', 'Vidéo', 'Quiz'];
  List<CourseModel> _courses = [];
  bool _isLoading = true;

  String _sortBy = 'Récent';
  bool _showOnlyAvailable = false;
  int _selectedCategory = 0;
  final List<String> _categories = ['Tout', 'Maths', 'Physique', 'Info', 'Littérature', 'Histoire', 'Anglais'];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    setState(() {
      _courses = StorageService.getCourses();
      _isLoading = false;
    });
  }

  List<CourseModel> get _filteredCourses {
    final category = _categories[_selectedCategory];
    var result = _courses.where((c) {
      if (_selectedFilter != 'Tous' && c.type != _selectedFilter) return false;
      if (category != 'Tout' && !c.subject.contains(category)) return false;
      if (_showOnlyAvailable && c.availability.index != 1) return false;
      if (_searchController.text.isNotEmpty &&
          !c.title.toLowerCase().contains(_searchController.text.toLowerCase()) &&
          !c.subject.toLowerCase().contains(_searchController.text.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    if (_sortBy == 'Populaire') {
      result.sort((a, b) => b.lessonCount.compareTo(a.lessonCount));
    } else {
      result.sort((a, b) => b.id.compareTo(a.id));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OuroColors.background,
      body: Stack(
        children: [
          const AnimatedGradientBackground(child: SizedBox.expand()),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
                  child: OuroSearchBar(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    hint: 'Rechercher un cours, une matière...',
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: DesignTokens.grid3x),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: OuroFilterChip(
                          label: f,
                          selected: _selectedFilter == f,
                          onSelected: (_) => setState(() => _selectedFilter = f),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildCategoryBar(),
                const SizedBox(height: 12),
                _buildSortAndFilterBar(),
                const SizedBox(height: 8),
                if (_isLoading)
                  Expanded(
                    child: ListView(
                      children: List.generate(6, (_) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: SkeletonCard(height: 80),
                      )),
                    ),
                  )
                else if (_filteredCourses.isEmpty)
                  Expanded(child: _buildEmptyState())
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
                      itemCount: _filteredCourses.length,
                      itemBuilder: (context, index) =>
                          _buildCourseCard(_filteredCourses[index], index),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: OuroBottomNav(currentRoute: '/courses'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(DesignTokens.grid3x, DesignTokens.gridSm, DesignTokens.grid3x, DesignTokens.gridMd),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/dashboard'),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Explorateur de Cours',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
          GestureDetector(
            onTap: () => context.showOuroBottomSheet(
              FilterSheet(currentFilter: _selectedFilter, onFilterChanged: (f) {
                setState(() => _selectedFilter = f);
              }),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune, color: OuroColors.textSecondary, size: 20),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -20, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, color: OuroColors.textSecondary.withValues(alpha: 0.3), size: 64),
          const SizedBox(height: 16),
          const Text(
            'Aucun cours trouvé',
            style: TextStyle(color: OuroColors.textSecondary, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Essaie de modifier tes filtres',
            style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5), fontSize: 13),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() => _selectedFilter = 'Tous');
            },
            child: const Text('Réinitialiser', style: TextStyle(color: OuroColors.meshBlue)),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(CourseModel course, int index) {
    return OuroFadeIn(
      delay: 200 + index * 60,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
        onTap: () async {
          final chapters = await ContentService.getChapters(course.id);
          final chapterId = chapters.isNotEmpty ? chapters.first['id'] as String : StorageService.generateId();
          StorageService.saveChapter(ChapterModel(
            id: chapterId,
            courseId: course.id,
            title: chapters.isNotEmpty ? chapters.first['title'] as String : 'Chapitre 1: ${course.title}',
            type: course.type,
            availability: course.availability,
          ));
          if (mounted) context.go('/reader/${course.id}/$chapterId');
        },
        onLongPress: () {
          context.showOuroBottomSheet(const ShareSheet());
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: OuroColors.cardDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: OuroColors.glassBorder, width: 0.3),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _getSubjectColor(course.subject).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _getSubjectIcon(course.subject),
                  color: _getSubjectColor(course.subject),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        OuroTagChip(label: course.subject),
                        const SizedBox(width: 8),
                        Icon(
                          course.availability.index == 0 ? Icons.cloud_download_outlined : Icons.check_circle,
                          size: 14,
                          color: course.availability.index == 0 ? OuroColors.textSecondary : OuroColors.localGreen,
                        ),
                        const Spacer(),
                        Text(
                          '${course.lessonCount} leçons',
                          style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                    if (course.progress > 0) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: course.progress,
                          backgroundColor: OuroColors.glassBg,
                          valueColor: AlwaysStoppedAnimation(
                            _getSubjectColor(course.subject),
                          ),
                          minHeight: 3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: OuroColors.textSecondary.withValues(alpha: 0.3), size: 20),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: DesignTokens.grid3x),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isActive = _selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: AnimatedContainer(
              duration: 300.ms,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? OuroColors.meshBlue.withValues(alpha: 0.15)
                    : OuroColors.glassBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive
                      ? OuroColors.meshBlue.withValues(alpha: 0.3)
                      : OuroColors.glassBorder,
                ),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: isActive ? OuroColors.meshBlue : OuroColors.textSecondary,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildSortAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _sortBy = _sortBy == 'Récent' ? 'Populaire' : 'Récent';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: OuroColors.glassBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sort, color: OuroColors.textSecondary, size: 14),
                  const SizedBox(width: 4),
                  Text(_sortBy, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: OuroColors.textSecondary, size: 14),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _showOnlyAvailable = !_showOnlyAvailable),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _showOnlyAvailable
                    ? OuroColors.localGreen.withValues(alpha: 0.1)
                    : OuroColors.glassBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _showOnlyAvailable
                      ? OuroColors.localGreen.withValues(alpha: 0.3)
                      : OuroColors.glassBorder,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _showOnlyAvailable ? Icons.check_circle : Icons.cloud_download_outlined,
                    color: _showOnlyAvailable ? OuroColors.localGreen : OuroColors.textSecondary,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Disponible',
                    style: TextStyle(
                      color: _showOnlyAvailable ? OuroColors.localGreen : OuroColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Text(
            '${_filteredCourses.length} cours',
            style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Mathématiques': return OuroColors.meshBlue;
      case 'Physique': return OuroColors.ouroOrange;
      case 'Informatique': return OuroColors.localGreen;
      case 'Littérature': return Colors.purple;
      default: return OuroColors.textSecondary;
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Mathématiques': return Icons.functions;
      case 'Physique': return Icons.science;
      case 'Informatique': return Icons.computer;
      case 'Littérature': return Icons.menu_book;
      default: return Icons.school;
    }
  }
}
