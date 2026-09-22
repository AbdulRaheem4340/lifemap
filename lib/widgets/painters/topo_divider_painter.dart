import 'package:flutter/material.dart';

class TopoDividerPainter extends CustomPainter {
  final Color lineColor;

  TopoDividerPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double w = size.width;
    final double h = size.height / 2;

    final Path path = Path();
    path.moveTo(0, h);
    path.cubicTo(w * 0.25, h - 3, w * 0.75, h + 3, w, h);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TopoDividerPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor;
  }
}