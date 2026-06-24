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

class _ImageThumbnail extends StatelessWidget {
  final AssetEntity asset;
  final VoidCallback onTap;

  const _ImageThumbnail({
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: AssetEntityImage(
          asset,
          isOriginal: false,
          thumbnailSize: const ThumbnailSize.square(300),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.broken_image_outlined),
            );
          },
        ),
      ),
    );
  }
}
