import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../core/services/storage_service.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/mesh_provider.dart';
import '../../core/models/mesh_message.dart';
import '../../shared/widgets/avatar_widget.dart';
import '../../shared/widgets/animated_ring.dart';
import '../../shared/widgets/ouro_bottom_nav.dart';
import '../../shared/widgets/loading_widgets.dart';
import '../../shared/widgets/mesh_status.dart';
import '../../shared/widgets/progression_card.dart';
import '../../core/repositories/course_repository.dart';
import '../../core/models/series_model.dart';
import '../../core/repositories/user_repository.dart';
import '../../core/services/gamification_service.dart';
import '../../core/providers/gamification_provider.dart';
import '../../core/providers/courses_provider.dart';
import '../../core/models/gamification_models.dart';
import '../../shared/widgets/gamification/level_badge.dart';
import '../../shared/widgets/gamification/streak_flame.dart';
import '../../shared/widgets/gamification/daily_challenge_card.dart';
import '../../shared/widgets/dialogs.dart';


class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isLoading = false;
  double _globalProgress = 0.0;
  int _totalCourses = 0;
  int _completedCourses = 0;
  double _studyHours = 0.0;
  List<_SharedData> _recentSharedFiles = [];
  List<_AchievementData> _achievements = [];
  List<_DeadlineData> _deadlines = [];
  Map<String, double> _topSubjects = {};
  double _weeklyGoal = 10.0;
  double _weeklyProgress = 0.0;
  int _currentQuoteIndex = 0;

  static const _quotes = [
    ('L\'éducation est l\'arme la plus puissante pour changer le monde.', 'Nelson Mandela'),
    ('Le succès, c\'est d\'aller d\'échec en échec sans perdre son enthousiasme.', 'Winston Churchill'),
    ('L\'avenir appartient à ceux qui croient à la beauté de leurs rêves.', 'Eleanor Roosevelt'),
    ('Le savoir est le seul bien qui s\'accroît quand on le partage.', 'Marie Curie'),
    ('Ne rêvez pas votre vie, vivez vos rêves.', 'Sénèque'),
    ('L\'intelligence, ce n\'est pas ce que l\'on sait, mais ce que l\'on fait quand on ne sait pas.', 'Jean Piaget'),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _startQuoteTimer();
  }

  void _startQuoteTimer() {
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() => _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length);
        _startQuoteTimer();
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    ref.read(gamificationStateProvider.notifier).recordDailyActivity();

    await ref.read(seedingProvider.future);
    final repo = CourseRepository();
    final courses = StorageService.getCourses();
    final messages = StorageService.getMessages();
    final quizScore = StorageService.getQuizScore();
    final streak = StorageService.getStreakDays();

    if (streak == 7 || streak == 30 || streak == 60) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => OuroSuccessDialog(
            title: 'Série de $streak jours !',
            message: 'Félicitations ! Tu maintiens ta série depuis $streak jours. Continue comme ça !',
            buttonLabel: 'Continuer',
          ),
        );
      });
    }

    final globalProgress = repo.calculateGlobalProgress();
    final completedCourses = courses.where((c) => c.progress >= 1.0).length;
    final totalStudyHours = courses.fold(0.0, (sum, c) => sum + (c.progress * c.durationMinutes / 60));
    final subjects = repo.getProgressBySubject();

    final fileMessages = messages.where((m) => m.type == 'file').toList();
    final sharedFiles = fileMessages.map((m) => _SharedData(
      m.content.length > 35 ? '${m.content.substring(0, 35)}...' : m.content,
      m.authorPseudo,
      _formatTimeAgo(m.timestamp),
      _iconForFileType(m.type),
    )).toList();

    final deadlines = courses
        .where((c) => c.progress < 0.5)
        .map((c) => _DeadlineData(
            c.title,
            c.subject,
            '${(c.progress * 100).round()}%',
            c.progress < 0.2 ? OuroColors.errorRed : OuroColors.ouroOrange))
        .toList();

    final achievements = <_AchievementData>[];
    if (courses.isNotEmpty) {
      achievements.add(_AchievementData(Icons.emoji_events, 'Premier cours', OuroColors.ouroOrange));
    }
    if (streak >= 7) {
      achievements.add(_AchievementData(Icons.trending_up, 'Série 7 jours', OuroColors.localGreen));
    }
    if (messages.length >= 5) {
      achievements.add(_AchievementData(Icons.forum, '5 messages', OuroColors.meshBlue));
    }
    if (quizScore >= 80) {
      achievements.add(_AchievementData(Icons.star, 'Quiz parfait', Colors.purple));
    }
    if (completedCourses >= 3) {
      achievements.add(_AchievementData(Icons.school, 'Expert', Colors.amber));
    }
    if (streak >= 3 && streak < 7) {
      achievements.add(_AchievementData(Icons.local_fire_department, 'Série 3 jours', OuroColors.ouroOrange));
    }

    if (mounted) {
      setState(() {
        _globalProgress = globalProgress;
        _totalCourses = courses.length;
        _completedCourses = completedCourses;
        _studyHours = totalStudyHours;
        _recentSharedFiles = sharedFiles;
        _topSubjects = subjects;
        _weeklyGoal = 10.0;
        _weeklyProgress = (totalStudyHours / 10.0).clamp(0.0, 1.0);
        _deadlines = deadlines;
        _achievements = achievements;
        _isLoading = false;
      });
    }
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inHours < 1) return 'Il y a ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    return 'Il y a ${diff.inDays}j';
  }

  IconData _iconForFileType(String type) {
    switch (type) {
      case 'file': return Icons.picture_as_pdf;
      case 'audio': return Icons.headphones;
      case 'image': return Icons.image;
      default: return Icons.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final pseudo = user?.pseudo ?? 'Utilisateur';
    final stats = ref.watch(meshStatsProvider);
    final streak = StorageService.getStreakDays();
    final gamification = ref.watch(gamificationStateProvider);

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: AnimatedGradientBackground(
        child: Stack(
          children: [
            SafeArea(
              child: _isLoading
                  ? const OuroFullPageLoader()
                  : RefreshIndicator(
                      color: OuroColors.meshBlue,
                      backgroundColor: OuroColors.surface,
                      onRefresh: _loadData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(pseudo, user?.bacSeries ?? ''),
                            _buildGamificationHeader(gamification),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  _buildGreeting(),
                                  const SizedBox(height: 8),
                                  _buildStreakBar(streak),
                                  const SizedBox(height: 16),
                                  _buildContinueLearning(),
                                  const SizedBox(height: 16),
                                  _buildQuickActions(),
                                  const SizedBox(height: 20),
                                  _buildProgressSection(),
                                  const SizedBox(height: 24),
                                  _buildMeshCard(stats),
                                  const SizedBox(height: 24),
                                  _buildSubjectCarousel(),
                                  const SizedBox(height: 24),
                                  _buildWeeklyGoal(),
                                  const SizedBox(height: 24),
                                  _buildRecentShared(),
                                  const SizedBox(height: 24),
                                  _buildPeersSection(),
                                  const SizedBox(height: 24),
                                  _buildAchievementsSection(),
                                  const SizedBox(height: 24),
                                  _buildUpcomingDeadlines(),
                                  const SizedBox(height: 24),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: ProgressionCard(),
                                  ),
                                  const SizedBox(height: 24),
                                  _buildRecommendedResources(),
                                  const SizedBox(height: 24),
                                  _buildStudyTimeChart(),
                                  const SizedBox(height: 24),
                                  _buildLeaderboardPreview(),
                                  const SizedBox(height: 24),
                                  _buildFlashcardsPreview(),
                                  const SizedBox(height: 24),
                                  _buildMotivationalQuote(),
                                  const SizedBox(height: 24),
                                  _buildQuickStatsRow(),
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: OuroBottomNav(currentRoute: '/dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String pseudo, String bac) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(DesignTokens.grid3x, DesignTokens.gridSm, DesignTokens.grid3x, 0),
      child: Row(
        children: [
          AvatarWidget(pseudo: pseudo, size: 46),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pseudo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                bac.isNotEmpty ? 'Série $bac' : 'Étudiant',
                style: const TextStyle(
                  color: OuroColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.go('/p2p-quiz'),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: OuroColors.ouroOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: OuroColors.ouroOrange.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.sports_esports, color: OuroColors.ouroOrange, size: 22),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: OuroColors.glassBorder),
            ),
            child: const Icon(Icons.notifications_outlined, color: OuroColors.textSecondary, size: 22),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -20, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildGamificationHeader(GamificationState gamification) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedLevelBadge(state: gamification, size: 70),
                const Spacer(),
                StreakFlame(streak: gamification.currentStreak, size: 40),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Voici tes défis du jour',
              style: TextStyle(
                color: OuroColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...gamification.dailyChallenges.take(3).map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DailyChallengeCard(challenge: c),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 15, end: 0, duration: 500.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) { greeting = 'Bonjour'; }
    else if (hour < 18) { greeting = 'Bon après-midi'; }
    else { greeting = 'Bonsoir'; }

    final streak = StorageService.getStreakDays();

    return Row(
      children: [
        Expanded(
          child: Text(
            '$greeting 👋',
            style: const TextStyle(color: OuroColors.textSecondary, fontSize: 15),
          ),
        ),
        if (streak >= 3)
          StreakFlame(streak: streak, size: 32),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildStreakBar(int streak) {
    final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final today = DateTime.now().weekday - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: streak >= 7
              ? [const Color(0xFFFF6B2B).withValues(alpha: 0.2), const Color(0xFFFF6B2B).withValues(alpha: 0.05)]
              : [OuroColors.glassBg, OuroColors.glassBg],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: streak >= 7
              ? const Color(0xFFFF6B2B).withValues(alpha: 0.3)
              : OuroColors.glassBorder,
        ),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Icon(
                Icons.local_fire_department,
                color: streak >= 3 ? const Color(0xFFFF6B2B) : OuroColors.textSecondary,
                size: 28,
              ).animate().shake(hz: 2, duration: 600.ms),
              Text('$streak', style: TextStyle(
                color: streak >= 3 ? const Color(0xFFFF6B2B) : OuroColors.textSecondary,
                fontSize: 16, fontWeight: FontWeight.w900,
              )),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streak >= 7 ? 'Série enflammée 🔥' : streak >= 3 ? 'Bonne série !' : 'Ta série',
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    final active = i <= today && streak > (today - i);
                    final isToday = i == today;
                    return Container(
                      width: isToday ? 30 : 24,
                      height: isToday ? 30 : 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active
                            ? const Color(0xFFFF6B2B).withValues(alpha: isToday ? 0.4 : 0.2)
                            : OuroColors.surfaceElevated,
                        border: isToday
                            ? Border.all(color: const Color(0xFFFF6B2B).withValues(alpha: 0.6), width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          days[i],
                          style: TextStyle(
                            color: active ? const Color(0xFFFF6B2B) : OuroColors.textSecondary.withValues(alpha: 0.4),
                            fontSize: isToday ? 11 : 9,
                            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideX(begin: -15, end: 0, duration: 400.ms);
  }

  Widget _buildContinueLearning() {
    final user = ref.watch(authProvider).user;
    if (user == null) return const SizedBox.shrink();
    final seriesId = BacSeries.toSeriesId(user.bacSeries);
    final series = SeriesModel.all.where((s) => s.id == seriesId).firstOrNull;
    if (series == null) return const SizedBox.shrink();

    MapEntry<String, double>? best;
    for (final cid in series.courseIds) {
      final p = GamificationService.courseProgress(cid);
      if (p > 0 && p < 1.0) {
        if (best == null || p > best.value) best = MapEntry(cid, p);
      }
    }
    if (best == null) return const SizedBox.shrink();
    final courseId = best.key;

    final course = StorageService.getCourseById(courseId);
    final chapters = StorageService.getChapters(courseId);
    final firstChapterId = chapters.isNotEmpty ? chapters.first.id : '${courseId}_ch1';
    if (firstChapterId.isEmpty) return const SizedBox.shrink();
    final chapterTitle = chapters.isNotEmpty ? chapters.first.title : '';
    final emoji = _courseEmoji(courseId);

    return GestureDetector(
      onTap: () => context.go('/learn/$courseId/$firstChapterId'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              OuroColors.meshBlue.withValues(alpha: 0.15),
              OuroColors.meshBlue.withValues(alpha: 0.03),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: OuroColors.meshBlue.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: OuroColors.meshBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Continuer où tu t\'es arrêté',
                    style: TextStyle(color: OuroColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    course?.title ?? courseId,
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  if (chapterTitle.isNotEmpty) ...[
                    const SizedBox(height: 1),
                    Text(chapterTitle, style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.6), fontSize: 11)),
                  ],
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: best.value,
                      minHeight: 4,
                      backgroundColor: OuroColors.surfaceElevated,
                      valueColor: const AlwaysStoppedAnimation(OuroColors.meshBlue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: OuroColors.meshBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: OuroColors.meshBlue, size: 22),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: -15, end: 0, duration: 400.ms);
  }

  Widget _buildQuickActions() {
    final user = ref.watch(authProvider).user;
    final firstCourseRoute = _firstCourseRoute(user);

    return Row(
      children: [
        Expanded(child: _quickAction(Icons.school, 'Cours', firstCourseRoute, OuroColors.meshBlue)),
        const SizedBox(width: 8),
        Expanded(child: _quickAction(Icons.menu_book, (user?.bacSeries ?? 'BAC D').replaceAll('BAC ', 'Bac '), '/curriculum', OuroColors.ouroOrange)),
        const SizedBox(width: 8),
        Expanded(child: _quickAction(Icons.forum, 'Forum', '/forum', OuroColors.localGreen)),
        const SizedBox(width: 8),
        Expanded(child: _quickAction(Icons.record_voice_over, 'Coach', '/voice-coach', const Color(0xFFFF6B2B))),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 250.ms);
  }

  String _firstCourseRoute(dynamic user) {
    if (user == null) return '/courses';
    final seriesId = BacSeries.toSeriesId(user.bacSeries);
    final series = SeriesModel.all.where((s) => s.id == seriesId).firstOrNull;
    if (series == null || series.courseIds.isEmpty) return '/courses';
    final firstCourseId = series.courseIds.first;
    final chapters = StorageService.getChapters(firstCourseId);
    if (chapters.isNotEmpty) return '/reader/$firstCourseId/${chapters.first.id}';
    return '/reader/$firstCourseId/${firstCourseId}_ch1';
  }

  Widget _quickAction(IconData icon, String label, String route, Color color) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildMeshCard(MeshStats stats) {
    return MeshConnectionCard(
      peerCount: stats.totalPeers,
      hopCount: stats.messagesSent,
      signalStrength: (stats.helpedPeers / stats.totalPeers).clamp(0.0, 1.0),
      reliability: stats.averageReliability,
      blePeers: stats.blePeers,
      wifiPeers: stats.wifiPeers,
      nativePeers: stats.nativePeers,
      messagesSent: stats.messagesSent,
      acksReceived: stats.acksReceived,
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms).slideX(
          begin: -20, end: 0, duration: 500.ms, delay: 300.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Progression Globale',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: OuroColors.meshBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${(_globalProgress * 100).round()}%',
                style: const TextStyle(color: OuroColors.meshBlue, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              AnimatedRing(
                progress: _globalProgress,
                size: 170,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(_globalProgress * 100).round()}%',
                      style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Terminé',
                      style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.6), fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _miniBadge(Icons.check_circle, '$_completedCourses', 'Complétés', OuroColors.successGreen),
                  const SizedBox(width: 16),
                  _miniBadge(Icons.menu_book, '$_totalCourses', 'Total', OuroColors.meshBlue),
                  const SizedBox(width: 16),
                  _miniBadge(Icons.timer, '${_studyHours.round()}h', 'Étude', OuroColors.ouroOrange),
                ],
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }

  Widget _miniBadge(IconData icon, String value, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.6), fontSize: 11)),
      ],
    );
  }

  String _courseEmoji(String courseId) {
    if (courseId.contains('maths')) return '🔢';
    if (courseId.contains('physique')) return '⚡';
    if (courseId.contains('chimie')) return '🧪';
    if (courseId.contains('svt')) return '🌿';
    if (courseId.contains('info')) return '💻';
    if (courseId.contains('litterature')) return '📖';
    if (courseId.contains('philosophie')) return '🤔';
    if (courseId.contains('histoire')) return '🏛️';
    if (courseId.contains('francais')) return '🇫🇷';
    return '📘';
  }

  Widget _buildSubjectCarousel() {
    final subjectIcons = <String, IconData>{
      'Mathématiques': Icons.functions,
      'Physique': Icons.science,
      'Informatique': Icons.computer,
      'Littérature': Icons.menu_book,
    };
    final subjectColors = <String, Color>{
      'Mathématiques': OuroColors.meshBlue,
      'Physique': OuroColors.ouroOrange,
      'Informatique': OuroColors.localGreen,
      'Littérature': const Color(0xFF7C4DFF),
    };

    final subjects = _topSubjects.entries.map((e) {
      final name = e.key;
      final progress = e.value;
      final icon = subjectIcons[name] ?? Icons.auto_stories;
      final color = subjectColors[name] ?? OuroColors.meshBlue;
      final count = StorageService.getCourses()
          .where((c) => c.subject == name).length;
      return _SubjectData(name, icon, progress, color, '$count leçons');
    }).toList();

    if (subjects.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Matières',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () => context.go('/courses'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: OuroColors.meshBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Voir tout', style: TextStyle(color: OuroColors.meshBlue, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: subjects.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return GestureDetector(
                onTap: () => context.go('/courses'),
                child: SizedBox(
                  width: 160,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: subject.color.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: subject.color.withValues(alpha: 0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: subject.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(subject.icon, color: subject.color, size: 22),
                        ),
                        const Spacer(),
                        Text(subject.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: subject.progress.clamp(0.0, 1.0),
                                  minHeight: 4,
                                  backgroundColor: OuroColors.surfaceElevated,
                                  valueColor: AlwaysStoppedAnimation<Color>(subject.color),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${(subject.progress * 100).round()}%',
                              style: TextStyle(color: subject.color, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(subject.lessons, style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.7), fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 500.ms);
  }

  Widget _buildWeeklyGoal() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: OuroColors.ouroOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.flag_outlined, color: OuroColors.ouroOrange, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Objectif Hebdomadaire',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_studyHours.toStringAsFixed(1)}h/${_weeklyGoal.toStringAsFixed(0)}h cette semaine',
                  style: TextStyle(
                    color: OuroColors.textSecondary.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _weeklyProgress,
                    backgroundColor: OuroColors.glassBg,
                    valueColor: const AlwaysStoppedAnimation(OuroColors.ouroOrange),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 700.ms);
  }

  Widget _buildRecentShared() {
    if (_recentSharedFiles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Partagé dans ton quartier',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/forum'),
              child: const Text(
                'Voir tout',
                style: TextStyle(color: OuroColors.meshBlue, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._recentSharedFiles.asMap().entries.map((entry) =>
            _buildSharedCard(entry.value, entry.key)),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 800.ms);
  }

  Widget _buildSharedCard(_SharedData data, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: OuroColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: OuroColors.glassBorder, width: 0.3),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: OuroColors.meshBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: OuroColors.meshBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(data.subject, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text('•', style: TextStyle(color: OuroColors.textSecondary)),
                    ),
                    Text(data.time, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.download_outlined, color: OuroColors.textSecondary, size: 18),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (900 + index * 80).ms).slideX(
          begin: -20, end: 0, duration: 400.ms, delay: (900 + index * 80).ms, curve: Curves.easeOutCubic);
  }

  Widget _buildPeersSection() {
    final peers = ref.watch(meshPeerListProvider);
    final displayNames = peers.isEmpty
        ? ['Alpha', 'Edu', 'Learn', 'Brain', 'Smart', 'Mesh']
        : peers.map((p) => p.pseudo).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Pairs à proximité',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (peers.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: OuroColors.localGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${peers.length} en ligne',
                  style: TextStyle(color: OuroColors.localGreen, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: displayNames.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final isLive = index < peers.length;
              return Column(
                children: [
                  AvatarWidget(pseudo: displayNames[index], size: 44, showGlow: isLive),
                  const SizedBox(height: 6),
                  Text(
                    displayNames[index],
                    style: TextStyle(color: isLive ? OuroColors.textPrimary : OuroColors.textSecondary, fontSize: 11),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 1000.ms);
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Récompenses',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _achievements.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final a = _achievements[index];
              return Column(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: a.color.withValues(alpha: 0.15),
                      border: Border.all(
                        color: a.color.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(a.icon, color: a.color, size: 24),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    a.label,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 1050.ms);
  }

  Widget _buildUpcomingDeadlines() {
    if (_deadlines.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Échéances',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ..._deadlines.map((d) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: OuroColors.cardDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: OuroColors.glassBorder, width: 0.3),
          ),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 40,
                decoration: BoxDecoration(
                  color: d.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(d.subtitle, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: d.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(d.timeLeft, style: TextStyle(color: d.color, fontSize: 10, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        )),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 1100.ms);
  }

  Widget _buildRecommendedResources() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommandé pour toi',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _resources.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final r = _resources[index];
              return SizedBox(
                width: 140,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: OuroColors.cardDark,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: OuroColors.glassBorder, width: 0.3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: r.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(r.icon, color: r.color, size: 20),
                      ),
                      const Spacer(),
                      Text(r.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(r.type, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 10)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 1200.ms);
  }

  Widget _buildStudyTimeChart() {
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final now = DateTime.now();
    final weekday = now.weekday; // 1=Mon..7=Sun
    final total = _studyHours;
    final hours = List.generate(7, (i) {
      final dayOfWeek = i + 1;
      if (dayOfWeek > weekday) return 0.0;
      final weight = dayOfWeek == 7 ? 0.3 : (dayOfWeek == 6 ? 0.7 : 1.0);
      return double.parse((total / weekday * weight).toStringAsFixed(1));
    });

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Temps d\'étude', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text('Cette semaine: ${_studyHours.toStringAsFixed(1)}h', style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.7), fontSize: 12)),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(days.length, (i) {
                final barHeight = (hours[i] / 3.5) * 80;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: i == DateTime.now().weekday - 1
                                ? OuroColors.meshBlue
                                : OuroColors.meshBlue.withValues(alpha: 0.3),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(days[i], style: TextStyle(color: OuroColors.textSecondary, fontSize: 9)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 1250.ms);
  }

  Widget _buildLeaderboardPreview() {
    final pts = ref.watch(contributionPointsProvider);
    final rank = ref.watch(contributionRankProvider);

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Contribution mesh', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _rankColor(rank).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _rankLabel(rank),
                  style: TextStyle(color: _rankColor(rank), fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statBadge(Icons.swap_horiz, '${pts.relaysCount}', 'Relais'),
              const SizedBox(width: 12),
              _statBadge(Icons.forum, '${pts.forumHelpfulCount}', 'Aide'),
              const SizedBox(width: 12),
              _statBadge(Icons.call, '${pts.tutoringCallCount}', 'Tutorat'),
              const SizedBox(width: 12),
              _statBadge(Icons.wifi_tethering, '${pts.relayMinutes}', 'Min. relais'),
            ],
          ),
          const SizedBox(height: 12),
          _buildRankProgress(pts.total, rank),
          const SizedBox(height: 8),
          Text(
            '${pts.total} points • ${pts.pendingPoints} en attente',
            style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.6), fontSize: 11),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 1300.ms);
  }

  Widget _statBadge(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: OuroColors.glassBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: OuroColors.meshBlue, size: 18),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            Text(label, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildRankProgress(int points, ContributionRank rank) {
    final next = _nextRankThreshold(rank);
    if (next == null) {
      // Diamant — max level
      return Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
          const SizedBox(width: 6),
          const Text('Rang maximum atteint !', style: TextStyle(color: Colors.amber, fontSize: 12)),
        ],
      );
    }

    final current = _currentRankThreshold(rank);
    final progress = (points - current) / (next - current);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_nextRankLabel(rank), style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11)),
            Text('$points / $next', style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: OuroColors.glassBg,
            valueColor: AlwaysStoppedAnimation(_rankColor(rank)),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Color _rankColor(ContributionRank r) {
    switch (r) {
      case ContributionRank.bronze: return Colors.brown;
      case ContributionRank.argent: return OuroColors.textSecondary;
      case ContributionRank.or: return OuroColors.ouroOrange;
      case ContributionRank.diamant: return Colors.cyan;
    }
  }

  String _rankLabel(ContributionRank r) {
    switch (r) {
      case ContributionRank.bronze: return 'BRONZE';
      case ContributionRank.argent: return 'ARGENT';
      case ContributionRank.or: return 'OR';
      case ContributionRank.diamant: return 'DIAMANT';
    }
  }

  String _nextRankLabel(ContributionRank r) {
    switch (r) {
      case ContributionRank.bronze: return 'Prochain : Argent';
      case ContributionRank.argent: return 'Prochain : Or';
      case ContributionRank.or: return 'Prochain : Diamant';
      case ContributionRank.diamant: return '';
    }
  }

  int _currentRankThreshold(ContributionRank r) {
    switch (r) {
      case ContributionRank.bronze: return 0;
      case ContributionRank.argent: return 100;
      case ContributionRank.or: return 500;
      case ContributionRank.diamant: return 2000;
    }
  }

  int? _nextRankThreshold(ContributionRank r) {
    switch (r) {
      case ContributionRank.bronze: return 100;
      case ContributionRank.argent: return 500;
      case ContributionRank.or: return 2000;
      case ContributionRank.diamant: return null;
    }
  }

  Widget _buildFlashcardsPreview() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.style, color: Colors.purple, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Flashcards', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text('24 cartes à réviser aujourd\'hui', style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.7), fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('Réviser', style: TextStyle(color: Colors.purple, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 1350.ms);
  }

  Widget _buildMotivationalQuote() {
    final q = _quotes[_currentQuoteIndex % _quotes.length];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            OuroColors.meshBlue.withValues(alpha: 0.1),
            OuroColors.meshBlue.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: OuroColors.meshBlue.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote, color: OuroColors.meshBlue, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                  child: Text(
                    '"${q.$1}"',
                    key: ValueKey(q.$1),
                    style: TextStyle(
                      color: OuroColors.textSecondary.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text('- ${q.$2}', style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.4), fontSize: 11)),
              ],
            ),
          ),
          Column(
            children: List.generate(_quotes.length, (i) {
              return Container(
                margin: const EdgeInsets.only(bottom: 3),
                width: 5, height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _currentQuoteIndex % _quotes.length
                      ? OuroColors.meshBlue
                      : OuroColors.textSecondary.withValues(alpha: 0.2),
                ),
              );
            }),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 1400.ms);
  }

  Widget _buildQuickStatsRow() {
    final livePeerCount = ref.watch(connectedPeerCountProvider);
    return Row(
      children: [
        Expanded(child: _miniStatCard(Icons.menu_book, '$_totalCourses', 'Cours', OuroColors.meshBlue)),
        const SizedBox(width: 8),
        Expanded(child: _miniStatCard(Icons.timer, '${_studyHours.round()}h', 'Étudiées', OuroColors.localGreen)),
        const SizedBox(width: 8),
        Expanded(child: _miniStatCard(Icons.star, '${_topSubjects.length}', 'Matières', OuroColors.ouroOrange)),
        const SizedBox(width: 8),
        Expanded(child: _miniStatCard(Icons.people, '$livePeerCount', 'Pairs', Colors.purple)),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 1450.ms);
  }

  Widget _miniStatCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: OuroColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: OuroColors.glassBorder, width: 0.3),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 9)),
        ],
      ),
    );
  }
}

class _SubjectData {
  final String name;
  final IconData icon;
  final double progress;
  final Color color;
  final String lessons;
  _SubjectData(this.name, this.icon, this.progress, this.color, this.lessons);
}

class _SharedData {
  final String title;
  final String subject;
  final String time;
  final IconData icon;
  _SharedData(this.title, this.subject, this.time, this.icon);
}

class _AchievementData {
  final IconData icon;
  final String label;
  final Color color;
  _AchievementData(this.icon, this.label, this.color);
}

class _DeadlineData {
  final String title;
  final String subtitle;
  final String timeLeft;
  final Color color;
  _DeadlineData(this.title, this.subtitle, this.timeLeft, this.color);
}

class _ResourceData {
  final String title;
  final String type;
  final IconData icon;
  final Color color;
  _ResourceData(this.title, this.type, this.icon, this.color);
}



final List<_ResourceData> _resources = [
  _ResourceData('Limites: Cours complet', 'PDF', Icons.picture_as_pdf, OuroColors.meshBlue),
  _ResourceData('Exercices corrigés', 'Quiz', Icons.quiz, OuroColors.localGreen),
  _ResourceData('Vidéo: Dérivées', 'Vidéo', Icons.play_circle, OuroColors.ouroOrange),
  _ResourceData('Annales BAC 2024', 'PDF', Icons.description, Colors.purple),
];
