import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  final double ridgeShift;

  final double peakDrift;

  const WaveClipper({
    this.ridgeShift = 0.0,
    this.peakDrift = 0.0,
  });

  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double s = ridgeShift;
    final double d = peakDrift;

    final Path path = Path();

    path.moveTo(0, 0);

    path.lineTo(0, h * (0.70 + s));

    path.cubicTo(
      w * 0.14, h * (0.80 + s),
      w * 0.30, h * (0.93 + s),
      w * 0.46, h * (0.88 + s),
    );

    path.cubicTo(
      w * (0.60 + d), h * (0.84 + s),
      w * (0.66 + d), h * (0.60 + s),
      w * (0.80 + d), h * (0.58 + s),
    );

    path.cubicTo(
      w * 0.88, h * (0.57 + s),
      w * 0.94, h * (0.66 + s),
      w, h * (0.63 + s),
    );

    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant WaveClipper oldDelegate) {
    return oldDelegate.ridgeShift != ridgeShift ||
        oldDelegate.peakDrift != peakDrift;
  }
}

class MapFoldClipper extends CustomClipper<Path> {
  final double foldShift;

  const MapFoldClipper({this.foldShift = 0.0});

  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double s = foldShift;

    final Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, h * (0.76 + s));

    path.lineTo(w * 0.22, h * (0.66 + s));
    path.lineTo(w * 0.42, h * (0.87 + s));
    path.lineTo(w * 0.68, h * (0.69 + s));
    path.lineTo(w * 0.86, h * (0.83 + s));
    path.lineTo(w, h * (0.71 + s));

    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant MapFoldClipper oldDelegate) {
    return oldDelegate.foldShift != foldShift;
  }
}