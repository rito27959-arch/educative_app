import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../design_system/widgets/ouro_cards.dart';
import '../../core/models/course_model.dart';
import '../../core/services/content_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/extensions.dart';
import '../../core/providers/llm_provider.dart';
class ReaderScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String chapterId;
  final String? lessonId;
  final bool fromCurriculum;

  const ReaderScreen({
    super.key,
    required this.courseId,
    required this.chapterId,
    this.lessonId,
    this.fromCurriculum = false,
  });

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _noteController = TextEditingController();
  int _currentQuizIndex = 0;
  int? _selectedAnswer;
  int _score = 0;
  bool _quizCompleted = false;
  double _readingProgress = 0.0;
  bool _isBookmarked = false;
  Map<String, dynamic>? _chapterData;
  List<QuizModel> _quiz = [];

  double _fontSize = 16;
  bool _darkModeReader = true;
  int _currentPage = 1;
  final int _totalPages = 24;
  bool _showSidebar = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.fromCurriculum ? 3 : 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _loadChapter();
  }

  final _chatInputCtrl = TextEditingController();
  final _chatFocusNode = FocusNode();

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    _chatInputCtrl.dispose();
    _chatFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadChapter() async {
    final chapter = await ContentService.getChapter(
      widget.courseId,
      widget.chapterId,
    );
    if (chapter != null && mounted) {
      setState(() {
        _chapterData = chapter;
        final quizData = chapter['quiz'] as List<dynamic>? ?? [];
        _quiz = quizData.map((q) => QuizModel(
          id: q['id'] ?? '',
          chapterId: widget.chapterId,
          question: q['question'] ?? '',
          options: List<String>.from(q['options'] ?? []),
          correctIndex: q['correctIndex'] ?? 0,
        )).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OuroColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                _buildContentViewer(),
                _buildProgressBar(),
                _buildReadingControls(),
                _buildTabBar(),
                Expanded(child: _buildTabContent()),
              ],
            ),
          ),
          if (_showSidebar)
            _buildSidebar(),
          ],

      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(DesignTokens.grid3x, DesignTokens.gridSm, DesignTokens.grid3x, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _chapterData?['title'] ?? 'Chapitre',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.fromCurriculum && widget.lessonId != null)
            GestureDetector(
              onTap: () => GoRouter.of(context).push('/curriculum/subject/${widget.courseId}/chapter/${widget.chapterId}/lesson/${widget.lessonId}/quiz'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: OuroColors.ouroOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.quiz, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text('Quiz', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () => GoRouter.of(context).push('/learn/${widget.courseId}/${widget.chapterId}'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: OuroColors.brandGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text('Apprendre', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _isBookmarked = !_isBookmarked),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                color: _isBookmarked ? OuroColors.meshBlue : OuroColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -20, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildContentViewer() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(DesignTokens.grid3x),
      decoration: BoxDecoration(
        color: OuroColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: OuroColors.glassBorder, width: 0.3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _chapterData == null
            ? const Center(child: CircularProgressIndicator(color: OuroColors.meshBlue))
            : Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.transparent,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollUpdateNotification) {
                            final max = notification.metrics.maxScrollExtent;
                            final current = notification.metrics.pixels;
                            if (max > 0) {
                              setState(() {
                                _readingProgress = (current / max).clamp(0.0, 1.0);
                              });
                            }
                          }
                          return false;
                        },
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: OuroColors.meshBlue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _chapterData!['title'] ?? '',
                                  style: const TextStyle(color: OuroColors.meshBlue, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...(_chapterData!['content'] as String? ?? '').split('\n\n').map((p) {
                                final trimmed = p.trim();
                                if (trimmed.startsWith('**') && trimmed.endsWith('**')) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                                    child: Text(
                                      trimmed.substring(2, trimmed.length - 2),
                                      style: TextStyle(color: OuroColors.meshBlue, fontSize: _fontSize + 2, fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    trimmed,
                                    style: TextStyle(color: Colors.white, fontSize: _fontSize, height: 1.4),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: OuroColors.meshBlue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${(_readingProgress * 100).toInt()}%',
                        style: const TextStyle(color: OuroColors.meshBlue, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 20, end: 0, duration: 500.ms, delay: 100.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: _readingProgress),
          duration: 500.ms,
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return LinearProgressIndicator(
              value: value,
              backgroundColor: OuroColors.glassBg,
              valueColor: const AlwaysStoppedAnimation(OuroColors.meshBlue),
              minHeight: 3,
            );
          }),
        ),
      );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(DesignTokens.grid3x, 12, DesignTokens.grid3x, 0),
      decoration: BoxDecoration(
        color: OuroColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: OuroColors.glassBorder, width: 0.3),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: OuroColors.meshBlue.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: OuroColors.meshBlue,
        unselectedLabelColor: OuroColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        tabs: widget.fromCurriculum ? const [
          Tab(text: 'Notes'),
          Tab(text: 'Résumé'),
          Tab(text: 'Chat'),
        ] : const [
          Tab(text: 'Notes'),
          Tab(text: 'Quiz'),
          Tab(text: 'Résumé'),
          Tab(text: 'Chat'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Padding(
      padding: const EdgeInsets.all(DesignTokens.grid3x),
      child: TabBarView(
        controller: _tabController,
        children: widget.fromCurriculum ? [
          _buildNotesTab(),
          _buildSummaryTab(),
          _buildChatTab(),
        ] : [
          _buildNotesTab(),
          _buildQuizTab(),
          _buildSummaryTab(),
          _buildChatTab(),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    final notes = StorageService.getNotes(widget.chapterId);

    return Column(
      children: [
        Expanded(
          child: notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.note_outlined, color: OuroColors.textSecondary.withValues(alpha: 0.3), size: 48),
                      const SizedBox(height: 12),
                      Text('Aucune note', style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5))),
                      const SizedBox(height: 4),
                      Text('Prends des notes en dessous', style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.3), fontSize: 12)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: OuroColors.cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: OuroColors.glassBorder, width: 0.3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(note.content, style: const TextStyle(color: Colors.white, fontSize: 14)),
                          const SizedBox(height: 8),
                          Text(
                            note.createdAt.timeAgo,
                            style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.4), fontSize: 10),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GlassContainer(
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _noteController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 3,
                  minLines: 1,
                  decoration: const InputDecoration(
                    hintText: 'Ajouter une note...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: OuroColors.textSecondary),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                if (_noteController.text.trim().isNotEmpty) {
                  StorageService.saveNote(NoteModel(
                    id: StorageService.generateId(),
                    chapterId: widget.chapterId,
                    content: _noteController.text.trim(),
                    createdAt: DateTime.now(),
                  ));
                  _noteController.clear();
                  setState(() {});
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: OuroColors.meshBlue,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: DesignTokens.glow(OuroColors.meshBlue, radius: 12),
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuizTab() {
    if (_quizCompleted) {
      final percentage = (_score / _quiz.length * 100).round();
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Quiz Terminé!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: percentage >= 70 ? OuroColors.localGreen : OuroColors.ouroOrange,
                  width: 4,
                ),
              ),
              child: Center(
                child: Text(
                  '$_score/${_quiz.length}',
                  style: TextStyle(
                    color: percentage >= 70 ? OuroColors.localGreen : OuroColors.ouroOrange,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              percentage >= 80 ? 'Excellent!' : percentage >= 60 ? 'Pas mal!' : 'Continue à réviser!',
              style: TextStyle(
                color: percentage >= 80 ? OuroColors.localGreen : OuroColors.textSecondary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentQuizIndex = 0;
                      _selectedAnswer = null;
                      _score = 0;
                      _quizCompleted = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: OuroColors.meshBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: OuroColors.meshBlue.withValues(alpha: 0.3)),
                    ),
                    child: const Text('Recommencer', style: TextStyle(color: OuroColors.meshBlue)),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _tabController.animateTo(2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: OuroColors.meshBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('Voir Résumé', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final quiz = _quiz[_currentQuizIndex];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Question ${_currentQuizIndex + 1}/${_quiz.length}',
                style: const TextStyle(color: OuroColors.textSecondary, fontSize: 14),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: OuroColors.meshBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${((_currentQuizIndex + 1) / _quiz.length * 100).toInt()}%',
                  style: const TextStyle(color: OuroColors.meshBlue, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentQuizIndex + 1) / _quiz.length,
              backgroundColor: OuroColors.glassBg,
              valueColor: const AlwaysStoppedAnimation(OuroColors.meshBlue),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 24),
          Text(quiz.question, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 20),
          ...quiz.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final option = entry.value;
            final isSelected = _selectedAnswer == idx;
            final isCorrect = quiz.correctIndex == idx;

            Color? borderColor;
            if (_selectedAnswer != null) {
              borderColor = isCorrect ? OuroColors.localGreen : isSelected ? OuroColors.errorRed : null;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: _selectedAnswer == null ? () {
                  setState(() => _selectedAnswer = idx);
                  Future.delayed(800.ms, () {
                    if (idx == quiz.correctIndex) _score++;
                    if (_currentQuizIndex < _quiz.length - 1) {
                      setState(() { _currentQuizIndex++; _selectedAnswer = null; });
                    } else {
                      setState(() => _quizCompleted = true);
                    }
                  });
                } : null,
                child: AnimatedContainer(
                  duration: 300.ms,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedAnswer != null && isCorrect
                        ? OuroColors.localGreen.withValues(alpha: 0.1)
                        : isSelected ? OuroColors.errorRed.withValues(alpha: 0.1) : OuroColors.cardDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor ?? OuroColors.glassBorder, width: borderColor != null ? 1.0 : 0.3),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: isSelected || isCorrect ? borderColor?.withValues(alpha: 0.2) : OuroColors.glassBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(child: Text(String.fromCharCode(65 + idx), style: TextStyle(color: isSelected || isCorrect ? borderColor : OuroColors.textSecondary, fontWeight: FontWeight.w600))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(option, style: const TextStyle(color: Colors.white, fontSize: 15))),
                      if (isSelected || isCorrect) Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: borderColor, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    final content = _chapterData?['content'] as String? ?? '';
    final sentences = content.split(RegExp(r'(?<=[.!?])\s+'));
    final summary = sentences.length > 3
        ? sentences.take((sentences.length * 0.3).ceil()).join(' ')
        : content;

    final allWords = content.split(RegExp(r'\s+')).where((w) => w.length > 4).toSet().toList();
    allWords.shuffle();
    final keywords = allWords.take(8).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          OuroCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: OuroColors.meshBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.summarize, color: OuroColors.meshBlue, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _chapterData?['title'] != null ? 'Résumé — ${_chapterData!['title']}' : 'Résumé du Chapitre',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  summary.isNotEmpty ? summary : content.isNotEmpty
                      ? 'Contenu : ${content.length} caractères'
                      : 'Aucun résumé disponible pour ce chapitre.',
                  style: TextStyle(color: OuroColors.textSecondary, fontSize: _fontSize, height: 1.6),
                ),
              ],
            ),
          ),
          if (keywords.isNotEmpty) ...[
            const SizedBox(height: 16),
            OuroCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mots-clés', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: keywords.map((w) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: OuroColors.meshBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: OuroColors.meshBlue.withValues(alpha: 0.2)),
                        ),
                        child: Text(w, style: const TextStyle(color: OuroColors.meshBlue, fontSize: 12)),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          OuroCard(
            child: Row(
              children: [
                const Icon(Icons.download, color: OuroColors.localGreen, size: 20),
                const SizedBox(width: 12),
                const Expanded(child: Text('Télécharger le résumé PDF', style: TextStyle(color: Colors.white, fontSize: 15))),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OuroColors.localGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.download_done, color: OuroColors.localGreen, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    final chatState = ref.watch(llmChatProvider);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == chatState.messages.length && chatState.isLoading) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: OuroColors.meshBlue.withValues(alpha: 0.2),
                        ),
                        child: const Icon(Icons.auto_awesome, color: OuroColors.meshBlue, size: 14),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: OuroColors.cardDark,
                          borderRadius: BorderRadius.circular(14).copyWith(bottomLeft: Radius.zero),
                        ),
                        child: const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: OuroColors.meshBlue),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final msg = chatState.messages[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!msg.isUser) ...[
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: OuroColors.meshBlue.withValues(alpha: 0.2),
                        ),
                        child: const Icon(Icons.auto_awesome, color: OuroColors.meshBlue, size: 14),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: msg.isUser ? OuroColors.meshBlue.withValues(alpha: 0.15) : OuroColors.cardDark,
                          borderRadius: BorderRadius.circular(14).copyWith(
                            bottomLeft: msg.isUser ? null : Radius.zero,
                            bottomRight: msg.isUser ? Radius.zero : null,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 14)),
                            if (!msg.isOnline && !msg.isUser) ...[
                              const SizedBox(height: 4),
                              Text('Hors-ligne', style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5), fontSize: 9)),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (msg.isUser) const SizedBox(width: 8),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: GlassContainer(
                  borderRadius: 16,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _chatInputCtrl,
                    focusNode: _chatFocusNode,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Pose une question...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: OuroColors.textSecondary),
                    ),
                    onSubmitted: chatState.isLoading ? null : (v) {
                      if (v.trim().isNotEmpty) {
                        ref.read(llmChatProvider.notifier).sendMessage(v.trim());
                        _chatInputCtrl.clear();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: chatState.isLoading ? null : () {
                  final text = _chatInputCtrl.text.trim();
                  if (text.isNotEmpty) {
                    ref.read(llmChatProvider.notifier).sendMessage(text);
                    _chatInputCtrl.clear();
                    _chatFocusNode.requestFocus();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: chatState.isLoading ? OuroColors.glassBg : OuroColors.meshBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    chatState.isLoading ? Icons.hourglass_empty : Icons.send,
                    color: Colors.white, size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReadingControls() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: OuroColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: OuroColors.glassBorder, width: 0.3),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _fontSize = (_fontSize - 2).clamp(12, 28)),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.text_decrease, color: OuroColors.textSecondary, size: 16),
            ),
          ),
          const SizedBox(width: 8),
          Text('${_fontSize.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _fontSize = (_fontSize + 2).clamp(12, 28)),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.text_increase, color: OuroColors.textSecondary, size: 16),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() => _darkModeReader = !_darkModeReader),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _darkModeReader ? Icons.dark_mode : Icons.light_mode,
                color: OuroColors.textSecondary, size: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _showSidebar = !_showSidebar),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: OuroColors.glassBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.menu_open, color: OuroColors.textSecondary, size: 16),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 150.ms);
  }

  Widget _buildSidebar() {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: () => setState(() => _showSidebar = false),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          color: OuroColors.surface,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(DesignTokens.grid3x),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Navigation', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                      IconButton(
                        icon: const Icon(Icons.close, color: OuroColors.textSecondary),
                        onPressed: () => setState(() => _showSidebar = false),
                      ),
                    ],
                  ),
                ),
                const Divider(color: OuroColors.glassBorder),
                Expanded(
                  child: ListView.builder(
                    itemCount: _totalPages,
                    itemBuilder: (context, index) {
                      final pageNum = index + 1;
                      final isCurrent = pageNum == _currentPage;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentPage = pageNum;
                            _readingProgress = pageNum / _totalPages;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x, vertical: 12),
                          decoration: BoxDecoration(
                            color: isCurrent ? OuroColors.meshBlue.withValues(alpha: 0.1) : null,
                            border: Border(
                              left: BorderSide(
                                color: isCurrent ? OuroColors.meshBlue : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 26, height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCurrent ? OuroColors.meshBlue.withValues(alpha: 0.2) : OuroColors.glassBg,
                                ),
                                child: Center(
                                  child: Text(
                                    '$pageNum',
                                    style: TextStyle(
                                      color: isCurrent ? OuroColors.meshBlue : OuroColors.textSecondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Page $pageNum',
                                style: TextStyle(
                                  color: isCurrent ? Colors.white : OuroColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              if (index < 3)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: OuroColors.localGreen.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('Lu', style: TextStyle(color: OuroColors.localGreen, fontSize: 8, fontWeight: FontWeight.w600)),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
