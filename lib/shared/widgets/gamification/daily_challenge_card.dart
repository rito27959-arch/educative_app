import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/ouro_colors.dart';
import '../../../core/models/gamification_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyChallengeCard extends ConsumerStatefulWidget {
  final DailyChallenge challenge;

  const DailyChallengeCard({super.key, required this.challenge});

  @override
  ConsumerState<DailyChallengeCard> createState() => _DailyChallengeCardState();
}

class _DailyChallengeCardState extends ConsumerState<DailyChallengeCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this, duration: 2.seconds,
    )..repeat(reverse: true);
    _progressController = AnimationController(
      vsync: this, duration: 800.ms,
    )..forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.challenge;
    final timeLeft = c.remaining;
    final hours = timeLeft.inHours;
    final minutes = timeLeft.inMinutes.remainder(60);
    final isUrgent = hours < 3 && !c.isCompleted;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OuroColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: c.isCompleted
              ? OuroColors.localGreen.withValues(alpha: 0.3)
              : OuroColors.glassBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (c.isCompleted ? OuroColors.localGreen : OuroColors.meshBlue).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (_, __) => Transform.scale(
                    scale: c.isCompleted ? 1.0 : 0.9 + _pulseController.value * 0.1,
                    child: Text(c.emoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.title,
                      style: TextStyle(
                        color: c.isCompleted ? OuroColors.localGreen : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: c.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      c.description,
                      style: TextStyle(
                        color: OuroColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (c.isCompleted)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OuroColors.localGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.check_circle, color: OuroColors.localGreen, size: 20),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: (isUrgent ? OuroColors.errorRed : OuroColors.meshBlue).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (_, __) => Text(
                      '$hours:${minutes.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: isUrgent
                            ? OuroColors.errorRed.withValues(alpha: 0.7 + _pulseController.value * 0.3)
                            : OuroColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (!c.isCompleted) ...[
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _progressController,
              builder: (_, __) => ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: c.progressFraction * _progressController.value,
                  backgroundColor: OuroColors.glassBg,
                  valueColor: AlwaysStoppedAnimation(
                    c.progressFraction > 0.7 ? OuroColors.localGreen : OuroColors.meshBlue,
                  ),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${c.progress}/${c.targetCount}',
                  style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '+${c.xpReward} XP',
                      style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    if (c.coinReward > 0) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.monetization_on, color: Colors.amber.shade300, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '+${c.coinReward}',
                        style: TextStyle(color: Colors.amber.shade300, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 20, end: 0, curve: Curves.easeOutCubic);
  }
}
