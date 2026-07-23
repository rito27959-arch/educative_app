import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/providers/progression_provider.dart';
import '../../core/models/progression_model.dart';

/// Carte de progression gamifiée avec streak, barre de feu, et stats.
class ProgressionCard extends ConsumerStatefulWidget {
  const ProgressionCard({super.key});

  @override
  ConsumerState<ProgressionCard> createState() => _ProgressionCardState();
}

class _ProgressionCardState extends ConsumerState<ProgressionCard> {
  ProgressionSnapshot? _prev;
  bool _fireGlow = false;

  void _triggerFireGlow() {
    setState(() => _fireGlow = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _fireGlow = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(progressionProvider);
    final s = async.valueOrNull;
    if (s == null) return const SizedBox.shrink();

    if (_prev != null && s.streakDays > _prev!.streakDays && _prev!.streakDays > 0) {
      _triggerFireGlow();
    }
    _prev = s;

    final pct = (s.globalProgress * 100).round();
    final weekPct = (s.studyMinutesThisWeek / 600.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0F0F14),
            _fireGlow
                ? const Color(0x332563FF)
                : const Color(0xFF0A0A0E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: s.isStreakOnFire
              ? const Color(0x44FF6B2B)
              : const Color(0xFF1A1A22),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _FlameWidget(days: s.streakDays, glowing: _fireGlow),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.isStreakOnFire
                          ? 'Série enflammée 🔥'
                          : s.hasStreak
                              ? 'Série en cours'
                              : 'Commence ta série',
                      style: const TextStyle(
                        color: Color(0xFFF0F0F8),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${s.streakDays} jour${s.streakDays > 1 ? 's' : ''} d\'affilée',
                      style: const TextStyle(
                        color: Color(0xFF8888A0),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _StreakBar(streakDays: s.streakDays, glowing: _fireGlow),
          const SizedBox(height: 20),
          Row(
            children: [
              _StatItem(
                icon: Icons.trending_up,
                label: 'Progression',
                value: '$pct%',
                color: const Color(0xFF2563FF),
              ),
              _StatItem(
                icon: Icons.check_circle,
                label: 'Chapitres',
                value: '${s.totalChaptersCompleted}/${s.totalChapters}',
                color: const Color(0xFF00E676),
              ),
              _StatItem(
                icon: Icons.timer,
                label: 'Cette semaine',
                value: '${s.studyMinutesThisWeek}min',
                color: const Color(0xFFFF6B2B),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Objectif hebdomadaire',
                    style: TextStyle(color: Color(0xFF8888A0), fontSize: 12),
                  ),
                  Text(
                    '${s.studyMinutesThisWeek}/600 min',
                    style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: weekPct,
                  backgroundColor: const Color(0xFF1A1A22),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF2563FF)),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Flamme animée ───────────────────────────────────────────────────────────

class _FlameWidget extends StatelessWidget {
  final int days;
  final bool glowing;
  const _FlameWidget({required this.days, required this.glowing});

  @override
  Widget build(BuildContext context) {
    final color = days >= 7
        ? const Color(0xFFFF6B2B)
        : days >= 3
            ? const Color(0xFFFFB74D)
            : const Color(0xFF8888A0);

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Icon(Icons.local_fire_department, color: color, size: 28)
            .animate(target: glowing ? 1 : 0)
            .shimmer(duration: 600.ms, color: const Color(0x44FFFFFF)),
      ),
    );
  }
}

// ── Barre des 7 jours ───────────────────────────────────────────────────────

class _StreakBar extends StatelessWidget {
  final int streakDays;
  final bool glowing;
  const _StreakBar({required this.streakDays, required this.glowing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (i) {
        final active = i < streakDays;
        final isToday = i == 6;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? (streakDays >= 7
                          ? const Color(0xFFFF6B2B)
                          : const Color(0xFF2563FF))
                      : const Color(0xFF1A1A22),
                  border: isToday
                      ? Border.all(color: const Color(0xFF2563FF).withValues(alpha: 0.6))
                      : null,
                ),
                child: active
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : (isToday
                        ? const Icon(Icons.circle_outlined, color: Color(0xFF8888A0), size: 16)
                        : null),
              ),
              const SizedBox(height: 4),
              Text(
                ['L', 'M', 'M', 'J', 'V', 'S', 'D'][i],
                style: TextStyle(
                  color: active ? const Color(0xFFF0F0F8) : const Color(0xFF555566),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ── Mini stat ───────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(value,
            style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(label,
            style: const TextStyle(color: Color(0xFF8888A0), fontSize: 11),
          ),
        ],
      ),
    );
  }
}
