import 'package:flutter/material.dart';

class NotchClipper extends CustomClipper<Path> {
  final double notchRadius;

  const NotchClipper({this.notchRadius = 40.0});

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double centerX = size.width / 2;
    final double r = notchRadius;

    path.moveTo(0, 0);
    path.lineTo(0, size.height);

    path.lineTo(centerX - r * 1.5, size.height);

    path.cubicTo(
      centerX - r * 0.8,
      size.height,
      centerX - r,
      size.height - r,
      centerX,
      size.height - r,
    );

    path.cubicTo(
      centerX + r,
      size.height - r,
      centerX + r * 0.8,
      size.height,
      centerX + r * 1.5,
      size.height,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant NotchClipper oldDelegate) {
    return oldDelegate.notchRadius != notchRadius;
  }
}

