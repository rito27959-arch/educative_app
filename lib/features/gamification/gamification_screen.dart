import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../core/models/gamification_models.dart';
import '../../core/providers/gamification_provider.dart';
import '../../shared/widgets/gamification/level_badge.dart';
import '../../shared/widgets/gamification/streak_flame.dart';
import '../../shared/widgets/gamification/daily_challenge_card.dart';
import '../../shared/widgets/gamification/leaderboard_widget.dart' as lw;

class GamificationScreen extends ConsumerWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamification = ref.watch(gamificationStateProvider);

    return Scaffold(
      backgroundColor: OuroColors.background,
      appBar: AppBar(
        backgroundColor: OuroColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: OuroColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Gamification',
          style: TextStyle(
            color: OuroColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildLevelSection(gamification),
                const SizedBox(height: 24),
                _buildStatsRow(gamification),
                const SizedBox(height: 24),
                _buildStreakSection(gamification),
                const SizedBox(height: 24),
                _buildDailyChallenges(gamification),
                const SizedBox(height: 24),
                _buildBadgeCollection(gamification),
                const SizedBox(height: 24),
                _buildLeaderboard(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelSection(GamificationState state) {
    return Center(
      child: AnimatedLevelBadge(state: state, size: 140),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 20, end: 0, duration: 600.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildStatsRow(GamificationState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Row(
        children: [
          _statItem(Icons.menu_book, '${state.lessonsCompleted}', 'Leçons', OuroColors.meshBlue),
          _statItem(Icons.quiz, '${state.quizzesPassed}', 'Quiz', OuroColors.localGreen),
          _statItem(Icons.games, '${state.p2pWins}', 'P2P Wins', OuroColors.ouroOrange),
          _statItem(Icons.forum, '${state.forumMessages}', 'Forum', Colors.purple),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 15, end: 0, duration: 500.ms);
  }

  Widget _statItem(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: OuroColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakSection(GamificationState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        child: Row(
          children: [
            StreakFlame(streak: state.currentStreak, size: 56),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Série de ${state.currentStreak} jour${state.currentStreak > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Record: ${state.longestStreak} jours',
                    style: TextStyle(
                      color: OuroColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStreakHistory(state),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms).slideY(begin: 15, end: 0, duration: 500.ms);
  }

  Widget _buildStreakHistory(GamificationState state) {
    final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final today = DateTime.now().weekday - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final active = i <= today && state.currentStreak > (today - i);
        final isToday = i == today;
        return Container(
          width: isToday ? 32 : 26,
          height: isToday ? 32 : 26,
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
    );
  }

  Widget _buildDailyChallenges(GamificationState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Défis du jour',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${state.dailyChallenges.where((c) => c.isCompleted).length}/${state.dailyChallenges.length} complétés',
            style: TextStyle(
              color: OuroColors.textSecondary.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          ...state.dailyChallenges.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DailyChallengeCard(challenge: entry.value),
            ).animate().fadeIn(duration: 400.ms, delay: (400 + entry.key * 100).ms).slideX(begin: 20, end: 0, duration: 400.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCollection(GamificationState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Badges',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: OuroColors.meshBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${state.unlockedBadges.length}/${BadgeDefinition.all.length}',
                  style: const TextStyle(
                    color: OuroColors.meshBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: BadgeDefinition.all.length,
            itemBuilder: (context, index) {
              final badge = BadgeDefinition.all[index];
              final isUnlocked = state.unlockedBadges.contains(badge.type);
              return _badgeItem(badge, isUnlocked, index);
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 600.ms);
  }

  Widget _badgeItem(BadgeDefinition badge, bool isUnlocked, int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isUnlocked
            ? OuroColors.meshBlue.withValues(alpha: 0.08)
            : OuroColors.glassBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? OuroColors.meshBlue.withValues(alpha: 0.25)
              : OuroColors.glassBorder,
          width: isUnlocked ? 1.2 : 0.5,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: OuroColors.meshBlue.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            badge.emoji,
            style: TextStyle(
              fontSize: 32,
              color: isUnlocked ? null : Colors.grey.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            badge.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isUnlocked ? Colors.white : OuroColors.textSecondary.withValues(alpha: 0.5),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (!isUnlocked && !badge.isSecret) ...[
            const SizedBox(height: 4),
            Text(
              '+${badge.xpReward} XP',
              style: TextStyle(
                color: OuroColors.textSecondary.withValues(alpha: 0.4),
                fontSize: 9,
              ),
            ),
          ],
          if (badge.isSecret && !isUnlocked) ...[
            const SizedBox(height: 4),
            Text(
              'Secret',
              style: TextStyle(
                color: OuroColors.textSecondary.withValues(alpha: 0.3),
                fontSize: 9,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (700 + index * 50).ms);
  }

  Widget _buildLeaderboard() {
    final entries = [
      const lw.LeaderboardEntry(pseudo: 'Toi', totalXp: 450, level: 4, streak: 12, rank: 2, isMe: true),
      const lw.LeaderboardEntry(pseudo: 'Alice', totalXp: 720, level: 5, streak: 21, rank: 1),
      const lw.LeaderboardEntry(pseudo: 'Bob', totalXp: 380, level: 3, streak: 7, rank: 3),
      const lw.LeaderboardEntry(pseudo: 'Charlie', totalXp: 290, level: 3, streak: 5, rank: 4),
      const lw.LeaderboardEntry(pseudo: 'Diana', totalXp: 180, level: 2, streak: 3, rank: 5),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: lw.LeaderboardWidget(
        entries: entries,
        myPseudo: 'Toi',
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 800.ms);
  }
}
