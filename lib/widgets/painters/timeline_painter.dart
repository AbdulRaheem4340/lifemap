import 'package:flutter/material.dart';

class JourneyTimelinePainter extends CustomPainter {
  final int itemCount;
  final Color lineColor;
  final Color startColor;
  final Color stopColor;
  final Color endColor;

  JourneyTimelinePainter({
    required this.itemCount,
    required this.lineColor,
    required this.startColor,
    required this.stopColor,
    required this.endColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (itemCount <= 0) return;

    final double x = 16.0;
    final double startY = 24.0;
    final double itemHeight = size.height / itemCount;

    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(x, startY),
      Offset(x, size.height - startY),
      linePaint,
    );

    for (int i = 0; i < itemCount; i++) {
      final double y = startY + (i * itemHeight);

      Color nodeColor = stopColor;
      if (i == 0) nodeColor = startColor;
      if (i == itemCount - 1) nodeColor = endColor;

      canvas.drawCircle(
        Offset(x, y),
        7.0,
        Paint()..color = nodeColor.withValues(alpha: 0.25),
      );

      canvas.drawCircle(Offset(x, y), 4.0, Paint()..color = nodeColor);
    }
  }

  @override
  bool shouldRepaint(covariant JourneyTimelinePainter oldDelegate) {
    return oldDelegate.itemCount != itemCount ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.startColor != startColor ||
        oldDelegate.stopColor != stopColor ||
        oldDelegate.endColor != endColor;
  }
}

