import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../features/editor/screens/editor_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<String> _pickedImages = [];
  bool _isLoading = true;
  bool _isNativeAvailable = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initGallery();
  }

  Future<void> _initGallery() async {
    try {
      final result = await PhotoManager.requestPermissionExtend();
      if (!mounted) return;

      if (!result.isAuth) {
        setState(() {
          _isLoading = false;
          _isNativeAvailable = false;
          _errorMessage = '需要访问相册权限';
        });
        return;
      }

      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (!mounted) return;

      if (albums.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final images = await albums.first.getAssetListPaged(
        page: 0,
        size: 100,
      );

      if (!mounted) return;

      // 预加载文件路径用于后续编辑
      for (final asset in images) {
        final file = await asset.file;
        if (file != null) {
          _pickedImages.add(file.path);
        }
      }

      setState(() {
        _isLoading = false;
        _isNativeAvailable = true;
      });
    } catch (e) {
      // photo_manager 不可用（Web平台等），回退到 image_picker
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isNativeAvailable = false;
          _errorMessage = null;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() => _pickedImages.add(picked.path));
    }
  }

  void _openEditor(String path) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditorScreen(imagePath: path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('朋友圈图片编辑'),
      ),
      body: _buildBody(),
      floatingActionButton: !_isNativeAvailable
          ? FloatingActionButton.extended(
              onPressed: _pickImage,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('选择图片'),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _pickedImages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.photo_library_outlined, size: 64),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _initGallery,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (_pickedImages.isEmpty) {
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
              '点击下方按钮从相册选择',
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
      itemCount: _pickedImages.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _openEditor(_pickedImages[index]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(
              File(_pickedImages[index]),
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
