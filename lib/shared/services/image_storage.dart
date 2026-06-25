import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 管理 APP 内图库：将用户选择的图片复制到应用文档目录并持久化路径
class ImageStorage {
  static const _prefsKey = 'selected_image_paths';

  /// 获取所有已存储的图片路径
  static Future<List<String>> getImages() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> paths = prefs.getStringList(_prefsKey) ?? [];
    // 过滤掉已不存在的文件
    final valid = paths.where((p) => File(p).existsSync()).toList();
    if (valid.length != paths.length) {
      await prefs.setStringList(_prefsKey, valid);
    }
    return valid;
  }

  /// 添加一张图片（复制到应用文档目录），返回持久化后的路径
  static Future<String?> addImage(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) return null;

      final dir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${dir.path}/gallery_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final ext = sourcePath.split('.').last;
      final fileName =
          'img_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final destPath = '${imagesDir.path}/$fileName';
      await sourceFile.copy(destPath);

      // 持久化路径
      final prefs = await SharedPreferences.getInstance();
      final paths = (prefs.getStringList(_prefsKey) ?? []).toList();
      paths.add(destPath);
      await prefs.setStringList(_prefsKey, paths);

      return destPath;
    } catch (_) {
      return null;
    }
  }

  /// 删除一张图片
  static Future<void> removeImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      final prefs = await SharedPreferences.getInstance();
      final paths = (prefs.getStringList(_prefsKey) ?? []).toList();
      paths.remove(path);
      await prefs.setStringList(_prefsKey, paths);
    } catch (_) {}
  }
}
