import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/data/curriculum_data.dart';
import '../../core/data/lesson_content_data.dart';
import '../../core/models/course_model.dart';
import '../../core/services/storage_service.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final String subjectId;
  final String chapterId;
  final String lessonId;

  const LessonScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
    required this.lessonId,
  });

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  static const int _totalPages = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getLessonEmoji(String lessonId) {
    final seed = lessonId.hashCode;
    const emojis = ['📚', '🧠', '💡', '🔬', '📐', '🧪', '📝', '🎯', '🔢', '⚡'];
    return emojis[seed.abs() % emojis.length];
  }

  _LessonContent _resolveLessonContent(String lessonId, String title, String subtitle, {String bacSeries = 'D'}) {
    LessonContentData.init();
    final real = LessonContentData.get(lessonId);
    if (real != null) {
      return _LessonContent(
        subtitle: subtitle,
        contentBody: real.lessonBody,
        example: real.example,
        takeaways: real.takeaways,
      );
    }

    final introText = 'Dans cette le\u00e7on, nous allons \u00e9tudier les concepts fondamentaux de $title. '
        'Au programme du Bac $bacSeries, ce chapitre est essentiel pour comprendre les m\u00e9canismes '
        'qui sous-tendent ce domaine. Nous verrons ensemble les principes cl\u00e9s, les formules '
        '\u00e0 retenir et les applications pratiques.\n\n'
        'La compr\u00e9hension de $title est un pilier du programme de Terminale. '
        'Ce sujet appara\u00eet r\u00e9guli\u00e8rement aux \u00e9preuves du Bac, et il est '
        'indispensable de maitriser les notions pr\u00e9sent\u00e9es dans cette le\u00e7on. '
        'Nous aborderons les d\u00e9finitions, les propri\u00e9t\u00e9s et les d\u00e9monstrations.\n\n'
        'Formule fondamentale : $title permet d\'\u00e9tablir une relation directe entre les grandeurs '
        'en pr\u00e9sence. On note souvent cette relation sous la forme g\u00e9n\u00e9rale.\n\n'
        'Au Bac $bacSeries, ce type de question est trait\u00e9 dans la partie II du sujet. '
        'L\'ann\u00e9e pr\u00e9c\u00e9dente, une question portant sur $title a \u00e9t\u00e9 '
        'pos\u00e9e avec un coefficient important.';

    final example = 'Soit un \u00e9nonc\u00e9 portant sur $title. On demande de d\u00e9terminer la '
        'relation fondamentale qui lie les grandeurs en jeu.\n\n'
        'D\u00e9marche : On identifie les grandeurs connues, on applique la formule '
        'de $title, puis on r\u00e9sout l\'\u00e9quation obtenue.\n\n'
        'Conclusion : La r\u00e9solution montre que la valeur recherch\u00e9e est directement '
        'obtenue par application de la formule.';

    final takeaways = [
      'D\u00e9finition et propri\u00e9t\u00e9s de $title',
      'Formule principale \u00e0 retenir absolument',
      'M\u00e9thode de d\u00e9monstration en 3 \u00e9tapes',
      'Applications aux exercices types du Bac',
      'Erreurs fr\u00e9quentes \u00e0 \u00e9viter lors de l\'\u00e9preuve',
    ];

    return _LessonContent(
      subtitle: subtitle,
      contentBody: introText,
      example: example,
      takeaways: takeaways,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lesson = CurriculumData.findLessonById(widget.lessonId);
    final chapter = CurriculumData.findChapterById(widget.chapterId);
    final subject = CurriculumData.findById(widget.subjectId);
    final bacSeries = subject?.bacSeries ?? 'D';
    final lessonEmoji = _getLessonEmoji(widget.lessonId);
    final content = _resolveLessonContent(
      widget.lessonId,
      lesson?.title ?? 'Le\u00e7on',
      lesson?.subtitle ?? '',
      bacSeries: bacSeries,
    );

    final totalLessons = chapter?.lessons.length ?? 1;
    final lessonOrder = lesson?.order ?? 1;

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context, chapter?.title ?? '', lessonOrder, totalLessons),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _totalPages,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) => _buildCard(index, lesson?.title ?? '', lessonEmoji, content, bacSeries: bacSeries),
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, String chapterTitle, int lessonNum, int totalLessons) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(DesignTokens.grid2x, DesignTokens.gridBase, DesignTokens.grid2x, 0),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OuroColors.glassBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: OuroColors.textSecondary, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  chapterTitle,
                  style: const TextStyle(
                    color: OuroColors.textPrimary,
                    fontSize: DesignTokens.textLg,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showNotesSheet,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OuroColors.glassBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.note_alt_outlined,
                      color: OuroColors.textSecondary, size: 18),
                ),
              ),
              const SizedBox(width: 36),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Le\u00e7on $lessonNum/$totalLessons',
                style: TextStyle(
                  color: OuroColors.textSecondary.withValues(alpha: 0.6),
                  fontSize: DesignTokens.textSm,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: lessonNum / max(totalLessons, 1),
                    minHeight: 3,
                    backgroundColor: OuroColors.glassBorder,
                    valueColor: const AlwaysStoppedAnimation(OuroColors.meshBlue),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: DesignTokens.durationNormal).slideX(begin: -0.04);
  }

  Widget _buildCard(int index, String title, String emoji, _LessonContent content, {String bacSeries = 'D'}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x, vertical: DesignTokens.grid2x),
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        borderRadius: 24,
        child: _buildCardContent(index, title, emoji, content, bacSeries: bacSeries),
      ),
    ).animate().fadeIn(
      duration: DesignTokens.durationSlow,
      delay: (index * 80).ms,
    ).slideY(begin: 0.06, duration: DesignTokens.durationSlow, delay: (index * 80).ms);
  }

  Widget _buildCardContent(int index, String title, String emoji, _LessonContent content, {String bacSeries = 'D'}) {
    switch (index) {
      case 0:
        return _buildIntroduction(title, emoji, content, bacSeries: bacSeries);
      case 1:
        return _buildLessonContent(title, content);
      case 2:
        return _buildExample(title, content);
      case 3:
        return _buildTakeaways(content);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildIntroduction(String title, String emoji, _LessonContent content, {String bacSeries = 'D'}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 64),
            ),
          ).animate().scale(
            duration: DesignTokens.durationSlow,
            curve: Curves.easeOutBack,
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Introduction',
              style: GoogleFonts.spaceGrotesk(
                color: OuroColors.meshBlue,
                fontSize: DesignTokens.textSm,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              color: OuroColors.textPrimary,
              fontSize: DesignTokens.text3xl,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            content.subtitle,
            style: TextStyle(
              color: OuroColors.textSecondary.withValues(alpha: 0.7),
              fontSize: DesignTokens.textMd,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: OuroColors.meshBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: OuroColors.meshBlue.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Bac $bacSeries',
                style: GoogleFonts.spaceGrotesk(
                  color: OuroColors.meshBlue,
                  fontSize: DesignTokens.textSm,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonContent(String title, _LessonContent content) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'La le\u00e7on',
            style: GoogleFonts.spaceGrotesk(
              color: OuroColors.meshBlue,
              fontSize: DesignTokens.textSm,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content.contentBody,
            style: const TextStyle(
              color: OuroColors.textPrimary,
              fontSize: DesignTokens.textMd,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExample(String title, _LessonContent content) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exemple',
            style: GoogleFonts.spaceGrotesk(
              color: OuroColors.meshBlue,
              fontSize: DesignTokens.textSm,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: 16,
            child: Text(
              content.example,
              style: const TextStyle(
                color: OuroColors.textPrimary,
                fontSize: DesignTokens.textMd,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTakeaways(_LessonContent content) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u00c0 retenir',
            style: GoogleFonts.spaceGrotesk(
              color: OuroColors.meshBlue,
              fontSize: DesignTokens.textSm,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  OuroColors.meshBlue.withValues(alpha: 0.08),
                  OuroColors.accentPurple.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: OuroColors.meshBlue.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...content.takeaways.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: OuroColors.localGreen, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              color: OuroColors.textPrimary,
                              fontSize: DesignTokens.textMd,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNotesSheet() {
    final notes = StorageService.getNotes(widget.lessonId);
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => GestureDetector(
        onTap: () => FocusScope.of(ctx).unfocus(),
        child: Container(
          height: MediaQuery.of(ctx).size.height * 0.75,
          decoration: const BoxDecoration(
            color: OuroColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: OuroColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.note_alt, color: OuroColors.meshBlue, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Mes notes',
                      style: GoogleFonts.spaceGrotesk(
                        color: OuroColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${notes.length} note${notes.length > 1 ? 's' : ''}',
                      style: const TextStyle(color: OuroColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Divider(color: OuroColors.glassBorder, height: 1),
              Expanded(
                child: notes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.note_add,
                                color: OuroColors.textTertiary.withValues(alpha: 0.4), size: 48),
                            const SizedBox(height: 12),
                            Text('Aucune note pour cette le\u00e7on',
                              style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5), fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text('\u00c9cris tes notes ci-dessous',
                              style: TextStyle(color: OuroColors.textTertiary, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: notes.length,
                        itemBuilder: (_, i) {
                          final note = notes[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: OuroColors.glassBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: OuroColors.glassBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(note.content,
                                  style: const TextStyle(color: OuroColors.textPrimary, fontSize: 14, height: 1.4),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                                  style: const TextStyle(color: OuroColors.textTertiary, fontSize: 11),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 16, right: 16, top: 8,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
                ),
                decoration: const BoxDecoration(
                  color: OuroColors.surfaceElevated,
                  border: Border(top: BorderSide(color: OuroColors.glassBorder, width: 0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        maxLines: 3,
                        minLines: 1,
                        style: const TextStyle(color: OuroColors.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: '\u00c9cris une note...',
                          hintStyle: const TextStyle(color: OuroColors.textTertiary),
                          filled: true,
                          fillColor: OuroColors.glassBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        final text = controller.text.trim();
                        if (text.isEmpty) return;
                        StorageService.saveNote(
                          NoteModel(
                            id: StorageService.generateId(),
                            chapterId: widget.lessonId,
                            content: text,
                            createdAt: DateTime.now(),
                          ),
                        );
                        controller.clear();
                        setState(() {});
                        Navigator.of(ctx).pop();
                        _showNotesSheet();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: OuroColors.meshBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final isLastPage = _currentPage == _totalPages - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(DesignTokens.grid3x, 8, DesignTokens.grid3x, DesignTokens.grid3x),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_totalPages, (i) {
              final isActive = i == _currentPage;
              return AnimatedContainer(
                duration: DesignTokens.durationFast,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? OuroColors.meshBlue
                      : OuroColors.textTertiary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              if (isLastPage) {
                context.go(
                  '/curriculum/subject/${widget.subjectId}/chapter/${widget.chapterId}/lesson/${widget.lessonId}/quiz',
                );
              } else {
                _pageController.nextPage(
                  duration: DesignTokens.durationNormal,
                  curve: Curves.easeOutCubic,
                );
              }
            },
            child: AnimatedContainer(
              duration: DesignTokens.durationFast,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isLastPage
                      ? [OuroColors.meshBlue, OuroColors.accentPurple]
                      : [OuroColors.meshBlue.withValues(alpha: 0.8), OuroColors.meshBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: OuroColors.meshBlue.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastPage ? 'D\u00e9marrer le quiz' : 'Suivant',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: DesignTokens.textLg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isLastPage ? Icons.play_arrow_rounded : Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: DesignTokens.durationNormal, delay: 200.ms);
  }
}

class _LessonContent {
  final String subtitle;
  final String contentBody;
  final String example;
  final List<String> takeaways;

  const _LessonContent({
    required this.subtitle,
    required this.contentBody,
    required this.example,
    required this.takeaways,
  });
}
