import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/gallery/screens/gallery_screen.dart';

class WechatMomentApp extends StatelessWidget {
  const WechatMomentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '朋友圈图片编辑',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const GalleryScreen(),
    );
  }
}
