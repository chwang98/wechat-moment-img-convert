# 开发进度文档

## 进度总览

| 阶段 | 状态 | 完成日期 |
|------|------|----------|
| 项目初始化 & 框架搭建 | ✅ 已完成 | 2026-06-24 |
| 相册浏览功能 | ✅ 已完成 | 2026-06-24 |
| 编辑画布 & 变换功能 | ✅ 已完成 | 2026-06-24 |
| 吸附对齐功能 | ✅ 已完成 | 2026-06-24 |
| 铺满宽度 & 旋转功能 | ✅ 已完成 | 2026-06-24 |
| 图片保存功能 | ✅ 已完成 | 2026-06-24 |
| 底部标签栏 & 设置页面 | ✅ 已完成 | 2026-06-25 |
| 修复已知问题 (v1) | ✅ 已完成 | 2026-06-25 |
| 关于页面 & 文档维护 | ✅ 已完成 | 2026-06-25 |
| APP 内部图库重构 | ✅ 已完成 | 2026-06-25 |
| 保存进度 & 比例修复 | ✅ 已完成 | 2026-06-25 |
| 二层缩放模型重构 | ✅ 已完成 | 2026-06-25 |
| EXIF 方向修正 & 画质优化 | ✅ 已完成 | 2026-06-25 |
| 画布分辨率更新为 2259×4524 | ✅ 已完成 | 2026-06-25 |
| 文档同步更新 | ✅ 已完成 | 2026-06-25 |
| 真实设备测试 | ⏳ 待开始 | - |
| 性能优化 | ⏳ 待开始 | - |
| UI/UX 打磨 | ⏳ 待开始 | - |

---

## 阶段 1: 项目初始化 & 框架搭建

**状态**: ✅ 已完成  
**日期**: 2026-06-24

### 完成事项
- [x] 创建 Flutter 项目结构
- [x] 配置 `pubspec.yaml` 依赖
- [x] 配置 `analysis_options.yaml` 代码规范
- [x] 搭建目录结构（core / features / shared）
- [x] 配置 Material Design 3 主题（亮色 & 暗色）
- [x] 定义应用常量（画布分辨率、吸附阈值等）
- [x] 创建 `doc/README.md` 项目文档

### 技术决策
- **状态管理**: Riverpod — 声明式、类型安全、支持 family 模式（按 imagePath 区分的 editorProvider）
- **图片处理**: image 包 — Dart 原生图片编解码，无需原生桥接
- **UI 风格**: Material Design 3 — 使用 `ColorScheme.fromSeed` 和 `useMaterial3: true`

---

## 阶段 2: 相册浏览功能

**状态**: ✅ 已完成  
**日期**: 2026-06-24

### 完成事项
- [x] `GalleryScreen` — 相册浏览页面
- [x] `ImageGrid` — 网格展示缩略图
- [x] 权限请求流程
- [x] 点击图片跳转编辑页面

### 相关文件
- `lib/features/gallery/screens/gallery_screen.dart`
- `lib/features/gallery/widgets/image_grid.dart`

---

## 阶段 3: 编辑画布 & 变换功能

**状态**: ✅ 已完成  
**日期**: 2026-06-24

### 完成事项
- [x] `EditorScreen` — 编辑页面，含 AppBar 和底部工具栏
- [x] `EditorCanvas` — 画布，使用 `InteractiveViewer` 支持缩放/拖拽
- [x] `EditorState` — 编辑状态模型
- [x] `EditorNotifier` — 状态管理器
- [x] `EditorToolbar` — 底部工具栏（铺满宽度 / 旋转90°）
- [x] 画布自适应屏幕宽度显示

### 相关文件
- `lib/features/editor/screens/editor_screen.dart`
- `lib/features/editor/models/editor_state.dart`
- `lib/features/editor/providers/editor_provider.dart`
- `lib/features/editor/widgets/editor_canvas.dart`
- `lib/features/editor/widgets/editor_toolbar.dart`

---

## 阶段 4: 吸附对齐功能

**状态**: ✅ 已完成  
**日期**: 2026-06-24

### 完成事项
- [x] `SnapGuide` — 辅助线绘制组件（水平中线 / 垂直中线 / 三分线）
- [x] 吸附逻辑 — 拖动时检测与中线的距离，阈值内自动吸附
- [x] 拖动时显示辅助线，松手后隐藏

### 相关文件
- `lib/features/editor/widgets/snap_guide.dart`
- `lib/features/editor/providers/editor_provider.dart`

---

## 阶段 5: 铺满宽度 & 旋转功能

**状态**: ✅ 已完成  
**日期**: 2026-06-24

### 完成事项
- [x] `fitToWidth()` — 计算缩放比例使图片宽度铺满画布宽度
- [x] `rotateAndFitToWidth()` — 旋转 90° 后重新以宽度铺满
- [x] 工具栏按钮绑定

---

## 阶段 6: 图片保存功能

**状态**: ✅ 已完成  
**日期**: 2026-06-24

### 完成事项
- [x] `ImageSaver` — 图片保存工具类
- [x] 使用 `image_gallery_saver_plus` 保存到系统相册
- [x] 保存成功/失败 SnackBar 提示

### 相关文件
- `lib/shared/utils/image_saver.dart`

---

## 阶段 7: 底部标签栏 & 设置页面

**状态**: ✅ 已完成  
**日期**: 2026-06-25

### 完成事项
- [x] `MainShell` — 底部标签栏主壳（Material 3 NavigationBar）
- [x] `SettingsScreen` — 设置页面（画布宽高、背景色、关于入口）
- [x] `SettingsProvider` — 设置状态管理 + SharedPreferences 持久化

### 相关文件
- `lib/features/shell/main_shell.dart`
- `lib/features/settings/screens/settings_screen.dart`
- `lib/features/settings/providers/settings_provider.dart`

---

## 阶段 8: 修复已知问题 (v1)

**状态**: ✅ 已完成  
**日期**: 2026-06-25

### 修复事项

**8.1 图库图片二次打开不显示**
- 改用缩略图加载，点击编辑时才获取文件路径

**8.2 无法保存图片**
- `EditorScreen` AppBar 新增保存按钮
- `ImageSaver` 支持可配置画布背景色

**8.3 手势缩放异常 & 网格线**
- 移除 `EditorCanvas` 外层 `GestureDetector`
- 改用 `InteractiveViewer.onInteractionStart/End` 控制辅助线

---

## 阶段 9: 关于页面 & 文档维护

**状态**: ✅ 已完成  
**日期**: 2026-06-25

### 完成事项
- [x] `AboutScreen` — 关于介绍页（应用简介 + 技术栈）
- [x] `EditorState` 新增 `canvasBackgroundColor` 字段，联动设置
- [x] `EditorNotifier` 从 `SettingsProvider` 读取 canvasSize 和背景色

### 相关文件
- `lib/features/settings/screens/about_screen.dart`

---

## 阶段 10: APP 内部图库重构

**状态**: ✅ 已完成  
**日期**: 2026-06-25

### 完成事项
- [x] 移除 `photo_manager` 全局图片扫描，改为仅显示用户显式选择的图片
- [x] 新增 `ImageStorage` — 图片存储服务
  - 将选中图片复制到应用文档目录
  - 路径持久化到 SharedPreferences
- [x] `GalleryScreen` — 使用 `image_picker` 选择图片，FAB 添加按钮，长按删除
- [x] `AndroidManifest.xml` — 添加必要权限

### 相关文件
- `lib/shared/services/image_storage.dart`
- `lib/features/gallery/screens/gallery_screen.dart`

---

## 阶段 11: 保存进度 & 比例修复

**状态**: ✅ 已完成  
**日期**: 2026-06-25

### 修复事项

**11.1 保存进度提示**
- `EditorScreen._onSave()` — 保存前弹出 `CircularProgressIndicator` 对话框，防止 UI 卡死的假象
- `ImageSaver` — 加 100ms 延迟确保对话框先渲染

**11.2 保存图片比例拉伸**
- `EditorCanvas` — 手势缩放实时同步到 EditorState
- `EditorProvider` — 新增 `syncScaleFromViewer()` 方法

**11.3 画布背景默认黑色**
- `SettingsState` 和 `EditorState` 默认背景色改为 `Colors.black`

---

## 阶段 12: 二层缩放模型重构

**状态**: ✅ 已完成  
**日期**: 2026-06-25

### 变更说明
将原有单层缩放模型重构为二层模型，解决图片显示与保存不一致的问题：

| 层级 | 说明 |
|------|------|
| `BoxFit.contain` | `Image.file` fit 属性，图片自动适配画布框内最大化显示 |
| `InteractiveViewer` (`userScale=1.0`) | 初始无额外缩放，用户可手势捏合改变 `userScale` |

### 涉及变更
- `EditorState` — 新增 `imageSize` 字段，`scale` 更名为 `userScale`
- `EditorProvider` — `fitToWidth()` 基于 contain 倍率计算填满宽度所需倍率
- `EditorCanvas` — `Image.file` 使用 `BoxFit.contain`，`ref.listen` 监听工具栏触发的 `userScale` 变化
- `ImageSaver` — 保存时计算 `effectiveScale = containScale * userScale`

### 相关文件
- `lib/features/editor/models/editor_state.dart`
- `lib/features/editor/providers/editor_provider.dart`
- `lib/features/editor/widgets/editor_canvas.dart`
- `lib/features/editor/screens/editor_screen.dart`
- `lib/shared/utils/image_saver.dart`

---

## 阶段 13: EXIF 方向修正 & 画质优化

**状态**: ✅ 已完成  
**日期**: 2026-06-25

### 修复事项

**13.1 保存图片倾斜**
- 根因：`img.decodeImage()` 不处理 EXIF 方向（手机照片通常有 90° 旋转标记），而 Flutter `Image.file` 会处理
- 修复：解码后调用 `img.bakeOrientation()` 应用 EXIF 方向修正

**13.2 保存图片画质差**
- 根因：`img.copyResize` 默认使用 `Interpolation.nearest`（最近邻插值）
- 修复：改为 `Interpolation.cubic`（三次立方插值）

### 相关文件
- `lib/shared/utils/image_saver.dart`

---

## 阶段 14: 画布分辨率更新

**状态**: ✅ 已完成  
**日期**: 2026-06-25

### 变更
- 默认画布分辨率从 1080×1920 更新为 2259×4524
- 涉及文件：`app_constants.dart`、`editor_state.dart`、`settings_provider.dart`（默认值 + 持久化回退值）、`settings_screen.dart`（hintText）

---

## 阶段 15: 文档同步更新

**状态**: ✅ 已完成  
**日期**: 2026-06-25

- [x] 更新 `doc/README.md` — 项目描述、技术选型、目录树、功能概览、架构说明
- [x] 更新 `doc/development-progress.md` — 记录所有阶段的开发和修复

---

## 待开发

### 阶段 16: 真实设备测试
- [ ] Android 设备测试
- [ ] iOS 设备测试
- [ ] 权限流程验证
- [ ] 图片保存功能验证
- [ ] 不同分辨率手机适配

### 阶段 17: 性能优化
- [ ] 大图片加载优化（按需解码）
- [ ] 保存图片时的内存管理
- [ ] 画廊图片缓存
- [ ] 构建产物体积优化

### 阶段 18: UI/UX 打磨
- [ ] 编辑历史撤销/重做
- [ ] 加载动画优化
- [ ] 空状态插图
- [ ] 暗色模式画布适配

---

## 变更记录

| 日期 | 变更内容 |
|------|----------|
| 2026-06-24 | 项目初始化，完成框架搭建和核心功能开发 |
| 2026-06-25 | 新增底部标签栏、设置页面、关于页面；修复手势冲突、图片持久化、保存功能 |
| 2026-06-25 | APP 内部图库重构（image_picker + ImageStorage）；保存进度弹窗 |
| 2026-06-25 | 二层缩放模型重构（BoxFit.contain + InteractiveViewer） |
| 2026-06-25 | EXIF 方向修正 + cubic 插值画质优化 |
| 2026-06-25 | 画布分辨率 1080×1920 → 2259×4524；文档同步更新 |
