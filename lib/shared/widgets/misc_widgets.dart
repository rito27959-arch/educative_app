import 'package:flutter/material.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';

class GuideCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String step;

  const GuideCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(step, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ],
      ),
    );
  }
}

class FeatureHighlight extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const FeatureHighlight({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            boxShadow: DesignTokens.glow(color, radius: 12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(description, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11), textAlign: TextAlign.center),
      ],
    );
  }
}

class StatsRow extends StatelessWidget {
  final List<StatsRowItem> items;

  const StatsRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((item) => Expanded(child: _buildItem(item))).toList(),
    );
  }

  Widget _buildItem(StatsRowItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(item.value, style: TextStyle(color: item.color ?? OuroColors.meshBlue, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(item.label, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}

class StatsRowItem {
  final String value;
  final String label;
  final Color? color;

  StatsRowItem({required this.value, required this.label, this.color});
}

class DividerWithLabel extends StatelessWidget {
  final String label;

  const DividerWithLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: OuroColors.glassBorder.withValues(alpha: 0.2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(label, style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.4), fontSize: 11, letterSpacing: 1)),
        ),
        Expanded(child: Divider(color: OuroColors.glassBorder.withValues(alpha: 0.2))),
      ],
    );
  }
}

class ProgressSummary extends StatelessWidget {
  final int completedCourses;
  final int totalCourses;
  final int studyHours;
  final int streakDays;

  const ProgressSummary({
    super.key,
    required this.completedCourses,
    required this.totalCourses,
    required this.studyHours,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetric('Cours', '$completedCourses/$totalCourses'),
          _buildMetric('Étude', '${studyHours}h'),
          _buildMetric('Série', '${streakDays}j'),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}

class QuickActionGrid extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionGrid({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: actions.length,
      itemBuilder: (_, i) => _buildAction(actions[i]),
    );
  }

  Widget _buildAction(QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: action.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: action.color.withValues(alpha: 0.2)),
            ),
            child: Icon(action.icon, color: action.color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(action.label, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  QuickAction({required this.icon, required this.label, required this.color, this.onTap});
}
