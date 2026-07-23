import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/mesh_provider.dart';
import '../../core/providers/gamification_provider.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../shared/widgets/avatar_widget.dart';
import '../../shared/widgets/ouro_bottom_nav.dart';

/// Ligues mesh local — classement des pairs par XP hebdomadaire.
/// S'appuie sur les pairs connectés via le mesh plutôt que sur des inconnus globaux.
class LeaguesScreen extends ConsumerWidget {
  const LeaguesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peers = ref.watch(meshPeerListProvider);
    final gamification = ref.watch(gamificationStateProvider);
    final myPseudo = ref.watch(authProvider).user?.pseudo ?? '';
    final myXp = gamification.totalXp;

    // Construire le classement : XP des pairs mesh + soi-même
    final rankings = _buildRankings(peers, myPseudo, myXp);

    return Scaffold(
      backgroundColor: OuroColors.background,
      body: Stack(
        children: [
          AnimatedGradientBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  _buildPeriodSelector(),
                  const SizedBox(height: 8),
                  _buildTierCard(gamification.currentLevel.level),
                  const SizedBox(height: 16),
                  Expanded(child: _buildLeaderboard(rankings, myPseudo)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: OuroBottomNav(currentRoute: '/leagues'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(DesignTokens.grid3x, DesignTokens.gridSm, DesignTokens.grid3x, 8),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: OuroColors.ouroOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.emoji_events, color: OuroColors.ouroOrange, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ligues',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2),
                Text(
                  'Classez-vous avec vos pairs mesh',
                  style: TextStyle(color: OuroColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -20, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildPeriodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: OuroColors.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: OuroColors.glassBorder, width: 0.3),
        ),
        child: Row(
          children: [
            _periodTab('Cette semaine', true),
            _periodTab('Ce mois', false),
            _periodTab('Tout', false),
          ],
        ),
      ),
    );
  }

  Widget _periodTab(String label, bool active) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? OuroColors.meshBlue.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? OuroColors.meshBlue : OuroColors.textSecondary,
            fontSize: 12,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTierCard(int level) {
    final tierNames = ['Bronze', 'Argent', 'Or', 'Platine', 'Diamond', 'Légende'];
    final tierIndex = (level ~/ 2).clamp(0, tierNames.length - 1);
    final tierName = tierNames[tierIndex];
    final icons = [Icons.shield_outlined, Icons.workspace_premium, Icons.star, Icons.diamond, Icons.auto_awesome, Icons.whatshot];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 20,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    OuroColors.ouroOrange,
                    OuroColors.meshBlue,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: DesignTokens.glow(OuroColors.ouroOrange, radius: 16),
              ),
              child: Icon(icons[tierIndex], color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ligue $tierName',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Niveau $level • ${_nextTierProgress(level)}% vers la prochaine ligue',
                    style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _nextTierProgress(level) / 100,
                      backgroundColor: OuroColors.glassBg,
                      valueColor: const AlwaysStoppedAnimation(OuroColors.ouroOrange),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _nextTierProgress(int level) {
    final inTier = level % 2;
    if (inTier == 0) return 0;
    return (inTier / 2.0 * 100).clamp(0, 100);
  }

  Widget _buildLeaderboard(List<_RankEntry> rankings, String myPseudo) {
    if (rankings.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_outlined, color: OuroColors.textSecondary.withValues(alpha: 0.3), size: 64),
            const SizedBox(height: 16),
            const Text('Aucun classement disponible', style: TextStyle(color: OuroColors.textSecondary)),
            const SizedBox(height: 8),
            Text(
              'Connecte-toi à des pairs pour apparaître',
              style: TextStyle(color: OuroColors.textSecondary.withValues(alpha: 0.5), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final entry = rankings[index];
        final isMe = entry.pseudo == myPseudo;
        return _buildRankRow(entry, index, isMe);
      },
    );
  }

  Widget _buildRankRow(_RankEntry entry, int rank, bool isMe) {
    final medals = ['🥇', '🥈', '🥉'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isMe ? OuroColors.meshBlue.withValues(alpha: 0.08) : OuroColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isMe ? OuroColors.meshBlue.withValues(alpha: 0.3) : OuroColors.glassBorder,
            width: isMe ? 1.5 : 0.3,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: rank < 3
                  ? Text(medals[rank], style: const TextStyle(fontSize: 22))
                  : Text(
                      '${rank + 1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: OuroColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            AvatarWidget(pseudo: entry.pseudo, size: 38),
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
                          color: isMe ? OuroColors.meshBlueBright : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: OuroColors.meshBlue.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('MOI', style: TextStyle(color: OuroColors.meshBlue, fontSize: 8, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${entry.xp} XP',
                    style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (rank == 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: OuroColors.brandGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('1er', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(
      duration: 350.ms,
      delay: (rank * 50).ms,
    ).slideX(
      begin: 20, end: 0,
      duration: 350.ms,
      delay: (rank * 50).ms,
      curve: Curves.easeOutCubic,
    );
  }

  List<_RankEntry> _buildRankings(List<dynamic> peers, String myPseudo, int myXp) {
    final entries = <_RankEntry>[];
    
    // Ajouter les pairs mesh
    for (final peer in peers) {
      final pseudo = peer is Map ? peer['pseudo'] as String? ?? 'Inconnu' : peer.toString();
      final xp = peer is Map ? (peer['xp'] as int? ?? 0) : 0;
      entries.add(_RankEntry(pseudo: pseudo, xp: xp));
    }

    // Ajouter soi-même
    final selfExists = entries.any((e) => e.pseudo == myPseudo);
    if (!selfExists && myPseudo.isNotEmpty) {
      entries.add(_RankEntry(pseudo: myPseudo, xp: myXp));
    }

    // Trier par XP décroissant
    entries.sort((a, b) => b.xp.compareTo(a.xp));
    return entries;
  }
}

class _RankEntry {
  final String pseudo;
  final int xp;
  const _RankEntry({required this.pseudo, required this.xp});
}
