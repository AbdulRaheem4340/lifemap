import 'package:flutter/material.dart';

class DiagonalClipper extends CustomClipper<Path> {
  final double cutHeight;

  const DiagonalClipper({this.cutHeight = 40.0});

  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cutHeight);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant DiagonalClipper oldDelegate) {
    return oldDelegate.cutHeight != cutHeight;
  }
}

