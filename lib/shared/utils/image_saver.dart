import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class ImageSaver {
  /// 将编辑后的图片以指定画布分辨率渲染并保存到相册
  static Future<bool> saveEditedImage({
    required String sourcePath,
    required Size canvasSize,
    required double scale,
    required double rotation,
    required Offset position,
    required BuildContext context,
  }) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        _showError(context, '源文件不存在');
        return false;
      }

      final bytes = await sourceFile.readAsBytes();
      final sourceImage = img.decodeImage(bytes);
      if (sourceImage == null) {
        _showError(context, '无法解码图片');
        return false;
      }

      // 创建画布
      final canvas = img.Image(
        width: canvasSize.width.toInt(),
        height: canvasSize.height.toInt(),
        backgroundColor: img.ColorRgba8(255, 255, 255, 255),
      );


      // 缩放源图片
      final scaledWidth = (sourceImage.width * scale).toInt();
      final scaledHeight = (sourceImage.height * scale).toInt();
      final scaledImage = img.copyResize(
        sourceImage,
        width: scaledWidth,
        height: scaledHeight,
      );

      // 旋转图片
      img.Image finalImage;
      if (rotation != 0) {
        finalImage = img.copyRotate(scaledImage, angle: rotation);
      } else {
        finalImage = scaledImage;
      }

      // 将图片合成到画布上
      img.compositeImage(
        canvas,
        finalImage,
        dstX: position.dx.toInt(),
        dstY: position.dy.toInt(),
      );

      // 保存到相册
      final result = await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(img.encodePng(canvas)),
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
        _showError(context, '保存失败');
        return false;
      }
    } catch (e) {
      _showError(context, '保存出错: $e');
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
