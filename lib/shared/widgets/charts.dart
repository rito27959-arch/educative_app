import 'package:flutter/material.dart';
import '../../design_system/ouro_colors.dart';

class ChartDataPoint {
  final String label;
  final double value;
  final Color? color;

  ChartDataPoint({required this.label, required this.value, this.color});
}

class SimpleBarChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  final double maxHeight;
  final double barWidth;
  final bool showLabels;

  const SimpleBarChart({
    super.key,
    required this.data,
    this.maxHeight = 120,
    this.barWidth = 24,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: maxHeight + (showLabels ? 24 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((point) {
          final height = maxHeight * (point.value / maxValue);
          final color = point.color ?? OuroColors.meshBlue;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: barWidth,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color.withValues(alpha: 0.7), color],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                  boxShadow: [
                    BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, -2)),
                  ],
                ),
              ),
              if (showLabels) ...[
                const SizedBox(height: 6),
                Text(point.label, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 9)),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? color;
  final String? centerText;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 80,
    this.strokeWidth = 8,
    this.color,
    this.centerText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              backgroundColor: OuroColors.glassBg,
              valueColor: AlwaysStoppedAnimation(color ?? OuroColors.meshBlue),
              strokeCap: StrokeCap.round,
            ),
          ),
          if (centerText != null)
            Text(centerText!, style: TextStyle(color: OuroColors.textPrimary, fontSize: size * 0.2, fontWeight: FontWeight.bold))
          else
            Text('${(progress * 100).round()}%', style: TextStyle(color: OuroColors.textPrimary, fontSize: size * 0.2, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class StreakIndicator extends StatelessWidget {
  final int streak;
  final int goal;

  const StreakIndicator({super.key, required this.streak, required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress = (streak / goal).clamp(0.0, 1.0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_fire_department, color: streak >= goal ? OuroColors.ouroOrange : OuroColors.textSecondary, size: 20),
        const SizedBox(width: 6),
        Text('$streak', style: TextStyle(color: OuroColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Text('/ $goal jours', style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
        const SizedBox(width: 8),
        SizedBox(
          width: 60, height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: OuroColors.glassBg,
              valueColor: AlwaysStoppedAnimation(streak >= goal ? OuroColors.ouroOrange : OuroColors.meshBlue),
            ),
          ),
        ),
      ],
    );
  }
}

class TimerDisplay extends StatelessWidget {
  final Duration duration;
  final bool showHours;

  const TimerDisplay({super.key, required this.duration, this.showHours = false});

  @override
  Widget build(BuildContext context) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showHours || hours > 0) _digit(hours.toString().padLeft(2, '0')),
        if (showHours || hours > 0) _separator(),
        _digit(minutes.toString().padLeft(2, '0')),
        _separator(),
        _digit(seconds.toString().padLeft(2, '0')),
      ],
    );
  }

  Widget _digit(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: OuroColors.glassBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFeatures: [FontFeature.tabularFigures()])),
    );
  }

  Widget _separator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(':', style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5), fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}

class HeatmapGrid extends StatelessWidget {
  final List<double> values;
  final int columns;
  final double cellSize;
  final double spacing;

  const HeatmapGrid({
    super.key,
    required this.values,
    this.columns = 7,
    this.cellSize = 12,
    this.spacing = 3,
  });

  @override
  Widget build(BuildContext context) {
    final rows = (values.length / columns).ceil();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(rows, (row) {
        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            children: List.generate(columns, (col) {
              final index = row * columns + col;
              if (index >= values.length) return SizedBox(width: cellSize);
              final value = values[index];
              final opacity = (value * 0.8 + 0.1).clamp(0.1, 0.9);
              return Container(
                width: cellSize,
                height: cellSize,
                margin: EdgeInsets.only(right: spacing),
                decoration: BoxDecoration(
                  color: OuroColors.meshBlue.withValues(alpha: opacity),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class ActivityGraph extends StatelessWidget {
  final List<double> hourlyActivity;

  const ActivityGraph({super.key, required this.hourlyActivity});

  @override
  Widget build(BuildContext context) {
    final max = hourlyActivity.reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Activité horaire', style: TextStyle(color: OuroColors.textSecondary, fontSize: 11)),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: hourlyActivity.asMap().entries.map((entry) {
              final height = max > 0 ? (entry.value / max) * 50 : 0.0;
              final isPeak = entry.value >= max * 0.8;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Container(
                    height: 4 + height,
                    decoration: BoxDecoration(
                      color: isPeak ? OuroColors.meshBlue : OuroColors.glassBg,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
