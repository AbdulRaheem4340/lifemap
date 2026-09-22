import 'package:flutter/material.dart';

class DottedPathPainter extends CustomPainter {
  final int totalSteps;
  final double
  currentStep;
  final Color activeColor;
  final Color inactiveColor;

  DottedPathPainter({
    required this.totalSteps,
    required this.currentStep,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double spacing = size.width / (totalSteps - 1);
    final double centerY = size.height / 2;

    final Paint linePaint = Paint()
      ..color = inactiveColor.withValues(alpha: 0.3)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), linePaint);

    final double activeWidth = (size.width / (totalSteps - 1)) * currentStep;
    final Paint activeLinePaint = Paint()
      ..color = activeColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, centerY),
      Offset(activeWidth, centerY),
      activeLinePaint,
    );

    for (int i = 0; i < totalSteps; i++) {
      final double x = i * spacing;
      final bool isActive = i <= currentStep.round();

      if (i == currentStep.round()) {
        canvas.drawCircle(
          Offset(x, centerY),
          8.0,
          Paint()..color = activeColor.withValues(alpha: 0.25),
        );
      }

      canvas.drawCircle(
        Offset(x, centerY),
        4.0,
        Paint()..color = isActive ? activeColor : inactiveColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DottedPathPainter oldDelegate) {
    return oldDelegate.currentStep != currentStep ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}

