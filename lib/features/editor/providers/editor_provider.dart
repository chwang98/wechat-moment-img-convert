import 'dart:math';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../models/editor_state.dart';

/// 按 imagePath 区分的 editor provider 族
final editorProvider =
    StateNotifierProvider.family<EditorNotifier, EditorState, String>(
  (ref, imagePath) => EditorNotifier(imagePath),
);

class EditorNotifier extends StateNotifier<EditorState> {
  EditorNotifier(String imagePath, {Size? canvasSize})
      : super(EditorState(
          imagePath: imagePath,
          canvasSize: canvasSize ??
              const Size(AppConstants.canvasWidth,
                  AppConstants.canvasHeight),
        ));

  void updatePosition(Offset delta) {
    final newPosition = state.position + delta;
    final snapped = _applySnap(newPosition);
    state = state.copyWith(position: snapped);
  }

  /// 吸附逻辑：自动吸附到画布中线
  Offset _applySnap(Offset position) {
    final canvas = state.canvasSize;
    double x = position.dx;
    double y = position.dy;

    // 吸附到垂直中线
    final centerX = canvas.width / 2;
    if ((x - centerX).abs() < AppConstants.snapThreshold) {
      x = centerX;
    }

    // 吸附到水平中线
    final centerY = canvas.height / 2;
    if ((y - centerY).abs() < AppConstants.snapThreshold) {
      y = centerY;
    }

    return Offset(x, y);
  }

  void updateScale(double newScale) {
    final clamped = newScale.clamp(
      AppConstants.minScale,
      AppConstants.maxScale,
    );
    state = state.copyWith(scale: clamped);
  }

  void rotate(double angle) {
    final newRotation = state.rotation + angle;
    state = state.copyWith(rotation: newRotation);
  }

  /// 以宽度铺满画布，高度自动计算
  void fitToWidth(Size imageSize) {
    if (imageSize.isEmpty) return;

    final canvasWidth = state.canvasSize.width;
    final scale = canvasWidth / imageSize.width;
    final scaledHeight = imageSize.height * scale;
    final centerX = state.canvasSize.width / 2;
    final centerY = state.canvasSize.height / 2;

    state = state.copyWith(
      scale: scale,
      position: Offset(centerX, centerY - scaledHeight / 2),
    );
  }

  /// 旋转后以宽度铺满画布
  void rotateAndFitToWidth(Size imageSize) {
    // 旋转后宽高互换
    final rotatedSize = Size(imageSize.height, imageSize.width);
    final canvasWidth = state.canvasSize.width;
    final scale = canvasWidth / rotatedSize.width;
    final scaledHeight = rotatedSize.height * scale;
    final centerX = state.canvasSize.width / 2;
    final centerY = state.canvasSize.height / 2;

    state = state.copyWith(
      rotation: state.rotation + pi / 2,
      scale: scale,
      position: Offset(centerX, centerY - scaledHeight / 2),
    );
  }

  void resetTransform() {
    state = state.copyWith(
      scale: 1.0,
      rotation: 0.0,
      position: Offset.zero,
    );
  }
}
