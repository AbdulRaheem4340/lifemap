import 'package:flutter/material.dart';

import '../../models/location_point.dart';

class MiniPathPainter extends CustomPainter {
  final List<LocationPoint> points;
  final Color pathColor;

  MiniPathPainter({required this.points, required this.pathColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final double latDelta = (maxLat - minLat) == 0 ? 0.0001 : (maxLat - minLat);
    final double lngDelta = (maxLng - minLng) == 0 ? 0.0001 : (maxLng - minLng);

    const double padding = 8.0;
    final double drawWidth = size.width - (padding * 2);
    final double drawHeight = size.height - (padding * 2);

    final Path path = Path();

    for (int i = 0; i < points.length; i++) {
      final p = points[i];

      final double normalizedX = (p.longitude - minLng) / lngDelta;
      final double normalizedY = 1.0 - ((p.latitude - minLat) / latDelta);

      final double x = padding + (normalizedX * drawWidth);
      final double y = padding + (normalizedY * drawHeight);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final Paint paint = Paint()
      ..color = pathColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MiniPathPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.pathColor != pathColor;
  }
}