import 'package:flutter/material.dart';

class CurvedSheetClipper extends CustomClipper<Path> {
  final double curveHeight;

  const CurvedSheetClipper({this.curveHeight = 20.0});

  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.moveTo(0, curveHeight);

    path.quadraticBezierTo(size.width / 2, 0, size.width, curveHeight);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CurvedSheetClipper oldDelegate) {
    return oldDelegate.curveHeight != curveHeight;
  }
}

