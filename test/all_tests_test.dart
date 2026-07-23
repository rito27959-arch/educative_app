import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ouro_prep/core/utils/validators.dart';
import 'package:ouro_prep/core/utils/date_utils.dart';
import 'package:ouro_prep/core/services/storage_service.dart';
import 'package:ouro_prep/core/services/api_service.dart';
import 'package:ouro_prep/core/services/gamification_service.dart';
import 'package:ouro_prep/core/models/course_model.dart';
import 'package:ouro_prep/core/providers/settings_provider.dart';
import 'package:ouro_prep/core/providers/ui_provider.dart';
import 'package:ouro_prep/design_system/ouro_colors.dart';
import 'package:ouro_prep/design_system/design_tokens.dart';
import 'package:ouro_prep/design_system/glassmorphism.dart';
import 'package:ouro_prep/design_system/widgets/ouro_buttons.dart';
import 'package:ouro_prep/design_system/widgets/ouro_cards.dart';
import 'package:ouro_prep/design_system/widgets/ouro_progress.dart';
import 'package:ouro_prep/design_system/widgets/ouro_lists.dart';
import 'package:ouro_prep/design_system/widgets/ouro_indicators.dart';
import 'package:ouro_prep/design_system/widgets/ouro_animations.dart';
import 'package:ouro_prep/shared/widgets/avatar_widget.dart';
import 'package:ouro_prep/shared/widgets/headers.dart';
import 'package:ouro_prep/shared/widgets/mesh_status.dart';
import 'package:ouro_prep/shared/widgets/charts.dart';

Widget wrap(Widget w) => MaterialApp(home: Scaffold(body: w));
Widget wrapFixed(Widget w) => MaterialApp(home: Scaffold(body: SizedBox(width: 400, height: 800, child: w)));
Widget wrapProvider(Widget w) => ProviderScope(child: MaterialApp(home: Scaffold(body: w)));

void main() {
  group('Validators', () {
    test('email returns null for valid email', () {
      expect(Validators.email('test@example.com'), null);
      expect(Validators.email('invalid'), isNotNull);
    });

    test('password returns null for valid password', () {
      expect(Validators.password('Abc123!@'), null);
      expect(Validators.password('short'), isNotNull);
    });

    test('phone returns null for valid phone', () {
      expect(Validators.phone('+221771234567'), null);
      expect(Validators.phone('12'), isNotNull);
    });

    test('required returns error for empty value', () {
      expect(Validators.required(''), isNotNull);
      expect(Validators.required('hello'), null);
    });

    test('maxLength / minLength', () {
      expect(Validators.maxLength('hello', 3), isNotNull);
      expect(Validators.minLength('hi', 5), isNotNull);
      expect(Validators.minLength('hello', 3), null);
    });
  });

  group('DateUtils', () {
    test('formatRelative returns today/yesterday/date', () {
      final now = DateTime.now();
      expect(DateFormats.formatRelative(now), "À l'instant");
      expect(DateFormats.formatRelative(now.subtract(const Duration(days: 1))), 'Il y a 1j');
    });

    test('timeAgo returns a string', () {
      final now = DateTime.now();
      final formatted = DateFormats.timeAgo(now);
      expect(formatted, isA<String>());
    });

    test('isToday / isThisWeek / isThisMonth', () {
      expect(DateRangeUtils.isToday(DateTime.now()), true);
      expect(DateRangeUtils.isThisWeek(DateTime.now()), true);
      expect(DateRangeUtils.isThisMonth(DateTime.now()), true);
    });

    test('daysBetween', () {
      expect(DateRangeUtils.daysBetween(DateTime(2026), DateTime(2026, 1, 5)), 4);
    });
  });

  group('DesignTokens', () {
    test('grid values are defined', () {
      expect(DesignTokens.gridSm, 6);
      expect(DesignTokens.gridMd, 14);
    });
    test('text sizes are defined', () {
      expect(DesignTokens.textXs, 10);
      expect(DesignTokens.textSm, 12);
    });
    test('radius values are defined', () {
      expect(DesignTokens.radiusSm, 8);
      expect(DesignTokens.radiusMd, 12);
    });
    test('padding values are defined', () {
      expect(DesignTokens.paddingXs, const EdgeInsets.all(4));
      expect(DesignTokens.paddingSm, const EdgeInsets.all(8));
    });
    test('glow returns shadow list', () {
      expect(DesignTokens.glow(Colors.blue).length, 3);
    });
  });

  group('OuroColors', () {
    test('all named colors are correct', () {
      expect(OuroColors.background, const Color(0xFF060608));
      expect(OuroColors.meshBlue, const Color(0xFF2563FF));
      expect(OuroColors.ouroOrange, const Color(0xFFFF6B2B));
      expect(OuroColors.localGreen, const Color(0xFF00E676));
      expect(OuroColors.textPrimary, const Color(0xFFF0F0F8));
      expect(OuroColors.textSecondary, const Color(0xFF8888A0));
    });
  });

  group('Glass widgets', () {
    testWidgets('GlassContainer renders child', (tester) async {
      await tester.pumpWidget(wrap(GlassContainer(child: const Text('Glass'))));
      expect(find.text('Glass'), findsOneWidget);
    });
    testWidgets('GlowContainer renders child', (tester) async {
      await tester.pumpWidget(wrap(GlowContainer(child: const Text('Glow'))));
      expect(find.text('Glow'), findsOneWidget);
    });
    testWidgets('FrostedSheet renders child', (tester) async {
      await tester.pumpWidget(wrap(FrostedSheet(child: const Text('Frost'))));
      expect(find.text('Frost'), findsOneWidget);
    }, skip: true);
    testWidgets('GradientOverlay renders child', (tester) async {
      await tester.pumpWidget(wrap(GradientOverlay(child: const Text('Gradient'))));
      expect(find.text('Gradient'), findsOneWidget);
    });
    testWidgets('AnimatedGradientBackground renders child', (tester) async {
      await tester.pumpWidget(wrap(AnimatedGradientBackground(child: const Text('Animated'))));
      expect(find.text('Animated'), findsOneWidget);
    });
  });

  group('Widgets', () {
    testWidgets('OuroButton renders', (tester) async {
      await tester.pumpWidget(wrap(OuroButton(label: 'Primary')));
      expect(find.text('Primary'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
    });
    testWidgets('OuroButton onPressed fires', (tester) async {
      int count = 0;
      await tester.pumpWidget(wrap(OuroButton(label: 'Tap', onPressed: () => count++)));
      await tester.tap(find.text('Tap'));
      expect(count, 1);
      await tester.pump(const Duration(milliseconds: 100));
    });
    testWidgets('OuroCard renders', (tester) async {
      await tester.pumpWidget(wrap(OuroCard(child: const Text('Card'))));
      expect(find.text('Card'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
    });
    testWidgets('StatCard renders', (tester) async {
      await tester.pumpWidget(wrap(StatCard(value: '42', label: 'Stat', icon: Icons.info, color: Colors.blue)));
      expect(find.text('Stat'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
    });
    testWidgets('ProgressCard renders', (tester) async {
      await tester.pumpWidget(wrap(ProgressCard(title: 'Prog', subtitle: 'Sub', progress: 0.5, color: Colors.blue)));
      expect(find.text('Prog'), findsOneWidget);
    }, skip: true);
    testWidgets('FeaturedCard renders', (tester) async {
      await tester.pumpWidget(wrap(FeaturedCard(title: 'Feature', subtitle: 'Sub')));
      expect(find.text('Feature'), findsOneWidget);
      expect(find.text('Sub'), findsOneWidget);
    }, skip: true);
    testWidgets('OuroLinearProgress renders', (tester) async {
      await tester.pumpWidget(wrap(OuroLinearProgress(value: 0.5)));
      expect(find.byType(OuroLinearProgress), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
    });
    testWidgets('OuroCircularProgress renders', (tester) async {
      await tester.pumpWidget(wrap(OuroCircularProgress(value: 0.5)));
      expect(find.byType(OuroCircularProgress), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
    });
    testWidgets('OuroStepProgress renders', (tester) async {
      await tester.pumpWidget(wrap(OuroStepProgress(currentStep: 1, totalSteps: 3)));
      expect(find.byType(OuroStepProgress), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
    });
    testWidgets('OuroListTile renders', (tester) async {
      await tester.pumpWidget(wrap(OuroListTile(title: 'List')));
      expect(find.text('List'), findsOneWidget);
    });
    testWidgets('OuroSettingTile renders', (tester) async {
      await tester.pumpWidget(wrap(OuroSettingTile(title: 'Setting', icon: Icons.settings)));
      expect(find.text('Setting'), findsOneWidget);
    });
    testWidgets('OuroInfoTile renders', (tester) async {
      await tester.pumpWidget(wrap(OuroInfoTile(label: 'Info', value: 'Value', icon: Icons.info)));
      expect(find.text('Info'), findsOneWidget);
    });
    testWidgets('OuroBadge renders', (tester) async {
      await tester.pumpWidget(wrap(OuroBadge(label: '3')));
      expect(find.byType(OuroBadge), findsOneWidget);
    });
    testWidgets('OuroStatusDot renders', (tester) async {
      await tester.pumpWidget(wrap(OuroStatusDot()));
      expect(find.byType(OuroStatusDot), findsOneWidget);
    });
    testWidgets('OuroSignalBars renders', (tester) async {
      await tester.pumpWidget(wrap(OuroSignalBars()));
      expect(find.byType(OuroSignalBars), findsOneWidget);
    });
    testWidgets('OuroFadeIn renders child', (tester) async {
      await tester.pumpWidget(wrap(OuroFadeIn(child: const Text('Fade'))));
      expect(find.text('Fade'), findsOneWidget);
      await tester.pumpAndSettle();
    });
    testWidgets('OuroScaleIn renders child', (tester) async {
      await tester.pumpWidget(wrap(OuroScaleIn(child: const Text('Scale'))));
      expect(find.text('Scale'), findsOneWidget);
      await tester.pumpAndSettle();
    });
    testWidgets('OuroShimmerLoader renders', (tester) async {
      await tester.pumpWidget(wrap(OuroShimmerLoader()));
      expect(find.byType(OuroShimmerLoader), findsOneWidget);
    });
  });

  group('Shared widgets', () {
    testWidgets('AvatarWidget renders', (tester) async {
      await tester.pumpWidget(wrap(AvatarWidget(pseudo: 'Alice')));
      expect(find.byType(AvatarWidget), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
    });
    testWidgets('SectionHeader renders', (tester) async {
      await tester.pumpWidget(wrap(SectionHeader(title: 'Section')));
      expect(find.text('Section'), findsOneWidget);
    });
    testWidgets('MeshConnectionCard renders', (tester) async {
      await tester.pumpWidget(wrap(MeshConnectionCard(peerCount: 5, hopCount: 1, signalStrength: 0.8)));
      expect(find.byType(MeshConnectionCard), findsOneWidget);
    }, skip: true);
    testWidgets('MeshPeerTile renders', (tester) async {
      await tester.pumpWidget(wrap(MeshPeerTile(pseudo: 'Alice', signalStrength: 0.8)));
      expect(find.text('Alice'), findsOneWidget);
    });
    testWidgets('MeshTopologyMiniMap renders', (tester) async {
      await tester.pumpWidget(wrap(MeshTopologyMiniMap(nodeCount: 3, connectionCount: 2)));
      expect(find.byType(MeshTopologyMiniMap), findsOneWidget);
    });
    testWidgets('SimpleBarChart renders', (tester) async {
      await tester.pumpWidget(wrapFixed(SimpleBarChart(
        data: [ChartDataPoint(label: 'A', value: 0.3), ChartDataPoint(label: 'B', value: 0.7)],
      )));
      expect(find.byType(SimpleBarChart), findsOneWidget);
    });
    testWidgets('ProgressRing renders', (tester) async {
      await tester.pumpWidget(wrap(ProgressRing(progress: 0.75)));
      expect(find.byType(ProgressRing), findsOneWidget);
    });
    testWidgets('StreakIndicator renders', (tester) async {
      await tester.pumpWidget(wrap(StreakIndicator(streak: 3, goal: 7)));
      expect(find.byType(StreakIndicator), findsOneWidget);
    });
    testWidgets('TimerDisplay renders', (tester) async {
      await tester.pumpWidget(wrap(TimerDisplay(duration: const Duration(hours: 1))));
      expect(find.byType(TimerDisplay), findsOneWidget);
    });
  });

  group('Providers', () {
    test('SettingsProvider returns initial state', () {
      final c = ProviderContainer();
      final s = c.read(settingsProvider);
      expect(s.notificationsEnabled, true);
      expect(s.darkMode, true);
    });
    test('SettingsProvider toggleNotifications', () {
      final c = ProviderContainer();
      c.read(settingsProvider.notifier).toggleNotifications();
      expect(c.read(settingsProvider).notificationsEnabled, false);
    });
    test('SettingsProvider all toggles', () {
      final c = ProviderContainer();
      final n = c.read(settingsProvider.notifier);
      n.toggleDarkMode();
      n.toggleMeshAutoConnect();
      n.toggleDataSaver();
      n.toggleAutoDownload();
      n.toggleDownloadOnWifiOnly();
      n.setQuality('high');
      n.setStorageLimit(4.0);
      final s = c.read(settingsProvider);
      expect(s.darkMode, false);
      expect(s.quality, 'high');
      expect(s.storageLimit, 4.0);
    });
    test('UiProvider returns initial state', () {
      final c = ProviderContainer();
      expect(c.read(uiProvider).currentTab, BottomNavTab.dashboard);
    });
    test('UiProvider setTab', () {
      final c = ProviderContainer();
      c.read(uiProvider.notifier).setTab(BottomNavTab.courses);
      expect(c.read(uiProvider).currentTab, BottomNavTab.courses);
    });
    test('UiProvider full operations', () {
      final c = ProviderContainer();
      final n = c.read(uiProvider.notifier);
      n.setTab(BottomNavTab.ouroLab);
      n.setKeyboardVisible(true);
      n.toggleDrawer();
      n.setScrollOffset(100);
      n.showOverlay('search');
      n.hideOverlay();
      expect(c.read(uiProvider).currentTab, BottomNavTab.ouroLab);
    });
    test('currentTabProvider', () {
      final c = ProviderContainer();
      c.read(uiProvider.notifier).setTab(BottomNavTab.profile);
      expect(c.read(currentTabProvider), BottomNavTab.profile);
    });
  });

  group('CourseModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'c1',
        'title': 'Maths',
        'subject': 'Sciences',
        'description': 'Desc',
        'type': 'PDF',
        'availability': 0,
        'progress': 0.5,
        'imageUrl': 'url',
        'lessonCount': 10,
        'durationMinutes': 120,
      };
      final course = CourseModel.fromJson(json);
      expect(course.id, 'c1');
      expect(course.title, 'Maths');
      expect(course.availability, CourseAvailability.local);
    });

    test('toJson round-trips', () {
      final course = CourseModel(id: 'c1', title: 'T', subject: 'S');
      final json = course.toJson();
      final restored = CourseModel.fromJson(json);
      expect(restored.id, course.id);
      expect(restored.title, course.title);
    });

    test('copyWith works', () {
      final c = CourseModel(id: 'c1', title: 'Old', subject: 'S');
      final copy = c.copyWith(title: 'New');
      expect(copy.title, 'New');
      expect(copy.id, 'c1');
    });

    test('equality', () {
      final a = CourseModel(id: 'c1', title: 'T', subject: 'S');
      final b = CourseModel(id: 'c1', title: 'T', subject: 'S');
      expect(a.toJson(), equals(b.toJson()));
    });
  });

  group('GamificationService', () {
    test('ProgressionState toJson/fromJson round-trip', () {
      const state = ProgressionState(
        completedSections: {'s1'},
        passedChapterExams: {'e1'},
        passedSubjectExams: {'se1'},
      );
      final roundTripped = ProgressionState.fromJson(state.toJson());
      expect(roundTripped.completedSections, state.completedSections);
    });

    test('completeSection modifies state', () {
      final before = GamificationService.state.completedSections.length;
      GamificationService.completeSection('all-test-sec-$before');
      expect(GamificationService.state.completedSections.length, greaterThan(before));
    });

    test('passSubjectExam modifies state', () {
      final before = GamificationService.state.passedSubjectExams.length;
      GamificationService.passSubjectExam('all-test-subj-$before');
      expect(GamificationService.state.passedSubjectExams.length, greaterThan(before));
    });

    test('chapterProgress returns 0 with no content', () {
      expect(GamificationService.chapterProgress('x', 'y'), 0.0);
    });

    test('courseProgress returns 0 with no content', () {
      expect(GamificationService.courseProgress('x'), 0.0);
    });
  });

  group('StorageService', () {
    test('getString/setString round-trip', () async {
      await StorageService.setString('all_test_key', 'hello');
      expect(StorageService.getString('all_test_key'), 'hello');
      await StorageService.remove('all_test_key');
    });

    test('getCourses returns a list', () {
      expect(StorageService.getCourses(), isA<List>());
    });

    test('setOnboardingComplete marks done', () async {
      await StorageService.setOnboardingComplete();
      expect(StorageService.isOnboardingComplete(), true);
      await StorageService.remove('onboarding_complete');
    });

    test('getStreakDays returns int', () {
      expect(StorageService.getStreakDays(), isA<int>());
    });

    test('getQuizScore returns int', () {
      expect(StorageService.getQuizScore(), isA<int>());
    });
  });

  group('ApiResponse', () {
    test('isSuccess for 2xx', () {
      expect(const ApiResponse(statusCode: 200).isSuccess, true);
      expect(const ApiResponse(statusCode: 300).isSuccess, false);
    });

    test('fold calls correct branch', () {
      final ok = ApiResponse<String>(statusCode: 200, data: 'x');
      expect(ok.fold((d) => d, (_) => ''), 'x');
      const fail = ApiResponse<String>(statusCode: 500);
      expect(fail.fold((d) => d, (_) => 'err'), 'err');
    });
  });
}
