import 'dart:ui';

class EditorState {
  final String imagePath;
  final double scale;
  final double rotation; // 弧度
  final Offset position;
  final Size canvasSize;

  const EditorState({
    required this.imagePath,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.position = Offset.zero,
    this.canvasSize = const Size(1080, 1920),
  });

  EditorState copyWith({
    String? imagePath,
    double? scale,
    double? rotation,
    Offset? position,
    Size? canvasSize,
  }) {
    return EditorState(
      imagePath: imagePath ?? this.imagePath,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      position: position ?? this.position,
      canvasSize: canvasSize ?? this.canvasSize,
    );
  }
}
