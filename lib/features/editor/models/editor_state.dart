import 'package:flutter/material.dart';

class EditorState {
  final String imagePath;
  /// 原始图片像素尺寸
  final Size? imageSize;
  /// 用户在 InteractiveViewer 中的缩放倍率（1.0 = BoxFit.contain 状态）
  final double userScale;
  final double rotation; // 弧度
  final Size canvasSize;
  final Color canvasBackgroundColor;

  const EditorState({
    required this.imagePath,
    this.imageSize,
    this.userScale = 1.0,
    this.rotation = 0.0,
    this.canvasSize = const Size(2259, 4524),
    this.canvasBackgroundColor = Colors.black,
  });

  EditorState copyWith({
    String? imagePath,
    Size? imageSize,
    bool clearImageSize = false,
    double? userScale,
    double? rotation,
    Size? canvasSize,
    Color? canvasBackgroundColor,
  }) {
    return EditorState(
      imagePath: imagePath ?? this.imagePath,
      imageSize: clearImageSize ? null : (imageSize ?? this.imageSize),
      userScale: userScale ?? this.userScale,
      rotation: rotation ?? this.rotation,
      canvasSize: canvasSize ?? this.canvasSize,
      canvasBackgroundColor:
          canvasBackgroundColor ?? this.canvasBackgroundColor,
    );
  }
}
