# 朋友圈图片编辑器 (WeChat Moment Image Editor)

基于 Flutter 开发的图片编辑 APP，支持从相册选择图片，在指定分辨率画布上进行缩放、旋转、吸附对齐等编辑操作，编辑完成后可保存到相册。

## 项目情况

| 项目 | 说明 |
|------|------|
| 项目名称 | wechat\_moment\_img\_convert |
| 当前版本 | 1.0.0+1 |
| 目标平台 | Android / iOS |
| 开发状态 | 框架搭建完成，核心功能开发中 |

## 技术选型

| 领域 | 技术 | 版本 | 说明 |
|------|------|------|------|
| 框架 | Flutter | ^3.27.0 | Google 跨平台 UI 框架 |
| 语言 | Dart | ^3.6.0 | |
| 状态管理 | flutter\_riverpod | ^2.6.1 | Riverpod 声明式状态管理 |
| 图片选择 | photo\_manager | ^3.6.4 | 高性能相册访问 |
| 图片选择 | image\_picker | ^1.1.2 | 系统图片选择器 |
| 图片处理 | image | ^4.5.2 | Dart 原生图片编解码与变换 |
| 图片保存 | image\_gallery\_saver\_plus | ^3.0.5 | 保存图片到相册 |
| 权限管理 | permission\_handler | ^11.3.1 | 跨平台权限请求 |
| 代码生成 | riverpod\_generator + build\_runner | - | Riverpod 代码生成 |
| 代码规范 | flutter\_lints | ^5.0.0 | 官方推荐 Lint 规则 |

## 目录树结构

```
wechat-moment-img-convert/
├── doc/
│   ├── README.md                    # 项目文档（本文件）
│   └── development-progress.md      # 开发进度文档
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── app.dart                     # MaterialApp 配置
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart   # 应用常量
│   │   └── theme/
│   │       └── app_theme.dart       # Material Design 3 主题
│   ├── features/
│   │   ├── gallery/
│   │   │   ├── screens/
│   │   │   │   └── gallery_screen.dart   # 相册浏览页
│   │   │   └── widgets/
│   │   │       └── image_grid.dart       # 图片网格组件
│   │   └── editor/
│   │       ├── models/
│   │       │   └── editor_state.dart     # 编辑状态模型
│   │       ├── providers/
│   │       │   └── editor_provider.dart  # 编辑器状态管理
│   │       ├── screens/
│   │       │   └── editor_screen.dart    # 编辑器页面
│   │       └── widgets/
│   │           ├── editor_canvas.dart    # 编辑画布
│   │           ├── editor_toolbar.dart   # 底部工具栏
│   │           └── snap_guide.dart       # 吸附辅助线
│   └── shared/
│       ├── utils/
│       │   └── image_saver.dart          # 图片保存工具
│       └── widgets/                      # 共享组件
├── pubspec.yaml                    # 依赖配置
└── analysis_options.yaml           # 代码分析配置
```

## 启动命令

```bash
# 1. 安装依赖
flutter pub get

# 2. 运行代码生成（首次或修改注解后）
flutter pub run build_runner build --delete-conflicting-outputs

# 3. 启动应用（调试模式）
flutter run

# 4. 构建 APK
flutter build apk --release

# 5. 构建 iOS
flutter build ios --release

# 6. 代码分析
flutter analyze

# 7. 运行测试
flutter test
```

## 功能概览

1. **相册浏览** — 网格展示手机中所有图片，点击选择进入编辑
2. **画布编辑** — 在 1080×1920 分辨率的画布上自由缩放旋转图片
3. **吸附对齐** — 拖动图片时自动吸附到画布中线（水平/垂直中线 + 三分线）
4. **铺满宽度** — 一键将图片宽度适配画布，高度自动等比计算
5. **旋转适配** — 旋转图片后自动以宽度铺满画布
6. **图片保存** — 编辑完成后渲染并保存到相册
