# 朋友圈图片编辑器 (WeChat Moment Image Editor)

基于 Flutter 开发的图片编辑 APP，支持从系统选择图片到 APP 内部图库，在指定分辨率画布上进行缩放、旋转、吸附对齐等编辑操作，编辑完成后可保存到相册。

## 项目情况

| 项目 | 说明 |
|------|------|
| 项目名称 | wechat\_moment\_img\_convert |
| 当前版本 | 1.0.0+1 |
| 目标平台 | Android / iOS |
| 开发状态 | 核心功能完成，API 构建通过 |

## 技术选型

| 领域 | 技术 | 版本 | 说明 |
|------|------|------|------|
| 框架 | Flutter | ^3.27.0 | Google 跨平台 UI 框架 |
| 语言 | Dart | ^3.6.0 | |
| 状态管理 | flutter\_riverpod | ^2.6.1 | Riverpod 声明式状态管理 |
| 图片选择 | image\_picker | ^1.1.2 | 系统图片选择器 |
| 图片处理 | image | ^4.5.2 | Dart 原生图片编解码与变换（含 EXIF 方向修正） |
| 图片保存 | image\_gallery\_saver\_plus | ^5.0.0 | 保存图片到相册 |
| 权限管理 | permission\_handler | ^11.3.1 | 跨平台权限请求 |
| 本地存储 | shared\_preferences | ^2.3.0 | 设置持久化 & 图片路径存储 |
| 路径管理 | path\_provider | ^2.1.5 | 获取应用文档目录 |
| 文件系统 | dart:io | - | 图片文件复制与管理 |
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
│   │   │   └── app_constants.dart   # 应用常量（画布默认 2259×4524）
│   │   └── theme/
│   │       └── app_theme.dart       # Material Design 3 主题
│   ├── features/
│   │   ├── gallery/
│   │   │   ├── screens/
│   │   │   │   └── gallery_screen.dart   # APP图库页（仅显示用户选择的图片）
│   │   │   └── widgets/
│   │   │       └── image_grid.dart       # 网格组件
│   │   ├── editor/
│   │   │   ├── models/
│   │   │   │   └── editor_state.dart     # 编辑状态模型（含 imageSize）
│   │   │   ├── providers/
│   │   │   │   └── editor_provider.dart  # 编辑器状态管理
│   │   │   ├── screens/
│   │   │   │   └── editor_screen.dart    # 编辑器页面
│   │   │   └── widgets/
│   │   │       ├── editor_canvas.dart    # 编辑画布（BoxFit.contain + InteractiveViewer）
│   │   │       ├── editor_toolbar.dart   # 底部工具栏
│   │   │       └── snap_guide.dart       # 吸附辅助线
│   │   ├── settings/
│   │   │   ├── providers/
│   │   │   │   └── settings_provider.dart # 设置状态管理
│   │   │   └── screens/
│   │   │       ├── settings_screen.dart   # 设置页面
│   │   │       └── about_screen.dart      # 关于介绍页
│   │   └── shell/
│   │       └── main_shell.dart            # 底部标签栏主壳
│   └── shared/
│       ├── services/
│       │   └── image_storage.dart         # 图片存储服务（复制到应用目录 + 路径持久化）
│       └── utils/
│           └── image_saver.dart           # 图片保存工具（含 EXIF 修正 + cubic 插值）
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

1. **底部标签栏** — 图库、设置两个 Tab，支持 Material 3 NavigationBar 导航
2. **APP 内部图库** — 仅显示用户通过系统选择器挑选的图片，长按可删除
3. **画布编辑** — 在可配置分辨率画布（默认 2259×4524）上自由缩放旋转图片，图片以 `BoxFit.contain` 适配画布
4. **吸附对齐** — 拖动图片时自动吸附到画布中线（水平/垂直中线 + 三分线），显示辅助线
5. **铺满宽度** — 一键将图片宽度适配画布，高度等比计算
6. **旋转适配** — 旋转图片后自动以宽度铺满画布
7. **图片保存** — 编辑完成后渲染并保存到相册，自动修正 EXIF 方向，cubic 插值保证画质，支持配置背景色
8. **个性化设置** — 可配置画布分辨率（默认 2259×4524）、画布背景色（默认黑色），设置持久化保存
9. **关于页面** — 展示应用简介和技术栈信息

## 架构说明

### 缩放模型

采用两层缩放模型确保显示与保存一致：

| 层级 | 说明 |
|------|------|
| `BoxFit.contain` | `Image.file` 的 fit 属性，图片按最大适配尺寸渲染在画布框内 |
| `InteractiveViewer` (`userScale=1.0`) | 初始无额外缩放，用户可手势捏合改变 `userScale` |

保存时有效缩放率 = `containScale * userScale`，其中 `containScale = min(canvasW/imgW, canvasH/imgH)`。

### 图片存储

用户通过 `image_picker` 选择的图片会被复制到应用文档目录 (`getApplicationDocumentsDirectory()`)，路径持久化到 `SharedPreferences`。图库页面仅显示这些用户显式选择的图片。
