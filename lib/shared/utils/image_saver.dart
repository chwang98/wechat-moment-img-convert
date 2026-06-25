import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class ImageSaver {
  /// 处理并保存编辑后的图片到相册
  static Future<bool> saveEditedImage({
    required String sourcePath,
    required Size? imageSize,
    required Size canvasSize,
    required double userScale,
    required double rotation,
    required Color backgroundColor,
    required BuildContext context,
  }) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        if (context.mounted) _showError(context, '源文件不存在');
        return false;
      }

      final bytes = await sourceFile.readAsBytes();

      final canvasWidth = canvasSize.width.toInt();
      final canvasHeight = canvasSize.height.toInt();
      final bgR = (backgroundColor.r * 255).round().clamp(0, 255);
      final bgG = (backgroundColor.g * 255).round().clamp(0, 255);
      final bgB = (backgroundColor.b * 255).round().clamp(0, 255);
      final bgA = (backgroundColor.a * 255).round().clamp(0, 255);

      // 解码源图，并应用 EXIF 方向修正
      var sourceImage = img.decodeImage(bytes);
      if (sourceImage == null) {
        if (context.mounted) _showError(context, '无法解码图片');
        return false;
      }
      sourceImage = img.bakeOrientation(sourceImage);

      // 计算 BoxFit.contain 对应的缩放倍率
      final imgW = (imageSize?.width ?? sourceImage.width.toDouble());
      final imgH = (imageSize?.height ?? sourceImage.height.toDouble());
      final containScale = math.min(
        canvasWidth / imgW,
        canvasHeight / imgH,
      );
      final effectiveScale = containScale * userScale;

      // 缩放源图片
      final scaledWidth = (sourceImage.width * effectiveScale).toInt();
      final scaledHeight = (sourceImage.height * effectiveScale).toInt();
      final scaledImage = img.copyResize(
        sourceImage,
        width: scaledWidth,
        height: scaledHeight,
        interpolation: img.Interpolation.cubic,
      );

      // 旋转
      final img.Image finalImage;
      if (rotation != 0) {
        finalImage = img.copyRotate(scaledImage, angle: rotation);
      } else {
        finalImage = scaledImage;
      }

      // 创建画布
      final canvas = img.Image(
        width: canvasWidth,
        height: canvasHeight,
        backgroundColor: img.ColorRgba8(bgR, bgG, bgB, bgA),
      );

      // 居中合成到画布
      final dstX = (canvasWidth - finalImage.width) ~/ 2;
      final dstY = (canvasHeight - finalImage.height) ~/ 2;
      img.compositeImage(canvas, finalImage, dstX: dstX, dstY: dstY);

      // 编码为 PNG
      final pngBytes = Uint8List.fromList(img.encodePng(canvas));

      // 保存到相册
      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        quality: 100,
        name: 'wechat_moment_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (result['isSuccess'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('图片已保存到相册')),
          );
        }
        return true;
      } else {
        if (context.mounted) _showError(context, '保存失败');
        return false;
      }
    } catch (e) {
      if (context.mounted) _showError(context, '保存出错: $e');
      return false;
    }
  }

  static void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }
}
