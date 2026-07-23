import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BottomNavTab { dashboard, courses, forum, ouroLab, profile }

class UiState {
  final BottomNavTab currentTab;
  final bool isKeyboardVisible;
  final bool isDrawerOpen;
  final double scrollOffset;
  final String? currentOverlay;

  const UiState({
    this.currentTab = BottomNavTab.dashboard,
    this.isKeyboardVisible = false,
    this.isDrawerOpen = false,
    this.scrollOffset = 0.0,
    this.currentOverlay,
  });

  UiState copyWith({
    BottomNavTab? currentTab,
    bool? isKeyboardVisible,
    bool? isDrawerOpen,
    double? scrollOffset,
    String? currentOverlay,
  }) {
    return UiState(
      currentTab: currentTab ?? this.currentTab,
      isKeyboardVisible: isKeyboardVisible ?? this.isKeyboardVisible,
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      currentOverlay: currentOverlay ?? this.currentOverlay,
    );
  }
}

class UiNotifier extends StateNotifier<UiState> {
  UiNotifier() : super(const UiState());

  void setTab(BottomNavTab tab) => state = state.copyWith(currentTab: tab);
  void setKeyboardVisible(bool visible) => state = state.copyWith(isKeyboardVisible: visible);
  void toggleDrawer() => state = state.copyWith(isDrawerOpen: !state.isDrawerOpen);
  void setScrollOffset(double offset) => state = state.copyWith(scrollOffset: offset);
  void showOverlay(String overlay) => state = state.copyWith(currentOverlay: overlay);
  void hideOverlay() => state = state.copyWith(currentOverlay: null);
}

final uiProvider = StateNotifierProvider<UiNotifier, UiState>((ref) {
  return UiNotifier();
});

final currentTabProvider = Provider<BottomNavTab>((ref) {
  return ref.watch(uiProvider).currentTab;
});
