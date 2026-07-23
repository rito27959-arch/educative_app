import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../design_system/widgets/ouro_buttons.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/utils/extensions.dart';
import '../../shared/widgets/avatar_widget.dart';
import '../../shared/widgets/dialogs.dart';
import '../../core/repositories/course_repository.dart';
import '../../core/services/storage_service.dart';
import '../../core/providers/mesh_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditingBio = false;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final user = StorageService.currentUser;
    _bioController = TextEditingController(text: user?.bio ?? 'Étudiant passionné, série BAC C');
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, user),
                  const SizedBox(height: 24),
                  _buildProfileCard(user),
                  const SizedBox(height: 24),
                  _buildBioSection(),
                  const SizedBox(height: 24),
                  _buildStatsSection(),
                  const SizedBox(height: 24),
                  _buildDetailedStats(),
                  const SizedBox(height: 24),
                  _buildAchievementsGrid(),
                  const SizedBox(height: 24),
                  _buildActivityTimeline(),
                  const SizedBox(height: 24),
                  _buildSubjectsMastery(),
                  const SizedBox(height: 24),
                  _buildBadgesSection(),
                  const SizedBox(height: 24),
                  _buildShareCard(),
                  const SizedBox(height: 24),
                  _buildContributionSection(),
                  const SizedBox(height: 24),
                  _buildSettingsSection(context, ref),
                  const SizedBox(height: 24),
                  _buildDangerSection(context, ref),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          ],

      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic user) {
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
          const Text('Profil', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OuroColors.glassBorder),
            ),
            child: const Icon(Icons.edit_outlined, color: OuroColors.textSecondary, size: 20),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -20, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildProfileCard(dynamic user) {
    final pseudo = user?.pseudo ?? 'Utilisateur';
    final bac = user?.bacSeries ?? 'BAC C';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        borderRadius: 24,
        child: Column(
          children: [
            AvatarWidget(pseudo: pseudo, size: 80, showGlow: true),
            const SizedBox(height: 16),
            Text(pseudo, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: OuroColors.meshBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('Série $bac', style: const TextStyle(color: OuroColors.meshBlue, fontSize: 13)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _infoChip(Icons.wifi_tethering, 'Passerelle Active', OuroColors.localGreen),
                const SizedBox(width: 8),
                _infoChip(Icons.lock_outline, 'Chiffré', OuroColors.meshBlue),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _infoChip(Icons.school, 'BAC $bac', Colors.purple),
                const SizedBox(width: 8),
                _infoChip(Icons.star, 'Membre +3 mois', OuroColors.ouroOrange),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).scaleXY(begin: 0.95, end: 1, duration: 500.ms, delay: 200.ms, curve: Curves.easeOutCubic);
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bio', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                GestureDetector(
                  onTap: () {
                    if (_isEditingBio) {
                      final currentUser = StorageService.currentUser;
                      if (currentUser != null) {
                        final updated = currentUser.copyWith(bio: _bioController.text);
                        StorageService.saveUser(updated);
                        ref.read(authProvider.notifier).updateUser(updated);
                      }
                    }
                    setState(() => _isEditingBio = !_isEditingBio);
                  },
                  child: Icon(
                    _isEditingBio ? Icons.check : Icons.edit_outlined,
                    color: OuroColors.meshBlue, size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _isEditingBio
                ? Material(
                    type: MaterialType.transparency,
                    child: TextField(
                      controller: _bioController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: OuroColors.meshBlue.withValues(alpha: 0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: OuroColors.meshBlue),
                        ),
                        hintText: 'Parle-nous de toi...',
                        hintStyle: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5)),
                      ),
                      maxLines: 3,
                    ),
                  )
                : Text(
                    _bioController.text,
                    style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.8), fontSize: 14, height: 1.4),
                  ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 250.ms).slideY(begin: 10, end: 0, duration: 500.ms, delay: 250.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildStatsSection() {
    final courses = StorageService.getCourses();
    final meshStats = ref.watch(meshStatsProvider);
    final progress = CourseRepository().calculateGlobalProgress();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Row(
        children: [
          Expanded(child: _statTile(meshStats.totalPeers.toString(), 'Pairs Mesh', Icons.wifi_tethering, OuroColors.meshBlue)),
          const SizedBox(width: 12),
          Expanded(child: _statTile(courses.length.toString(), 'Cours suivis', Icons.school, OuroColors.localGreen)),
          const SizedBox(width: 12),
          Expanded(child: _statTile('${(progress * 100).round()}%', 'Progression', Icons.trending_up, OuroColors.ouroOrange)),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  Widget _statTile(String value, String label, IconData icon, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildDetailedStats() {
    final courses = StorageService.getCourses();
    final meshStats = ref.watch(meshStatsProvider);
    final totalMinutes = courses.fold(0, (sum, c) => sum + c.durationMinutes);
    final totalHours = totalMinutes ~/ 60;
    final messageCount = StorageService.getMessageCount();
    final streakDays = StorageService.getStreakDays();
    final masteredSubjects = courses.where((c) => c.progress >= 0.8).length;
    final completedCourses = courses.where((c) => c.progress >= 1.0).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statistiques détaillées', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _detailStatRow(Icons.timer, 'Temps total d\'étude', '${totalHours}h', OuroColors.meshBlue),
            const SizedBox(height: 10),
            _detailStatRow(Icons.quiz, 'Quiz complétés', messageCount.toString(), OuroColors.localGreen),
            const SizedBox(height: 10),
            _detailStatRow(Icons.download, 'Fichiers téléchargés', meshStats.relayedFiles.toString(), OuroColors.ouroOrange),
            const SizedBox(height: 10),
            _detailStatRow(Icons.people, 'Étudiants aidés', meshStats.helpedPeers.toString(), Colors.purple),
            const SizedBox(height: 10),
            _detailStatRow(Icons.local_fire_department, 'Jours de streak', streakDays.toString(), OuroColors.meshBlue),
            const SizedBox(height: 10),
            _detailStatRow(Icons.menu_book, 'Sujets maîtrisés', masteredSubjects.toString(), OuroColors.localGreen),
            const SizedBox(height: 10),
            _detailStatRow(Icons.emoji_events, 'Certificats', completedCourses.toString(), Colors.amber),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 350.ms);
  }

  Widget _detailStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 13))),
        Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildAchievementsGrid() {
    final courses = StorageService.getCourses();
    final meshStats = StorageService.getMeshStats();
    final messageCount = StorageService.getMessageCount();
    final streakDays = StorageService.getStreakDays();
    final quizScore = StorageService.getQuizScore();

    final achievements = [
      _AchievementItem('Premier pas', 'Termine ton premier cours', Icons.directions_walk, courses.any((c) => c.progress > 0)),
      _AchievementItem('Scholar', '10 cours complétés', Icons.school, courses.where((c) => c.progress >= 1.0).length >= 10),
      _AchievementItem('Social', '50 messages', Icons.forum, messageCount >= 50),
      _AchievementItem('Streak 7', '7 jours d\'affilée', Icons.local_fire_department, streakDays >= 7),
      _AchievementItem('Top Quizz', '10/10 au quiz', Icons.emoji_events, quizScore >= 10),
      _AchievementItem('Partage', '5 fichiers partagés', Icons.share, meshStats.relayedFiles >= 5),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Succès', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: achievements.map((a) {
              return Container(
                width: (MediaQuery.of(context).size.width - 48) / 3 - 8,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: a.unlocked ? OuroColors.cardDark : OuroColors.glassBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: a.unlocked
                        ? OuroColors.meshBlue.withValues(alpha: 0.2)
                        : OuroColors.glassBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      a.icon,
                      color: a.unlocked ? OuroColors.meshBlue : OuroColors.textSecondary,
                      size: 24,
                    ),
                    const SizedBox(height: 6),
                    Text(a.title, style: TextStyle(color: a.unlocked ? Colors.white : OuroColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                    Text(a.subtitle, style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5), fontSize: 8), textAlign: TextAlign.center, maxLines: 2),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }

  Widget _buildActivityTimeline() {
    final activities = [
      _ActivityItem('A terminé "Limites et Continuité"', 'Il y a 2h', Icons.check_circle, OuroColors.localGreen),
      _ActivityItem('A partagé "Exercices Maths"', 'Il y a 4h', Icons.share, OuroColors.meshBlue),
      _ActivityItem('A rejoint le groupe d\'étude', 'Il y a 1j', Icons.group_add, OuroColors.ouroOrange),
      _ActivityItem('A téléchargé "Physique BAC"', 'Il y a 2j', Icons.download, Colors.purple),
      _ActivityItem('A obtenu le badge "Scholar"', 'Il y a 3j', Icons.emoji_events, Colors.amber),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Activité récente', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...activities.asMap().entries.map((entry) {
            final a = entry.value;
            final isLast = entry.key == activities.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: a.color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(a.icon, color: a.color, size: 14),
                    ),
                    if (!isLast)
                      Container(
                        width: 1,
                        height: 30,
                        color: OuroColors.glassBorder.withValues(alpha: 0.3),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.title, style: const TextStyle(color: Colors.white, fontSize: 13)),
                        Text(a.time, style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5), fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 450.ms);
  }

  Widget _buildSubjectsMastery() {
    final subjects = [
      _SubjectMastery('Mathématiques', 0.82, OuroColors.meshBlue),
      _SubjectMastery('Physique', 0.55, OuroColors.ouroOrange),
      _SubjectMastery('Informatique', 0.75, OuroColors.localGreen),
      _SubjectMastery('Littérature', 0.40, Colors.purple),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Maîtrise par matière', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ...subjects.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(s.name, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      Text('${(s.level * 100).toInt()}%', style: TextStyle(color: s.color, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: s.level),
                      duration: 1.seconds,
                      builder: (context, value, _) {
                        return LinearProgressIndicator(
                          value: value,
                          backgroundColor: OuroColors.glassBg,
                          valueColor: AlwaysStoppedAnimation(s.color),
                          minHeight: 6,
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 500.ms);
  }

  Widget _buildBadgesSection() {
    final courses = StorageService.getCourses();
    final messages = StorageService.getMessages();
    final studyHours = courses.fold<double>(0, (s, c) => s + (c.progress * 10));
    final flashcardCount = messages.where((m) => m.type == 'note').length;
    final pts = ref.watch(contributionPointsProvider);
    final badges = [
      (name: 'Lecteur', icon: Icons.menu_book, unlocked: courses.isNotEmpty),
      (name: 'Actif', icon: Icons.trending_up, unlocked: studyHours > 5),
      (name: 'Expert', icon: Icons.school, unlocked: flashcardCount > 20),
      (name: 'Social', icon: Icons.forum, unlocked: messages.length > 10),
      (name: 'Créatif', icon: Icons.lightbulb, unlocked: messages.where((m) => m.type == 'note').length > 5),
      (name: 'Leader', icon: Icons.emoji_events, unlocked: pts.total >= 100),
    ];
    final unlockedCount = badges.where((b) => b.unlocked).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Badges', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('$unlockedCount/${badges.length} débloqués', style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.6), fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(badges.length, (i) {
                final badge = badges[i];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: badge.unlocked ? OuroColors.meshBlue.withValues(alpha: 0.15) : OuroColors.glassBg,
                        border: Border.all(
                          color: badge.unlocked ? OuroColors.meshBlue.withValues(alpha: 0.3) : OuroColors.glassBorder,
                        ),
                      ),
                      child: Icon(
                        badge.icon,
                        color: badge.unlocked ? OuroColors.meshBlue : OuroColors.textSecondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(badge.name, style: TextStyle(color: badge.unlocked ? Colors.white : OuroColors.textSecondary, fontSize: 9)),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 550.ms);
  }

  Widget _buildContributionSection() {
    final pts = ref.watch(contributionPointsProvider);
    final rank = ref.watch(contributionRankProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Contribution mesh', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
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
                _contributionStat(Icons.swap_horiz, '${pts.relaysCount}', 'Relais'),
                const SizedBox(width: 8),
                _contributionStat(Icons.forum, '${pts.forumHelpfulCount}', 'Aide'),
                const SizedBox(width: 8),
                _contributionStat(Icons.call, '${pts.tutoringCallCount}', 'Tutorat'),
                const SizedBox(width: 8),
                _contributionStat(Icons.timer, '${pts.relayMinutes}min', 'Relais'),
              ],
            ),
            const SizedBox(height: 12),
            _buildContributionRankBar(pts.total, rank),
            const SizedBox(height: 6),
            Text(
              '${pts.total} points • ${pts.pendingPoints} en attente de validation',
              style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.6), fontSize: 11),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 600.ms);
  }

  Widget _contributionStat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: OuroColors.glassBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: OuroColors.meshBlue, size: 18),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            Text(label, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildContributionRankBar(int points, ContributionRank rank) {
    final next = _nextRankThreshold(rank);
    if (next == null) {
      return Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
          const SizedBox(width: 6),
          const Text('Rang DIAMANT — maximum atteint !', style: TextStyle(color: Colors.amber, fontSize: 12)),
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

  Widget _buildShareCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: OuroColors.meshBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.qr_code_2_rounded, color: OuroColors.meshBlue, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Partager mon profil', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('Scanne mon code OURO pour te connecter', style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.7), fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: OuroColors.textSecondary, size: 20),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 580.ms).slideX(begin: 15, end: 0, duration: 500.ms, delay: 580.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(4),
        borderRadius: 20,
        child: Column(
          children: [
            _settingTile(Icons.notifications_outlined, 'Notifications', 'Activées', () => context.go('/settings')),
            _divider(),
            _settingTile(Icons.wifi_tethering, 'Mode Mesh', 'Automatique', () => context.go('/settings')),
            _divider(),
            _settingTile(Icons.dark_mode, 'Thème sombre', 'Activé', () => context.go('/settings')),
            _divider(),
            _settingTile(Icons.storage_outlined, 'Stockage local', '2.4 Go', () => context.go('/settings')),
            _divider(),
            _settingTile(Icons.info_outline, 'Version', '1.0.0', () => context.go('/settings')),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }

  Widget _settingTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: OuroColors.textSecondary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
                    Text(subtitle, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: OuroColors.textSecondary, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(color: OuroColors.glassBorder.withValues(alpha: 0.3), height: 1, indent: 16, endIndent: 16);
  }

  Widget _buildDangerSection(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Column(
        children: [
          OuroButton(
            label: 'Déconnexion',
            onPressed: () => context.showOuroDialog(
              OuroConfirmDialog(
                title: 'Déconnexion',
                message: 'Veux-tu vraiment quitter le maillage ?',
                confirmLabel: 'Se déconnecter',
                onConfirm: () {
                  ref.read(authProvider.notifier).logout();
                  context.go('/auth');
                },
                isDestructive: true,
              ),
            ),
            variant: OuroButtonVariant.danger,
            width: double.infinity,
          ),
          const SizedBox(height: 16),
          Text(
            'OURO PREP v1.0.0 • Propulsé par Nexora Studio',
            style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.3), fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 600.ms);
  }
}

class _AchievementItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool unlocked;
  _AchievementItem(this.title, this.subtitle, this.icon, this.unlocked);
}

class _ActivityItem {
  final String title;
  final String time;
  final IconData icon;
  final Color color;
  _ActivityItem(this.title, this.time, this.icon, this.color);
}

class _SubjectMastery {
  final String name;
  final double level;
  final Color color;
  _SubjectMastery(this.name, this.level, this.color);
}


