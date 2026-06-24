class AppConstants {
  AppConstants._();

  /// 编辑画布默认分辨率
  static const double canvasWidth = 1080;
  static const double canvasHeight = 1920;

  /// 吸附阈值（像素）
  static const double snapThreshold = 10;

  /// 最小缩放比例
  static const double minScale = 0.1;

  /// 最大缩放比例
  static const double maxScale = 5.0;

  /// 旋转步进角度
  static const double rotationStep = 90;

  /// 图片网格列数
  static const int gridCrossAxisCount = 4;
}
