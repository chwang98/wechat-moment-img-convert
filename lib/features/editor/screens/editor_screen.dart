import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/editor_provider.dart';
import '../widgets/editor_canvas.dart';
import '../widgets/editor_toolbar.dart';
import '../../../shared/utils/image_saver.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final String imagePath;

  const EditorScreen({super.key, required this.imagePath});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  bool _isImageReady = false;

  @override
  void initState() {
    super.initState();
    _loadImageSize();
  }

  Future<void> _loadImageSize() async {
    final file = File(widget.imagePath);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      final decoded = await decodeImageFromList(bytes);
      if (mounted) {
        final size = Size(
          decoded.width.toDouble(),
          decoded.height.toDouble(),
        );
        ref
            .read(editorProvider(widget.imagePath).notifier)
            .setImageSize(size);
        setState(() => _isImageReady = true);
      }
    }
  }

  void _onFitToWidth() {
    ref.read(editorProvider(widget.imagePath).notifier).fitToWidth();
  }

  void _onRotate90() {
    ref
        .read(editorProvider(widget.imagePath).notifier)
        .rotateAndFitToWidth();
  }

  Future<void> _onSave() async {
    final state = ref.read(editorProvider(widget.imagePath));

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    // 等待对话框渲染
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      if (!mounted) return;
      await ImageSaver.saveEditedImage(
        sourcePath: state.imagePath,
        imageSize: state.imageSize,
        canvasSize: state.canvasSize,
        userScale: state.userScale,
        rotation: state.rotation,
        backgroundColor: state.canvasBackgroundColor,
        context: context,
      );
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('编辑图片'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: '保存',
            onPressed: _onSave,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重置',
            onPressed: () {
              ref
                  .read(editorProvider(widget.imagePath).notifier)
                  .resetTransform();
            },
          ),
        ],
      ),
      body: _isImageReady
          ? Column(
              children: [
                Expanded(
                  child: EditorCanvas(imagePath: widget.imagePath),
                ),
                EditorToolbar(
                  onFitToWidth: _onFitToWidth,
                  onRotate90: _onRotate90,
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
