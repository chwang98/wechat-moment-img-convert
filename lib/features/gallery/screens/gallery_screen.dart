import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../features/editor/screens/editor_screen.dart';
import '../widgets/image_grid.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<AssetEntity> _images = [];
  bool _isLoading = true;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final result = await PhotoManager.requestPermissionExtend();
    if (mounted) {
      setState(() {
        _hasPermission = result.isAuth;
      });
      if (_hasPermission) {
        _loadImages();
      }
    }
  }

  Future<void> _loadImages() async {
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (albums.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    final images = await albums.first.getAssetListPaged(
      page: 0,
      size: 100,
    );

    if (mounted) {
      setState(() {
        _images = images;
        _isLoading = false;
      });
    }
  }

  Future<void> _openEditor(AssetEntity asset) async {
    final file = await asset.file;
    if (file != null && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EditorScreen(imagePath: file.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('朋友圈图片编辑'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasPermission) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.photo_library_outlined, size: 64),
            const SizedBox(height: 16),
            const Text('需要访问相册权限'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _requestPermission,
              child: const Text('授予权限'),
            ),
          ],
        ),
      );
    }

    if (_images.isEmpty) {
      return const Center(child: Text('没有找到图片'));
    }

    return ImageGrid(
      images: _images,
      onTap: _openEditor,
    );
  }
}
