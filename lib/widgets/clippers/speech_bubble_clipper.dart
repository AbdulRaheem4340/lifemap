import 'package:flutter/material.dart';

class SpeechBubbleClipper extends CustomClipper<Path> {
  final double radius;
  final double tailWidth;
  final double tailHeight;

  const SpeechBubbleClipper({
    this.radius = 16,
    this.tailWidth = 18,
    this.tailHeight = 12,
  });

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final r = radius;
    final tw = tailWidth;
    final th = tailHeight;

    final path = Path();

    path.moveTo(r, th);

    path.lineTo(w / 2 - tw / 2, th);
    path.lineTo(w / 2, 0);
    path.lineTo(w / 2 + tw / 2, th);

    path.lineTo(w - r, th);
    path.quadraticBezierTo(w, th, w, th + r);

    path.lineTo(w, h - r);
    path.quadraticBezierTo(w, h, w - r, h);
    path.lineTo(r, h);
    path.quadraticBezierTo(0, h, 0, h - r);
    path.lineTo(0, th + r);
    path.quadraticBezierTo(0, th, r, th);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant SpeechBubbleClipper oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.tailWidth != tailWidth ||
        oldDelegate.tailHeight != tailHeight;
  }
}