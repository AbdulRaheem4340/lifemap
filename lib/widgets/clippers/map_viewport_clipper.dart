import 'package:flutter/material.dart';

class MapViewportClipper extends CustomClipper<Path> {
  final double bottomRadius;

  const MapViewportClipper({this.bottomRadius = 32.0});

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double w = size.width;
    final double h = size.height;

    path.lineTo(0, h - bottomRadius);
    path.quadraticBezierTo(0, h, bottomRadius, h);
    path.lineTo(w, h);
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant MapViewportClipper oldDelegate) {
    return oldDelegate.bottomRadius != bottomRadius;
  }
}

