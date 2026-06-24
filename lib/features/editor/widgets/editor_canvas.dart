import 'dart:io';
import 'dart:ui';
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

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorProvider(widget.imagePath));

    return LayoutBuilder(
      builder: (context, constraints) {
        // 计算画布缩放以适配屏幕
        final canvasScale = constraints.maxWidth / editorState.canvasSize.width;
        final displayHeight = editorState.canvasSize.height * canvasScale;

        return GestureDetector(
          onPanStart: (_) => setState(() => _showGuides = true),
          onPanEnd: (_) => setState(() => _showGuides = false),
          child: Center(
            child: Container(
              width: constraints.maxWidth,
              height: displayHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: ClipRect(
                child: Stack(
                  children: [
                    // 图片变换层
                    InteractiveViewer(
                      transformationController: _transformController,
                      minScale: AppConstants.minScale,
                      maxScale: AppConstants.maxScale,
                      child: SizedBox(
                        width: editorState.canvasSize.width,
                        height: editorState.canvasSize.height,
                        child: Image.file(
                          File(editorState.imagePath),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // 中线吸附引导线
                    if (_showGuides)
                      SnapGuide(
                        canvasSize:
                            Size(constraints.maxWidth, displayHeight),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
