import 'package:flutter/material.dart';

class HeatmapPainter extends CustomPainter {
  final List<List<double>> values;
  final Color baseColor;
  final Color emptyColor;
  final List<String> dayLabels;

  HeatmapPainter({
    required this.values,
    required this.baseColor,
    required this.emptyColor,
    this.dayLabels = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    const double leftLabelW = 18;
    const double topLabelH = 16;
    const double gap = 2;

    final int rows = values.length;
    final int cols = values.first.length;

    final double gridW = size.width - leftLabelW;
    final double gridH = size.height - topLabelH;
    final double cellW = (gridW - gap * (cols - 1)) / cols;
    final double cellH = (gridH - gap * (rows - 1)) / rows;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int h = 0; h < cols; h += 6) {
      textPainter.text = TextSpan(
        text: '$h',
        style: TextStyle(
          color: emptyColor.withValues(alpha: 0.9),
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(leftLabelW + h * (cellW + gap), 0));
    }

    for (int d = 0; d < rows; d++) {
      if (d < dayLabels.length) {
        textPainter.text = TextSpan(
          text: dayLabels[d],
          style: TextStyle(
            color: emptyColor.withValues(alpha: 0.9),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            0,
            topLabelH + d * (cellH + gap) + (cellH - textPainter.height) / 2,
          ),
        );
      }

      for (int h = 0; h < cols; h++) {
        final double v = values[d][h].clamp(0.0, 1.0);
        final Color fill = v <= 0
            ? emptyColor.withValues(alpha: 0.12)
            : baseColor.withValues(alpha: 0.15 + v * 0.85);

        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            leftLabelW + h * (cellW + gap),
            topLabelH + d * (cellH + gap),
            cellW,
            cellH,
          ),
          const Radius.circular(2),
        );
        canvas.drawRRect(rect, Paint()..color = fill);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HeatmapPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.baseColor != baseColor;
  }
}

