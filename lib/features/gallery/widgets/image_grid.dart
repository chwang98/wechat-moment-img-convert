import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageGrid extends StatelessWidget {
  final List<AssetEntity> images;
  final void Function(AssetEntity asset) onTap;

  const ImageGrid({
    super.key,
    required this.images,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return _ImageThumbnail(
          asset: images[index],
          onTap: () => onTap(images[index]),
        );
      },
    );
  }
}

class _ImageThumbnail extends StatefulWidget {
  final AssetEntity asset;
  final VoidCallback onTap;

  const _ImageThumbnail({
    required this.asset,
    required this.onTap,
  });

  @override
  State<_ImageThumbnail> createState() => _ImageThumbnailState();
}

class _ImageThumbnailState extends State<_ImageThumbnail> {
  Uint8List? _thumbnailData;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    final data = await widget.asset.thumbnailDataWithSize(
      const ThumbnailSize.square(300),
    );
    if (mounted) {
      setState(() => _thumbnailData = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: _thumbnailData != null
            ? Image.memory(
                _thumbnailData!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _errorWidget(context),
              )
            : _errorWidget(context),
      ),
    );
  }

  Widget _errorWidget(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.broken_image_outlined),
    );
  }
}
