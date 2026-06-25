import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../settings/providers/settings_provider.dart';
import '../models/editor_state.dart';

final editorProvider =
    StateNotifierProvider.family<EditorNotifier, EditorState, String>(
  (ref, imagePath) => EditorNotifier(imagePath, settingsRef: ref),
);

class EditorNotifier extends StateNotifier<EditorState> {
  EditorNotifier(String imagePath, {Ref? settingsRef})
      : super(EditorState(
          imagePath: imagePath,
          canvasSize: _getCanvasSize(settingsRef),
          canvasBackgroundColor: _getCanvasBackgroundColor(settingsRef),
        ));

  static Size _getCanvasSize(Ref? ref) {
    if (ref != null) {
      final settings = ref.read(settingsProvider);
      return Size(
        settings.canvasWidth.toDouble(),
        settings.canvasHeight.toDouble(),
      );
    }
    return const Size(AppConstants.canvasWidth, AppConstants.canvasHeight);
  }

  static Color _getCanvasBackgroundColor(Ref? ref) {
    if (ref != null) {
      return ref.read(settingsProvider).canvasBackgroundColor;
    }
    return Colors.black;
  }

  /// 设置原始图片尺寸
  void setImageSize(Size size) {
    state = state.copyWith(imageSize: size);
  }

  /// 从 InteractiveViewer 同步用户缩放
  void syncUserScale(double scale) {
    final clamped =
        scale.clamp(AppConstants.minScale, AppConstants.maxScale);
    state = state.copyWith(userScale: clamped);
  }

  /// 铺满宽度：在 contain 基础上进一步缩放到宽度填满
  void fitToWidth() {
    final imgSize = state.imageSize;
    if (imgSize == null || imgSize.isEmpty) return;

    final canvasW = state.canvasSize.width;
    final canvasH = state.canvasSize.height;
    final containScale =
        (imgSize.width / imgSize.height > canvasW / canvasH)
            ? canvasW / imgSize.width
            : canvasH / imgSize.height;
    if (containScale == 0) return;

    // 宽度填满所需的 InteractiveViewer 倍率
    final fillWidthScale = canvasW / (imgSize.width * containScale);
    state = state.copyWith(userScale: fillWidthScale.clamp(
        AppConstants.minScale, AppConstants.maxScale));
  }

  /// 旋转后铺满宽度
  void rotateAndFitToWidth() {
    final imgSize = state.imageSize;
    if (imgSize == null || imgSize.isEmpty) return;

    final rotated = Size(imgSize.height, imgSize.width);
    final canvasW = state.canvasSize.width;
    final canvasH = state.canvasSize.height;
    final containScale =
        (rotated.width / rotated.height > canvasW / canvasH)
            ? canvasW / rotated.width
            : canvasH / rotated.height;
    if (containScale == 0) return;

    final fillWidthScale = canvasW / (rotated.width * containScale);
    state = state.copyWith(
      rotation: state.rotation + pi / 2,
      userScale: fillWidthScale.clamp(
          AppConstants.minScale, AppConstants.maxScale),
    );
  }

  void resetTransform() {
    state = state.copyWith(userScale: 1.0, rotation: 0.0);
  }
}
