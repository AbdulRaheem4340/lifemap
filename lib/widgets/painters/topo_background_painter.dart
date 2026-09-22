import 'package:flutter/material.dart';

class TopoBackgroundPainter extends CustomPainter {
  final Color lineColor;

  TopoBackgroundPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final double w = size.width;
    final double h = size.height;

    final Path path1 = Path()
      ..moveTo(w * 0.4, 0)
      ..cubicTo(w * 0.5, h * 0.08, w * 0.8, h * 0.05, w, h * 0.15);
    canvas.drawPath(path1, paint);

    final Path path2 = Path()
      ..moveTo(0, h * 0.35)
      ..cubicTo(w * 0.3, h * 0.30, w * 0.4, h * 0.45, w * 0.8, h * 0.38)
      ..cubicTo(w * 0.9, h * 0.36, w * 0.95, h * 0.40, w, h * 0.42);
    canvas.drawPath(paintPathDashed(path2), paint);

    final Path path3 = Path()
      ..moveTo(0, h * 0.65)
      ..cubicTo(w * 0.25, h * 0.60, w * 0.5, h * 0.72, w * 0.85, h * 0.68)
      ..cubicTo(w * 0.95, h * 0.67, w, h * 0.70, w, h * 0.72);
    canvas.drawPath(path3, paint);

    final Path path4 = Path()
      ..moveTo(0, h * 0.85)
      ..cubicTo(w * 0.2, h * 0.82, w * 0.4, h * 0.92, w * 0.6, h * 1.0);
    canvas.drawPath(path4, paint);
  }

  Path paintPathDashed(Path source) {
    final Path dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = draw ? 8.0 : 6.0;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant TopoBackgroundPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor;
  }
}

