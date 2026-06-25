import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../features/editor/screens/editor_screen.dart';
import '../../../shared/services/image_storage.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => GalleryScreenState();
}

class GalleryScreenState extends State<GalleryScreen> {
  List<String> _imagePaths = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void refreshGallery() {
    _loadImages();
  }

  Future<void> _loadImages() async {
    final paths = await ImageStorage.getImages();
    if (mounted) {
      setState(() {
        _imagePaths = paths;
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAndAddImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (picked == null || !mounted) return;

    // 复制到应用内部存储
    final savedPath = await ImageStorage.addImage(picked.path);
    if (savedPath != null && mounted) {
      await _loadImages();
      // 直接打开编辑器
      _openEditor(savedPath);
    }
  }

  void _openEditor(String path) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditorScreen(imagePath: path),
      ),
    );
  }

  Future<void> _deleteImage(String path) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要从图库中移除这张图片吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await ImageStorage.removeImage(path);
      await _loadImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('朋友圈图片编辑'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndAddImage,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_imagePaths.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              '暂无图片',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '点击右下角 + 选择图片',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: _imagePaths.length,
      itemBuilder: (context, index) {
        final path = _imagePaths[index];
        return GestureDetector(
          onTap: () => _openEditor(path),
          onLongPress: () => _deleteImage(path),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
        );
      },
    );
  }
}
