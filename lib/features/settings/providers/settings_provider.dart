import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final int canvasWidth;
  final int canvasHeight;
  final Color canvasBackgroundColor;

  const SettingsState({
    this.canvasWidth = 2259,
    this.canvasHeight = 4524,
    this.canvasBackgroundColor = Colors.black,
  });

  SettingsState copyWith({
    int? canvasWidth,
    int? canvasHeight,
    Color? canvasBackgroundColor,
  }) {
    return SettingsState(
      canvasWidth: canvasWidth ?? this.canvasWidth,
      canvasHeight: canvasHeight ?? this.canvasHeight,
      canvasBackgroundColor:
          canvasBackgroundColor ?? this.canvasBackgroundColor,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _loadFromPrefs();
  }

  static const _keyCanvasWidth = 'canvas_width';
  static const _keyCanvasHeight = 'canvas_height';
  static const _keyCanvasBgColor = 'canvas_bg_color';

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final width = prefs.getInt(_keyCanvasWidth) ?? 2259;
    final height = prefs.getInt(_keyCanvasHeight) ?? 4524;
    final bgColor =
        prefs.getInt(_keyCanvasBgColor) ?? Colors.black.toARGB32();

    state = SettingsState(
      canvasWidth: width,
      canvasHeight: height,
      canvasBackgroundColor: Color(bgColor),
    );
  }

  Future<void> setCanvasWidth(int width) async {
    if (width <= 0) return;
    state = state.copyWith(canvasWidth: width);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCanvasWidth, width);
  }

  Future<void> setCanvasHeight(int height) async {
    if (height <= 0) return;
    state = state.copyWith(canvasHeight: height);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCanvasHeight, height);
  }

  Future<void> setCanvasBackgroundColor(Color color) async {
    state = state.copyWith(canvasBackgroundColor: color);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCanvasBgColor, color.toARGB32());
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
