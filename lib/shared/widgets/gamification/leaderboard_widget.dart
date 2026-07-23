import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/ouro_colors.dart';

class LeaderboardEntry {
  final String pseudo;
  final int totalXp;
  final int level;
  final int streak;
  final int rank;
  final bool isMe;

  const LeaderboardEntry({
    required this.pseudo,
    required this.totalXp,
    required this.level,
    this.streak = 0,
    required this.rank,
    this.isMe = false,
  });
}

class LeaderboardWidget extends StatefulWidget {
  final List<LeaderboardEntry> entries;
  final String? myPseudo;

  const LeaderboardWidget({
    super.key,
    required this.entries,
    this.myPseudo,
  });

  @override
  State<LeaderboardWidget> createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends State<LeaderboardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(vsync: this, duration: 1.seconds)..forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sorted = List<LeaderboardEntry>.from(widget.entries)
      ..sort((a, b) => b.totalXp.compareTo(a.totalXp));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              const Icon(Icons.leaderboard, color: OuroColors.ouroOrange, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Classement',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${sorted.length} étudiant${sorted.length > 1 ? 's' : ''}',
                style: TextStyle(
                  color: OuroColors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        ...List.generate(sorted.length, (i) {
          final entry = sorted[i];
          final isMe = entry.pseudo == widget.myPseudo;
          final medal = i == 0 ? '🥇' : i == 1 ? '🥈' : i == 2 ? '🥉' : null;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe
                  ? OuroColors.meshBlue.withValues(alpha: 0.1)
                  : OuroColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isMe
                    ? OuroColors.meshBlue.withValues(alpha: 0.3)
                    : OuroColors.glassBorder,
                width: isMe ? 1.5 : 0.3,
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Center(
                    child: medal != null
                        ? Text(medal, style: const TextStyle(fontSize: 20))
                        : Text(
                            '#${entry.rank}',
                            style: TextStyle(
                              color: OuroColors.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [OuroColors.meshBlue, OuroColors.meshBlueGradientEnd],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: OuroColors.meshBlue.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      entry.pseudo.isNotEmpty ? entry.pseudo[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            entry.pseudo,
                            style: TextStyle(
                              color: isMe ? OuroColors.meshBlue : Colors.white,
                              fontSize: 15,
                              fontWeight: isMe ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                          if (isMe) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: OuroColors.meshBlue.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'MOI',
                                style: TextStyle(
                                  color: OuroColors.meshBlue,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'Niv. ${entry.level}',
                            style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11),
                          ),
                          if (entry.streak > 0) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.local_fire_department, color: OuroColors.ouroOrange, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              '${entry.streak}',
                              style: const TextStyle(color: OuroColors.ouroOrange, fontSize: 11),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isMe
                        ? OuroColors.meshBlue.withValues(alpha: 0.15)
                        : OuroColors.glassBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${entry.totalXp}',
                        style: TextStyle(
                          color: isMe ? OuroColors.meshBlue : OuroColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(
            duration: 300.ms,
            delay: (100 + i * 60).ms,
          ).slideX(
            begin: 30,
            end: 0,
            duration: 300.ms,
            delay: (100 + i * 60).ms,
            curve: Curves.easeOutCubic,
          );
        }),
      ],
    );
  }
}
