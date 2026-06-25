import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/editor_provider.dart';
import 'snap_guide.dart';

class EditorCanvas extends ConsumerStatefulWidget {
  final String imagePath;

  const EditorCanvas({super.key, required this.imagePath});

  @override
  ConsumerState<EditorCanvas> createState() => _EditorCanvasState();
}

class _EditorCanvasState extends ConsumerState<EditorCanvas> {
  final TransformationController _transformController =
      TransformationController();
  bool _showGuides = false;
  double _lastSyncedScale = 1.0;

  @override
  void initState() {
    super.initState();
    _transformController.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _transformController.removeListener(_onTransformChanged);
    _transformController.dispose();
    super.dispose();
  }

  /// 用户手势 → EditorNotifier
  void _onTransformChanged() {
    final scale = _transformController.value.getMaxScaleOnAxis();
    if ((scale - _lastSyncedScale).abs() > 0.001) {
      _lastSyncedScale = scale;
      ref
          .read(editorProvider(widget.imagePath).notifier)
          .syncUserScale(scale);
    }
  }

  /// EditorNotifier → InteractiveViewer
  void _syncToViewer(double targetScale) {
    if ((_transformController.value.getMaxScaleOnAxis() - targetScale)
                .abs() <=
            0.001) {
      return;
    }

    _lastSyncedScale = targetScale;
    _transformController.value = Matrix4.diagonal3Values(
        targetScale, targetScale, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorProvider(widget.imagePath));

    // 监听 userScale 变化（来自工具栏按钮），同步到 InteractiveViewer
    ref.listen(editorProvider(widget.imagePath), (prev, next) {
      if (prev?.userScale != next.userScale) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _syncToViewer(next.userScale);
        });
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasScale =
            constraints.maxWidth / editorState.canvasSize.width;
        final displayHeight = editorState.canvasSize.height * canvasScale;

        return Center(
          child: Container(
            width: constraints.maxWidth,
            height: displayHeight,
            decoration: BoxDecoration(
              color: editorState.canvasBackgroundColor,
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: ClipRect(
              child: Stack(
                children: [
                  InteractiveViewer(
                    transformationController: _transformController,
                    minScale: AppConstants.minScale,
                    maxScale: AppConstants.maxScale,
                    onInteractionStart: (_) =>
                        setState(() => _showGuides = true),
                    onInteractionEnd: (_) =>
                        setState(() => _showGuides = false),
                    child: Image.file(
                      File(editorState.imagePath),
                      fit: BoxFit.contain,
                      width: editorState.canvasSize.width,
                      height: editorState.canvasSize.height,
                    ),
                  ),
                  if (_showGuides)
                    SnapGuide(
                      canvasSize:
                          Size(constraints.maxWidth, displayHeight),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
