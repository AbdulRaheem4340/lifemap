import 'dart:ui';

import 'package:flutter/material.dart';

class RouteLinePainter extends CustomPainter {
  final double progress;
  final Color pathColor;
  final Color dotColor;

  RouteLinePainter({
    required this.progress,
    required this.pathColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final Path fullPath = Path();
    fullPath.moveTo(size.width * 0.1, size.height * 0.85);

    fullPath.cubicTo(
      size.width * 0.4,
      size.height * 0.75,
      size.width * 0.1,
      size.height * 0.45,
      size.width * 0.5,
      size.height * 0.45,
    );
    fullPath.cubicTo(
      size.width * 0.85,
      size.height * 0.45,
      size.width * 0.6,
      size.height * 0.15,
      size.width * 0.9,
      size.height * 0.1,
    );

    final Paint linePaint = Paint()
      ..color = pathColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final PathMetrics pathMetrics = fullPath.computeMetrics();
    for (final PathMetric metric in pathMetrics) {
      final double extractLength = metric.length * progress;
      final Path extractPath = metric.extractPath(0.0, extractLength);
      canvas.drawPath(extractPath, linePaint);

      final List<double> dotFractions = [0.2, 0.5, 0.8];
      for (final double fraction in dotFractions) {
        if (progress >= fraction) {
          final Tangent? tangent = metric.getTangentForOffset(
            metric.length * fraction,
          );
          if (tangent != null) {
            canvas.drawCircle(
              tangent.position,
              8.0,
              Paint()..color = dotColor.withValues(alpha: 0.3),
            );
            canvas.drawCircle(tangent.position, 4.0, Paint()..color = dotColor);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant RouteLinePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pathColor != pathColor ||
        oldDelegate.dotColor != dotColor;
  }
}

