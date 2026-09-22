import 'package:flutter/material.dart';

class ProfileHeaderClipper extends CustomClipper<Path> {
  final double curveDepth;

  const ProfileHeaderClipper({this.curveDepth = 30.0});

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double w = size.width;
    final double h = size.height;

    path.lineTo(0, h - curveDepth);

    path.quadraticBezierTo(w / 2, h - (curveDepth * 2.2), w, h - curveDepth);

    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant ProfileHeaderClipper oldDelegate) {
    return oldDelegate.curveDepth != curveDepth;
  }
}

