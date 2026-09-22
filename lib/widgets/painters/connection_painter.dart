import 'package:flutter/material.dart';

class ConnectionPainter extends CustomPainter {
  final Color lineColor;
  final int nodeCount;

  ConnectionPainter({required this.lineColor, required this.nodeCount});

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCount < 2) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final dy = size.height / (nodeCount + 1);
    final leftX = size.width * 0.08;
    final rightX = size.width * 0.92;

    for (int i = 0; i < nodeCount; i++) {
      final y = dy * (i + 1);
      final path = Path()
        ..moveTo(leftX, y)
        ..cubicTo(
          size.width * 0.35,
          y - 12,
          size.width * 0.65,
          y + 12,
          rightX,
          y,
        );
      canvas.drawPath(path, paint);
      canvas.drawCircle(Offset(leftX, y), 3, Paint()..color = lineColor);
      canvas.drawCircle(Offset(rightX, y), 3, Paint()..color = lineColor);
    }
  }

  @override
  bool shouldRepaint(covariant ConnectionPainter oldDelegate) {
    return oldDelegate.nodeCount != nodeCount ||
        oldDelegate.lineColor != lineColor;
  }
}

