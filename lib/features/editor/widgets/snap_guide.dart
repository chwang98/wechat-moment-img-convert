import 'package:flutter/material.dart';

class SnapGuide extends StatelessWidget {
  final Size canvasSize;

  const SnapGuide({super.key, required this.canvasSize});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withAlpha(128);

    return IgnorePointer(
      child: CustomPaint(
        size: canvasSize,
        painter: _SnapGuidePainter(color: color),
      ),
    );
  }
}

class _SnapGuidePainter extends CustomPainter {
  final Color color;

  _SnapGuidePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final dashPaint = Paint()
      ..color = color.withAlpha(80)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // 水平中线
    final centerY = size.height / 2;
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), dashPaint);

    // 垂直中线
    final centerX = size.width / 2;
    canvas.drawLine(Offset(centerX, 0), Offset(centerX, size.height), dashPaint);

    // 三分线
    final thirdY1 = size.height / 3;
    final thirdY2 = size.height * 2 / 3;
    canvas.drawLine(
        Offset(0, thirdY1), Offset(size.width, thirdY1), dashPaint);
    canvas.drawLine(
        Offset(0, thirdY2), Offset(size.width, thirdY2), dashPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
