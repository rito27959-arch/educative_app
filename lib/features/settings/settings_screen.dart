import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/permission_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/llm/local_inference_service.dart';
import '../../core/services/llm/llm_service.dart';
import '../../core/providers/llm_provider.dart';
import '../../design_system/ouro_colors.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/glassmorphism.dart';
import '../../design_system/widgets/ouro_toggles.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late bool _meshAutoConnect;
  late bool _notificationsEnabled;
  late bool _dataSaver;
  late double _meshStorageLimit;
  late String _quality;
  late bool _autoDownload;
  late bool _downloadOnWifiOnly;
  late bool _nightMode;
  late bool _reduceAnimations;
  late bool _autoPlayVideos;
  late String _language;
  late String _theme;
  int _selectedTab = 0;

  final Map<AndroidPermission, PermissionStatus> _permCache = {};
  bool _permLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadPermissions();
  }

  void _loadSettings() {
    _meshAutoConnect = StorageService.getString('mesh_auto_connect') != 'false';
    _notificationsEnabled = StorageService.getString('notifications_enabled') != 'false';
    _dataSaver = StorageService.getString('data_saver') == 'true';
    _meshStorageLimit = double.tryParse(StorageService.getString('mesh_storage_limit') ?? '0.5') ?? 0.5;
    _quality = StorageService.getString('video_quality') ?? 'Auto';
    _autoDownload = StorageService.getString('auto_download') == 'true';
    _downloadOnWifiOnly = StorageService.getString('download_wifi_only') != 'false';
    _nightMode = StorageService.getString('night_mode') != 'false';
    _reduceAnimations = StorageService.getString('reduce_animations') == 'true';
    _autoPlayVideos = StorageService.getString('autoplay_videos') != 'false';
    _language = StorageService.getString('language') ?? 'Français';
    _theme = StorageService.getString('theme') ?? 'Sombre';
  }

  Future<void> _saveSetting(String key, String value) async {
    await StorageService.setString(key, value);
  }

  Future<void> _loadPermissions() async {
    final perms = AndroidPermission.values;
    for (final p in perms) {
      _permCache[p] = await PermissionService.check(p);
    }
    if (mounted) setState(() => _permLoading = false);
  }

  Future<void> _requestPermission(AndroidPermission perm) async {
    final status = await PermissionService.request(perm);
    setState(() => _permCache[perm] = status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OuroColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabSelector(),
            const SizedBox(height: DesignTokens.grid2x),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (_selectedTab == 0) _buildNetworkSection(),
                    if (_selectedTab == 1) _buildNotificationsSection(),
                    if (_selectedTab == 2) _buildStorageSection(),
                    if (_selectedTab == 3) _buildAppearanceSection(),
                    if (_selectedTab == 4) _buildPermissionsSection(),
                    if (_selectedTab == 5) _buildAboutSection(),
                    if (_selectedTab == 6) _buildAdvancedSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          const Text('Paramètres', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -20, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildTabSelector() {
    final tabs = ['Réseau', 'Notifications', 'Stockage', 'Apparence', 'Permissions', 'À propos', 'Avancé'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(DesignTokens.grid3x, 16, DesignTokens.grid3x, 0),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tabs.length,
          separatorBuilder: (_, _) => const SizedBox(width: 6),
          itemBuilder: (context, index) {
            final isActive = _selectedTab == index;
            final isPermissions = index == 4;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: 300.ms,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? (isPermissions ? OuroColors.accentPurple.withValues(alpha: 0.15) : OuroColors.meshBlue.withValues(alpha: 0.15))
                      : OuroColors.glassBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive
                        ? (isPermissions ? OuroColors.accentPurple.withValues(alpha: 0.3) : OuroColors.meshBlue.withValues(alpha: 0.3))
                        : OuroColors.glassBorder,
                  ),
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isActive
                        ? (isPermissions ? OuroColors.accentPurple : OuroColors.meshBlue)
                        : OuroColors.textSecondary,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildNetworkSection() {
    return _buildSection('Réseau Mesh', [
      _buildToggle('Connexion automatique', 'Se connecter au mesh automatiquement', _meshAutoConnect, (v) {
        setState(() => _meshAutoConnect = v);
        _saveSetting('mesh_auto_connect', v.toString());
      }),
      _divider(),
      _buildToggle('Mode économie de données', "Limiter l'utilisation du réseau", _dataSaver, (v) {
        setState(() => _dataSaver = v);
        _saveSetting('data_saver', v.toString());
      }),
      _divider(),
      _buildQualitySelector(),
      _divider(),
      _buildToggle('Téléchargement auto', 'Télécharger les cours en arrière-plan', _autoDownload, (v) {
        setState(() => _autoDownload = v);
        _saveSetting('auto_download', v.toString());
      }),
      _divider(),
      _buildToggle('Wi-Fi seulement', 'Télécharger uniquement en Wi-Fi', _downloadOnWifiOnly, (v) {
        setState(() => _downloadOnWifiOnly = v);
        _saveSetting('download_wifi_only', v.toString());
      }),
      _divider(),
      _buildNetworkStatsTile(),
    ]);
  }

  Widget _buildNotificationsSection() {
    return _buildSection('Notifications', [
      _buildToggle('Notifications push', 'Recevoir des alertes de cours', _notificationsEnabled, (v) {
        setState(() => _notificationsEnabled = v);
        _saveSetting('notifications_enabled', v.toString());
      }),
      _divider(),
      _buildToggle('Sons', 'Sons pour les messages et rappels', true, (_) {}),
      _divider(),
      _buildToggle('Vibration', 'Vibrer pour les appels entrants', false, (_) {}),
      _divider(),
      _buildToggle("Rappels d'étude", 'Notifications quotidiennes', true, (_) {}),
      _divider(),
      _buildToggle('Nouveaux cours', 'Notifier les nouveaux contenus', true, (_) {}),
      _divider(),
      _buildToggle('Activité pairs', 'Notifications de connexion pairs', false, (_) {}),
    ]);
  }

  Widget _buildStorageSection() {
    return Column(
      children: [
        _buildSection('Stockage', [
          _buildStorageSlider(),
        ]),
        const SizedBox(height: 16),
        _buildSection('Gestion', [
          _buildStorageAction(Icons.cleaning_services, 'Nettoyer le cache', 'Libérer de l\'espace', OuroColors.ouroOrange, () {}),
          _divider(),
          _buildStorageAction(Icons.download_done, 'Cours téléchargés', '24 cours • 1.2 Go', OuroColors.meshBlue, () {}),
          _divider(),
          _buildStorageAction(Icons.backup, 'Sauvegarder les notes', 'Dernière: hier', OuroColors.localGreen, () {}),
        ]),
        const SizedBox(height: 16),
        _buildSection('Utilisation', [
          _buildStorageUsageBar('Cours', 0.6, OuroColors.meshBlue),
          _divider(),
          _buildStorageUsageBar('Cache', 0.2, OuroColors.ouroOrange),
          _divider(),
          _buildStorageUsageBar('Notes', 0.05, OuroColors.localGreen),
          _divider(),
          _buildStorageUsageBar('Autres', 0.15, Colors.purple),
        ]),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return _buildSection('Apparence', [
      _buildOptionTile(Icons.palette_outlined, 'Thème', _theme, [
        ('Sombre', () {
          setState(() => _theme = 'Sombre');
          _saveSetting('theme', 'Sombre');
        }),
        ('Clair', () {
          setState(() => _theme = 'Clair');
          _saveSetting('theme', 'Clair');
        }),
        ('Système', () {
          setState(() => _theme = 'Système');
          _saveSetting('theme', 'Système');
        }),
      ]),
      _divider(),
      _buildToggle('Mode nuit automatique', "S'active le soir", _nightMode, (v) {
        setState(() => _nightMode = v);
        _saveSetting('night_mode', v.toString());
      }),
      _divider(),
      _buildToggle('Réduire les animations', 'Économiser la batterie', _reduceAnimations, (v) {
        setState(() => _reduceAnimations = v);
        _saveSetting('reduce_animations', v.toString());
      }),
      _divider(),
      _buildOptionTile(Icons.language, 'Langue', _language, [
        ('Français', () {
          setState(() => _language = 'Français');
          _saveSetting('language', 'Français');
        }),
        ('English', () {
          setState(() => _language = 'English');
          _saveSetting('language', 'English');
        }),
      ]),
      _divider(),
      _buildToggle('Lecture auto vidéos', 'Lire les vidéos automatiquement', _autoPlayVideos, (v) {
        setState(() => _autoPlayVideos = v);
        _saveSetting('autoplay_videos', v.toString());
      }),
    ]);
  }

  Widget _buildPermissionsSection() {
    final perms = [
      (AndroidPermission.storage, Icons.storage, 'Stockage', 'Accès aux fichiers et téléchargements'),
      (AndroidPermission.microphone, Icons.mic, 'Microphone', 'Appels vocaux P2P et enregistrement'),
      (AndroidPermission.location, Icons.location_on, 'Localisation', 'Découverte BLE des pairs mesh'),
      (AndroidPermission.camera, Icons.camera_alt, 'Caméra', 'Scan QR code et future visio'),
      (AndroidPermission.notifications, Icons.notifications, 'Notifications', 'Alertes cours et rappels'),
      (AndroidPermission.nearbyDevices, Icons.wifi_tethering, 'Appareils proches', 'Découverte Wi-Fi Direct des pairs'),
      (AndroidPermission.bluetooth, Icons.bluetooth, 'Bluetooth', 'Connexion BLE au maillage'),
      (AndroidPermission.phoneState, Icons.phone_android, 'État téléphone', 'Identification appareil'),
    ];

    return _buildSection('Permissions Android', [
      if (_permLoading)
        const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: OuroColors.meshBlue)),
        )
      else
        ...perms.map((p) {
          final status = _permCache[p.$1];
          return _buildPermissionTile(p.$1, p.$2, p.$3, p.$4, status);
        }),
    ]);
  }

  Widget _buildPermissionTile(
    AndroidPermission perm, IconData icon, String title,
    String description, PermissionStatus? status,
  ) {
    final granted = status?.granted ?? false;
    final denied = status?.permanentlyDenied ?? false;
    final unknown = status == null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: granted
                  ? OuroColors.localGreen.withValues(alpha: 0.1)
                  : OuroColors.errorRed.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: granted ? OuroColors.localGreen : OuroColors.textSecondary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                Text(description, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          if (unknown)
            const SizedBox(width: 60, child: Text('…', textAlign: TextAlign.center, style: TextStyle(color: OuroColors.textTertiary, fontSize: 12)))
          else if (granted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: OuroColors.localGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Accordé', style: TextStyle(color: OuroColors.localGreen, fontSize: 10, fontWeight: FontWeight.w600)),
            )
          else
            GestureDetector(
              onTap: () => _requestPermission(perm),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: OuroColors.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: OuroColors.errorRed.withValues(alpha: 0.2)),
                ),
                child: Text(
                  denied ? 'Bloqué' : 'Demander',
                  style: TextStyle(
                    color: denied ? OuroColors.errorRed : OuroColors.ouroOrange,
                    fontSize: 10, fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return _buildSection('À propos', [
      _buildInfoTile('Version', '1.0.0'),
      _divider(),
      _buildInfoTile('Build', '2024.06.22'),
      _divider(),
      _buildInfoTile('Développeur', 'Nexora Studio'),
      _divider(),
      _buildInfoTile('Licence', 'MIT'),
      _divider(),
      _buildInfoTile('Framework', 'Flutter 3.x + Riverpod'),
      _divider(),
      _buildAboutAction(Icons.code, 'Code source', 'Voir sur GitHub', OuroColors.meshBlue, () {}),
      _divider(),
      _buildAboutAction(Icons.policy, 'Politique de confidentialité', 'Lire', OuroColors.textSecondary, () {}),
      _divider(),
      _buildAboutAction(Icons.description, "Conditions d'utilisation", 'Lire', OuroColors.textSecondary, () {}),
    ]);
  }

  Widget _buildAdvancedSection() {
    final deviceCap = ref.watch(deviceCapabilityProvider);

    return Column(
      children: [
        _buildSection('Paramètres avancés', [
          _buildToggle('Mode développeur', 'Afficher les logs et diagnostics', false, (_) {}),
          _divider(),
          _buildToggle('Journalisation', 'Enregistrer les événements système', true, (_) {}),
          _divider(),
          _buildAboutAction(Icons.bug_report, 'Rapport de bug', 'Signaler un problème', OuroColors.errorRed, () {}),
          _divider(),
          _buildAboutAction(Icons.restore, 'Réinitialiser', 'Effacer toutes les données', OuroColors.ouroOrange, () {}),
          _divider(),
          _buildAboutAction(Icons.file_download, 'Exporter les données', 'Sauvegarder', OuroColors.localGreen, () {}),
        ]),
        const SizedBox(height: 16),
        _buildSection('Tuteur IA Local', [
          if (!deviceCap.hasBeenChecked)
            _buildInfoTile('Capacité', 'Vérification en cours...')
          else if (!deviceCap.isCapable)
            _buildInfoTile('Appareil non compatible', deviceCap.reason)
          else
            _buildModelFullSection(),
        ]),
      ],
    );
  }

  Widget _buildModelFullSection() {
    final download = ref.watch(modelDownloadProvider);
    final localState = ref.watch(localInferenceStateProvider);
    final llmService = ref.read(llmServiceProvider);

    // Not downloaded → start tile
    if (!download.isDownloaded && !download.isDownloading && download.error == null) {
      return _buildModelStartTile();
    }

    // Downloading
    if (download.isDownloading) {
      return _buildModelDownloadProgress(download);
    }

    // Download error
    if (download.error != null) {
      return _buildModelErrorTile(download.error!);
    }

    // Downloaded → show model management
    return _buildModelManagementTile(localState, llmService);
  }

  Widget _buildModelManagementTile(LocalInferenceState localState, LlmService llmService) {
    final size = LocalInferenceService.expectedModelSize;

    switch (localState) {
      case LocalInferenceState.ready:
        return _buildModelReadyTile(size);
      case LocalInferenceState.loading:
        return _buildModelLoadingTile();
      case LocalInferenceState.error:
        return _buildModelLoadErrorTile();
      default:
        return _buildModelDownloadedTile(size, llmService);
    }
  }

  Widget _buildModelDownloadedTile(int size, LlmService llmService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: OuroColors.localGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.check_circle, color: OuroColors.localGreen, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Modèle téléchargé', style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text('${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} Go • Prêt à charger', style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final ok = await llmService.ensureLocalModelLoaded();
                if (!ok && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Échec du chargement du modèle')),
                  );
                }
              },
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Charger le modèle en mémoire'),
              style: ElevatedButton.styleFrom(
                backgroundColor: OuroColors.meshBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelLoadingTile() {
    final progress = ref.watch(localModelLoadProgressProvider);
    final pct = (progress.valueOrNull ?? 0.0 * 100).round();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: OuroColors.accentPurple),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Chargement du modèle...', style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
              Text('$pct%', style: const TextStyle(color: OuroColors.accentPurple, fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.valueOrNull,
              backgroundColor: OuroColors.glassBg,
              valueColor: const AlwaysStoppedAnimation(OuroColors.accentPurple),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelReadyTile(int size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: OuroColors.localGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.psychology, color: OuroColors.localGreen, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Modèle actif', style: TextStyle(color: OuroColors.localGreen, fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: OuroColors.localGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('LIVE', style: TextStyle(color: OuroColors.localGreen, fontSize: 9, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('Llama 3.2 1B Instruct Q4_K_M • ${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} Go', style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await ref.read(llmServiceProvider).local.unload();
              },
              icon: const Icon(Icons.stop, size: 18),
              label: const Text('Décharger le modèle'),
              style: OutlinedButton.styleFrom(
                foregroundColor: OuroColors.ouroOrange,
                side: BorderSide(color: OuroColors.ouroOrange.withValues(alpha: 0.4)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelLoadErrorTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OuroColors.errorRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.error_outline, color: OuroColors.errorRed, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Échec du chargement', style: TextStyle(color: OuroColors.errorRed, fontSize: 15)),
                const Text('Le modèle est téléchargé mais n\'a pas pu être chargé', style: TextStyle(color: OuroColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => ref.read(llmServiceProvider).ensureLocalModelLoaded(),
            child: const Text('Réessayer', style: TextStyle(color: OuroColors.meshBlue, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildModelDownloadProgress(ModelDownloadState download) {
    final pct = (download.progress * 100).round();
    final downloadedMb = download.bytesDownloaded ~/ (1024 * 1024);
    final totalMb = download.totalBytes ~/ (1024 * 1024);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: OuroColors.meshBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Téléchargement en cours...', style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text('$downloadedMb / $totalMb Mo', style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Text('$pct%', style: const TextStyle(color: OuroColors.meshBlue, fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: download.progress,
              backgroundColor: OuroColors.glassBg,
              valueColor: const AlwaysStoppedAnimation(OuroColors.meshBlue),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelErrorTile(String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OuroColors.errorRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.error_outline, color: OuroColors.errorRed, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Échec du téléchargement', style: TextStyle(color: OuroColors.errorRed, fontSize: 15)),
                Text(error, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          TextButton(
            onPressed: () => ref.read(modelDownloadProvider.notifier).startDownload(),
            child: const Text('Réessayer', style: TextStyle(color: OuroColors.meshBlue, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildModelStartTile() {
    final size = LocalInferenceService.expectedModelSize;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OuroColors.accentPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.psychology, color: OuroColors.accentPurple, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tuteur IA hors ligne', style: TextStyle(color: Colors.white, fontSize: 15)),
                Text('${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} Go • Wi-Fi recommandé', style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => ref.read(modelDownloadProvider.notifier).startDownload(),
            style: ElevatedButton.styleFrom(
              backgroundColor: OuroColors.meshBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            child: const Text('Télécharger'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.grid3x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(title, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          GlassContainer(
            padding: const EdgeInsets.all(4),
            borderRadius: 20,
            child: Column(children: children),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (100 + children.length * 30).ms);
  }

  Widget _buildToggle(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          OuroToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildQualitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Qualité vidéo', style: TextStyle(color: Colors.white, fontSize: 15)),
                SizedBox(height: 2),
                Text('Résolution de streaming', style: TextStyle(color: OuroColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: OuroColors.glassBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _quality,
                dropdownColor: OuroColors.surface,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                items: ['Auto', 'Haute', 'Moyenne', 'Basse'].map((q) {
                  return DropdownMenuItem(value: q, child: Text(q));
                }).toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _quality = v);
                    _saveSetting('video_quality', v);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageSlider() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Limite de stockage Mesh', style: TextStyle(color: Colors.white, fontSize: 15)),
              Text('${(_meshStorageLimit * 50).toInt()} Go', style: const TextStyle(color: OuroColors.meshBlue, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: OuroColors.meshBlue,
              inactiveTrackColor: OuroColors.glassBg,
              thumbColor: OuroColors.meshBlue,
              overlayColor: OuroColors.meshBlue.withValues(alpha: 0.1),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: _meshStorageLimit,
              onChanged: (v) => setState(() => _meshStorageLimit = v),
              onChangeEnd: (v) => _saveSetting('mesh_storage_limit', v.toString()),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(_meshStorageLimit * 50).toInt()} Go utilisés', style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11)),
              Text('${50 - (_meshStorageLimit * 50).toInt()} Go restants', style: const TextStyle(color: OuroColors.textSecondary, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
          Text(value, style: const TextStyle(color: OuroColors.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStorageAction(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
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

  Widget _buildAboutAction(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return _buildStorageAction(icon, title, subtitle, color, onTap);
  }

  Widget _buildOptionTile(IconData icon, String title, String currentValue, List<(String, VoidCallback)> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: OuroColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: OuroColors.glassBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: OuroColors.glassBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentValue,
                dropdownColor: OuroColors.surface,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                items: options.map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$1))).toList(),
                onChanged: (v) {
                  if (v != null) {
                    for (final o in options) {
                      if (o.$1 == v) o.$2();
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageUsageBar(String label, double fraction, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text('${(fraction * 100).toInt()}%', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: OuroColors.glassBg,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkStatsTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OuroColors.localGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.wifi, color: OuroColors.localGreen, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('État du réseau', style: TextStyle(color: Colors.white, fontSize: 15)),
                Text('Connecté • Signal fort', style: TextStyle(color: OuroColors.localGreen, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: OuroColors.localGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Actif', style: TextStyle(color: OuroColors.localGreen, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: OuroColors.glassBorder.withValues(alpha: 0.2), height: 1, indent: 16, endIndent: 16);
  }

}
