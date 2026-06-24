import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/editor_provider.dart';
import '../widgets/editor_canvas.dart';
import '../widgets/editor_toolbar.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final String imagePath;

  const EditorScreen({super.key, required this.imagePath});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  Size? _imageSize;

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
        setState(() {
          _imageSize = Size(
            decoded.width.toDouble(),
            decoded.height.toDouble(),
          );
        });
      }
    }
  }

  void _onFitToWidth() {
    if (_imageSize != null) {
      ref.read(editorProvider(widget.imagePath).notifier).fitToWidth(_imageSize!);
    }
  }

  void _onRotate90() {
    if (_imageSize != null) {
      ref
          .read(editorProvider(widget.imagePath).notifier)
          .rotateAndFitToWidth(_imageSize!);
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
      body: Column(
        children: [
          Expanded(
            child: EditorCanvas(imagePath: widget.imagePath),
          ),
          EditorToolbar(
            onFitToWidth: _onFitToWidth,
            onRotate90: _onRotate90,
          ),
        ],
      ),
    );
  }
}
