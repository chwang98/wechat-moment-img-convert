import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import 'about_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 画布设置
          const _SectionHeader(title: '画布设置'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: '画布宽度',
                            hintText: '2259',
                            suffixText: 'px',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                            text: settings.canvasWidth.toString(),
                          ),
                          onSubmitted: (value) {
                            final w = int.tryParse(value);
                            if (w != null) {
                              notifier.setCanvasWidth(w);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: '画布高度',
                            hintText: '4524',
                            suffixText: 'px',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                            text: settings.canvasHeight.toString(),
                          ),
                          onSubmitted: (value) {
                            final h = int.tryParse(value);
                            if (h != null) {
                              notifier.setCanvasHeight(h);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 背景色
                  Row(
                    children: [
                      const Text('画布背景色'),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showColorPicker(context, ref),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: settings.canvasBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 关于
          const _SectionHeader(title: '其他'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('关于'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AboutScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('选择背景色'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _colorOption(ctx, ref, Colors.white, '白色', settings),
                _colorOption(ctx, ref, Colors.black, '黑色', settings),
                _colorOption(ctx, ref, const Color(0xFFE8F5E9), '浅绿', settings),
                _colorOption(
                    ctx, ref, const Color(0xFFFFF3E0), '浅橙', settings),
                _colorOption(
                    ctx, ref, const Color(0xFFE3F2FD), '浅蓝', settings),
                _colorOption(
                    ctx, ref, const Color(0xFFFCE4EC), '浅粉', settings),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _colorOption(
    BuildContext ctx,
    WidgetRef ref,
    Color color,
    String label,
    SettingsState settings,
  ) {
    final isSelected = settings.canvasBackgroundColor.toARGB32() == color.toARGB32();

    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
      title: Text(label),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        ref.read(settingsProvider.notifier).setCanvasBackgroundColor(color);
        Navigator.of(ctx).pop();
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
