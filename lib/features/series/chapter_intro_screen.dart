import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/gamification_service.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../design_system/widgets/ouro_buttons.dart';

class ChapterIntroScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String chapterId;
  const ChapterIntroScreen({super.key, required this.courseId, required this.chapterId});

  @override
  ConsumerState<ChapterIntroScreen> createState() => _ChapterIntroScreenState();
}

class _ChapterIntroScreenState extends ConsumerState<ChapterIntroScreen> {
  int _step = 0;
  int _currentQuestion = 0;
  int _correctAnswers = 0;
  List<Map<String, dynamic>>? _introQuiz;
  Map<String, dynamic>? _introData;

  @override
  void initState() {
    super.initState();
    _introData = GamificationService.getIntroSection(widget.courseId, widget.chapterId);
    final quizRaw = _introData?['quiz'] as List<dynamic>?;
    if (quizRaw != null) {
      _introQuiz = quizRaw.cast<Map<String, dynamic>>();
    }
  }

  void _submitAnswer(int selected) {
    if (_introQuiz == null || _currentQuestion >= _introQuiz!.length) return;
    if (selected == _introQuiz![_currentQuestion]['correctIndex']) {
      _correctAnswers++;
    }
    if (_currentQuestion < _introQuiz!.length - 1) {
      setState(() => _currentQuestion++);
    } else {
      final total = _introQuiz!.length;
      final pct = _correctAnswers / total;
      if (pct >= 0.8) {
        GamificationService.completeSection(_introData!['id'] as String);
        setState(() => _step = 2);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) GoRouter.of(context).replace('/learn/${widget.courseId}/${widget.chapterId}/sections');
        });
      } else {
        setState(() => _step = 3);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: _step == 0 ? _buildIntroView() : _step == 1 ? _buildQuizView() : _step == 2 ? _buildSuccessView() : _buildFailureView(),
        ),
      ),
    );
  }

  Widget _buildIntroView() {
    final content = _introData?['content'] as String? ?? '';
    return SingleChildScrollView(
      padding: EdgeInsets.all(DesignTokens.grid4x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(height: DesignTokens.grid4x),
          Text(
            _introData?['title'] as String? ?? 'Introduction',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: OuroColors.textPrimary),
          ),
          SizedBox(height: DesignTokens.grid2x),
          GlassContainer(
            padding: EdgeInsets.all(DesignTokens.grid4x),
            borderRadius: 20,
            child: Text(
              content,
              style: const TextStyle(fontSize: 15, color: OuroColors.textSecondary, height: 1.7),
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05),
          SizedBox(height: DesignTokens.grid4x),
          OuroButton(
            label: 'Commencer le quiz',
            onPressed: () => setState(() => _step = 1),
            variant: OuroButtonVariant.primary,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizView() {
    if (_introQuiz == null || _introQuiz!.isEmpty) {
      return const Center(child: Text('Aucune question', style: TextStyle(color: OuroColors.textSecondary)));
    }
    final q = _introQuiz![_currentQuestion];
    final options = (q['options'] as List<dynamic>).cast<String>();
    return Padding(
      padding: EdgeInsets.all(DesignTokens.grid4x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _step = 0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OuroColors.glassBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                ),
              ),
              const Spacer(),
              Text(
                '${_currentQuestion + 1}/${_introQuiz!.length}',
                style: const TextStyle(fontSize: 14, color: OuroColors.textSecondary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: DesignTokens.grid3x),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentQuestion + 1) / _introQuiz!.length,
              backgroundColor: OuroColors.glassBg,
              valueColor: const AlwaysStoppedAnimation(OuroColors.meshBlue),
              minHeight: 6,
            ),
          ),
          SizedBox(height: DesignTokens.grid4x),
          GlassContainer(
            padding: const EdgeInsets.all(24),
            borderRadius: 20,
            child: Text(
              q['question'] as String,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: OuroColors.textPrimary),
            ),
          ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.03),
          SizedBox(height: DesignTokens.grid3x),
          ...options.asMap().entries.map((e) => Padding(
            padding: EdgeInsets.only(bottom: DesignTokens.grid2x),
            child: GestureDetector(
              onTap: () => _submitAnswer(e.key),
              child: GlassContainer(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                borderRadius: 14,
                child: Row(
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: OuroColors.meshBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: OuroColors.glassBorder),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + e.key),
                          style: const TextStyle(color: OuroColors.meshBlue, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(e.value, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms, delay: (50 * e.key).ms).slideX(begin: 0.03),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: OuroColors.successGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: OuroColors.successGreen.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.check_circle, size: 64, color: OuroColors.successGreen),
          ),
          SizedBox(height: DesignTokens.grid3x),
          const Text('Bravo !', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: OuroColors.successGreen))
              .animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          SizedBox(height: DesignTokens.grid2x),
          const Text('Prêt pour le chapitre', style: TextStyle(fontSize: 16, color: OuroColors.textSecondary)),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildFailureView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: OuroColors.errorRed.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: OuroColors.errorRed.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.refresh, size: 64, color: OuroColors.errorRed),
          ),
          SizedBox(height: DesignTokens.grid3x),
          const Text('Réessaie encore !', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: OuroColors.textPrimary)),
          SizedBox(height: DesignTokens.grid3x),
          OuroButton(
            label: 'Réessayer',
            onPressed: () => setState(() { _step = 0; _currentQuestion = 0; _correctAnswers = 0; }),
            variant: OuroButtonVariant.secondary,
          ),
        ],
      ),
    );
  }
}
