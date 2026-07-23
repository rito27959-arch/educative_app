# OURO PREP — Agent Guide

## Build Commands

```bash
# Analyze only
./scripts/build.sh analyze

# Debug APK (fast)
./scripts/build.sh debug

# Release APK (obfuscated + shrunk)
./scripts/build.sh release

# Release APK (obfuscated + shrunk, explicit)
./scripts/build.sh release_obfuscated

# iOS (requires macOS + Xcode)
./scripts/build.sh ios
```

## Direct Flutter commands

```bash
flutter analyze lib/          # 0 errors required
flutter build apk --debug --target-platform android-arm64
flutter build apk --release --target-platform android-arm64 --obfuscate --split-debug-info=build/debug-info
flutter build ios --release --no-codesign
flutter test
```

## Release

```bash
./scripts/build.sh release_obfuscated   # obfuscated + shrunk APK
./scripts/build.sh debug                # fast debug APK
```

## Architecture

- **Clean Architecture** with Feature First
- **State management**: Riverpod (flutter_riverpod)
- **Routing**: GoRouter
- **P2P Mesh**: 3 transports (BLE → nativeP2P → localWifi)
- **Voice calls**: WebRTC (flutter_webrtc) over local Wi-Fi
- **Backend**: REST API + WebSocket + offline-first sync
- **Analytics**: Custom event tracking (no third-party)

## Backend Services (lib/core/services/)

| Service | File | Purpose |
|---------|------|---------|
| `ApiService` | `api_service.dart` | REST client with retry, cache, interceptors |
| `AuthService` | `auth_service.dart` | JWT auth with refresh |
| `SyncService` | `sync_service.dart` | Offline-first sync engine |
| `AnalyticsService` | `analytics_service.dart` | Event tracking, performance |
| `WebSocketService` | `websocket_service.dart` | Real-time communication |
| `PushService` | `push_service.dart` | Push notifications |
| `SupabaseService` | `supabase_service.dart` | Cloud backend facade |
| `WebRtcCallService` | `webrtc_call_service.dart` | P2P voice calls |
| `MeshTransportService` | `mesh_transport_service.dart` | 3-transport mesh router |
| `StorageService` | `storage_service.dart` | Local JSON persistence |
| `PermissionService` | `permission_service.dart` | Android permissions check/request via MethodChannel |

## Mesh Providers (lib/core/providers/)

| Provider | Type | Purpose |
|----------|------|---------|
| `meshRepositoryProvider` | `Provider<MeshRepository>` | Single mesh repo instance |
| `meshStatsProvider` | `Provider<MeshStats>` | Aggregate mesh stats (messages + peers) |
| `meshPeerListProvider` | `StateNotifierProvider` | Live `List<ConnectedPeer>` from transport |
| `connectedPeerCountProvider` | `Provider<int>` | Live peer count (derived from peer list) |
| `meshMessagesProvider` | `StateNotifierProvider` | Chat message list |
| `callProvider` | `StateNotifierProvider<CallNotifier>` | WebRTC voice call state |

## UI Conventions

- Dark mode only: `#060608` bg, `#0F0F14` surface, glassmorphism
- Brand colors: `#2563FF` (mesh blue), `#FF6B2B` (orange), `#00E676` (green), `#FF3B30` (error)
- Text: `#F0F0F8` (primary), `#8888A0` (secondary)
- Font: Google Fonts (Space Grotesk headings, Inter body)
- Animations: flutter_animate, CustomPainter, Shaders
- French text only

## Critical Rules

1. **NEVER** use `dart:html` or `dart:js_interop` (web-only, breaks mobile build)
2. **ALWAYS** use `flutter_webrtc` for WebRTC (NOT `dart_webrtc`)
3. **flutter analyze lib/** must show 0 errors before any build
4. **Android build**: use `--target-platform android-arm64` for less memory
5. **Release build**: always use `--obfuscate --split-debug-info=build/debug-info`
6. **Network dependent**: Gradle/Maven/pub.dev access required for full build
7. **All user-facing text must be in French** (francophone African students)
8. **Transport priority**: localWifi > nativeP2P > ble

## Dependencies

```yaml
flutter_webrtc: ^1.5.2          # P2P voice calls
nearby_service: ^0.2.1          # Native same-OS transport
universal_ble: ^0.10.0          # BLE mesh discovery
nsd: ^5.0.1                     # Wi-Fi local service discovery
flutter_riverpod: ^2.6.1        # State management
go_router: ^14.8.1              # Navigation
```

## Gamification

Moteur de gamification complet avec XP, niveaux, streaks, badges, défis quotidiens et animations.

### Gamification Models (lib/core/models/gamification_models.dart)

| Model | Purpose |
|-------|---------|
| `GamificationState` | Xp, level, streak, badges, challenges, coins, leaderboard |
| `LevelDefinition` | 10 levels (Apprenti → Légende) with progressive XP gaps |
| `BadgeDefinition` | 15 badges (dont `comebackKing` secret) avec conditions de déblocage |
| `DailyChallenge` | Tâche quotidienne procédurale (seed journalière), timer, progress |
| `CelebrationData` | Données pour overlay animations (levelUp, badgeUnlock) |
| `XpAction` | Actions XP avec montants (lesson=25, quiz=50, p2pWin=100, streak=20) |

### Gamification Engine (lib/core/services/gamification_engine.dart)

Moteur central singleton avec callbacks `onBadgeUnlocked` / `onCelebration` :
- `recordLessonCompleted()`, `recordQuizPassed()`, `recordP2pWin()`, `recordForumPost()`, `recordDailyLogin()`
- `_checkBadges()` auto après chaque action
- `_checkStreak()` au `load()`, auto-reset après 2 jours
- `getDailyChallenges()` généré procéduralement (seed = date YYYY-MM-DD)
- **Bonus comeback** : badge secret `comebackKing` après 7 jours d'absence

### Gamification Providers (lib/core/providers/gamification_provider.py)

| Provider | Type | Purpose |
|----------|------|---------|
| `gamificationStateProvider` | `StateNotifierProvider<GamificationNotifier, GamificationState>` | Full state |
| `xpProgressProvider` | `Provider<double>` | % vers prochain niveau |
| `currentLevelProvider` | `Provider<LevelDefinition>` | Niveau courant |
| `unlockedBadgesProvider` | `Provider<List<BadgeDefinition>>` | Badges débloqués |
| `dailyChallengesProvider` | `Provider<List<DailyChallenge>>` | Défis du jour |

### Gamification Widgets (lib/shared/widgets/gamification/)

| Widget | File | Purpose |
|--------|------|---------|
| `CelebrationOverlay` | `celebration_overlay.dart` | Full-screen 60-particle confetti + elasticIn face + XP bar + level notif |
| `StreakFlame` | `streak_flame.dart` | CustomPainter flame with flicker, embers, color tiers (7/14/30/60d) |
| `AnimatedLevelBadge` | `level_badge.dart` | Circle level with rainbow arc-progress ring, pulsing glow, XP bar |
| `DailyChallengeCard` | `daily_challenge_card.dart` | Challenge card with timer countdown, progress bar, reward |
| `LeaderboardWidget` | `leaderboard_widget.dart` | Ranked list with medals, avatar, XP, stagger animations |

### Gamification Screen (lib/features/gamification/gamification_screen.dart)
Route: `/gamification` — full-screen hub with level badge, stats, streak, challenges, all 15 badges, leaderboard.

### Wiring
- `DashboardScreen` : gamification header (level badge + streak + daily challenges)
- `ChapterExamScreen` : `ref.read(gamificationStateProvider.notifier).recordQuiz()` after pass
- `SubjectExamScreen` : same `recordQuiz()` after pass
- `P2PQuizScreen` : `recordP2pWin()` after win

### Rules
- Always import `gamification_engine.dart` only via `gamification_provider.dart` (providers wrap the engine)
- `CelebrationOverlay.show()` is static, call from any context
- Daily challenges auto-regenerate at midnight
- Badges can be one-time only (check `!isUnlocked` before awarding)
- XP rewards: lesson=25, quiz=50 (100 if perfect), p2pWin=100, streak=20, dailyChallenge=40

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Gradle OOM | Reduce `Xmx` in `android/gradle.properties` |
| NDK missing | Run `sdkmanager 'ndk;27.0.12077973'` |
| WebRTC not working | Check `flutter_webrtc` config for platform |
| `flutter_webrtc` errors | Ensure minSdk = 23 in build.gradle.kts |
