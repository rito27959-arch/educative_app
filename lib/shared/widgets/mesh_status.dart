import 'package:flutter/material.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../design_system/widgets/ouro_indicators.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MeshConnectionCard extends StatelessWidget {
  final int peerCount;
  final int hopCount;
  final double signalStrength;
  final bool isActive;

  /// Fiabilité moyenne des transports (0.0 – 1.0).
  final double reliability;

  /// Nombre de pairs par transport.
  final int blePeers;
  final int wifiPeers;
  final int nativePeers;

  /// Messages envoyés vs ACK reçus.
  final int messagesSent;
  final int acksReceived;

  const MeshConnectionCard({
    super.key,
    required this.peerCount,
    required this.hopCount,
    required this.signalStrength,
    this.isActive = true,
    this.reliability = 1.0,
    this.blePeers = 0,
    this.wifiPeers = 0,
    this.nativePeers = 0,
    this.messagesSent = 0,
    this.acksReceived = 0,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isActive ? OuroColors.localGreen : OuroColors.textSecondary;
    return GlassContainer(
      padding: DesignTokens.paddingMd,
      borderRadius: DesignTokens.radiusLg,
      child: Column(
        children: [
          Row(
            children: [
              OuroStatusDot(color: statusColor, pulse: isActive),
              SizedBox(width: DesignTokens.gridSm),
              Text(isActive ? 'Connecté au maillage' : 'Déconnecté', style: TextStyle(color: OuroColors.textPrimary, fontSize: DesignTokens.textMd, fontWeight: FontWeight.w600)),
              Spacer(),
              OuroSignalBars(bars: (signalStrength * 4).round(), activeColor: statusColor),
            ],
          ),
          SizedBox(height: DesignTokens.gridMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(Icons.people_outline, '$peerCount', 'Pairs'),
              _statItem(Icons.horizontal_rule, '$hopCount', 'Sauts'),
              _statItem(Icons.signal_cellular_alt, '${(signalStrength * 100).round()}%', 'Signal'),
            ],
          ),
          SizedBox(height: DesignTokens.gridSm),
          // Fiabilité et transports
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(Icons.verified, '${(reliability * 100).round()}%', 'Fiabilité'),
              _statItem(Icons.wifi, '$wifiPeers', 'Wi‑Fi'),
              _statItem(Icons.bluetooth, '$blePeers', 'BLE'),
            ],
          ),
          // Barre de fiabilité
          if (messagesSent > 0) ...[
            SizedBox(height: DesignTokens.gridSm),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: acksReceived / messagesSent,
                backgroundColor: OuroColors.glassBg,
                valueColor: AlwaysStoppedAnimation(
                  reliability > 0.8 ? OuroColors.localGreen : reliability > 0.5 ? OuroColors.ouroOrange : OuroColors.errorRed,
                ),
                minHeight: 4,
              ),
            ),
            Text('$acksReceived/$messagesSent remis', style: TextStyle(color: OuroColors.textSecondary, fontSize: 9)),
          ],
        ],
      ),
    ).animate().fadeIn(duration: DesignTokens.durationNormal).slideY(begin: 0.1);
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: OuroColors.meshBlue, size: DesignTokens.iconMd),
        SizedBox(height: DesignTokens.gridSm / 2),
        Text(value, style: TextStyle(color: OuroColors.textPrimary, fontSize: DesignTokens.textLg, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: OuroColors.textSecondary, fontSize: DesignTokens.textSm)),
      ],
    );
  }
}

class MeshPeerTile extends StatelessWidget {
  final String pseudo;
  final double signalStrength;
  final bool isGateway;

  const MeshPeerTile({
    super.key,
    required this.pseudo,
    required this.signalStrength,
    this.isGateway = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.gridMd, vertical: DesignTokens.gridSm),
      borderRadius: DesignTokens.radiusMd,
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: OuroColors.glassBg,
            child: Text(pseudo.isNotEmpty ? pseudo[0].toUpperCase() : '?', style: TextStyle(color: OuroColors.meshBlue, fontSize: DesignTokens.textSm, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: DesignTokens.gridSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pseudo, style: TextStyle(color: OuroColors.textPrimary, fontSize: DesignTokens.textMd)),
                Text(isGateway ? 'Passerelle active' : 'Pair', style: TextStyle(color: OuroColors.textSecondary, fontSize: DesignTokens.textXs)),
              ],
            ),
          ),
          OuroSignalBars(bars: (signalStrength * 4).round()),
        ],
      ),
    );
  }
}

class MeshTopologyMiniMap extends StatelessWidget {
  final int nodeCount;
  final int connectionCount;

  const MeshTopologyMiniMap({
    super.key,
    required this.nodeCount,
    required this.connectionCount,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: DesignTokens.paddingMd,
      borderRadius: DesignTokens.radiusLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Topologie Mesh', style: TextStyle(color: OuroColors.textPrimary, fontSize: DesignTokens.textMd, fontWeight: FontWeight.w600)),
          SizedBox(height: DesignTokens.gridSm),
          Row(
            children: [
              _topoStat('Nœuds', '$nodeCount', Icons.circle_outlined),
              SizedBox(width: DesignTokens.gridMd),
              _topoStat('Connexions', '$connectionCount', Icons.timeline),
              SizedBox(width: DesignTokens.gridMd),
              _topoStat('Densité', nodeCount > 0 ? '${(connectionCount / nodeCount).toStringAsFixed(1)}' : '0', Icons.grain),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topoStat(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: OuroColors.meshBlue, size: DesignTokens.iconMd),
          SizedBox(height: 4),
          Text(value, style: TextStyle(color: OuroColors.textPrimary, fontSize: DesignTokens.textLg, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: OuroColors.textSecondary, fontSize: DesignTokens.textXs)),
        ],
      ),
    );
  }
}
