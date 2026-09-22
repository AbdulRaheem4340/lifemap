import 'dart:math';

import 'package:flutter/material.dart';

class SpeedGaugePainter extends CustomPainter {
  final double currentSpeed;
  final double maxSpeed;
  final Color trackColor;
  final Color gaugeColor;

  SpeedGaugePainter({
    required this.currentSpeed,
    required this.maxSpeed,
    required this.trackColor,
    required this.gaugeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height * 0.85);
    final double radius = size.width * 0.4;
    const double strokeWidth = 10.0;

    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      trackPaint,
    );

    final double safeMax = maxSpeed <= 0 ? 50.0 : maxSpeed;
    final double sweepFraction = (currentSpeed / safeMax).clamp(0.0, 1.0);
    final double sweepAngle = pi * sweepFraction;

    if (sweepAngle > 0) {
      final Paint gaugePaint = Paint()
        ..color = gaugeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        pi,
        sweepAngle,
        false,
        gaugePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SpeedGaugePainter oldDelegate) {
    return oldDelegate.currentSpeed != currentSpeed ||
        oldDelegate.maxSpeed != maxSpeed ||
        oldDelegate.gaugeColor != gaugeColor ||
        oldDelegate.trackColor != trackColor;
  }
}

