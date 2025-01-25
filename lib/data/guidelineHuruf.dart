// letter_paths.dart
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

Path generateLetterPath(String huruf) {
  Path path = Path();

  switch (huruf.toUpperCase()) {
    case 'A':
    // Letter "A"
      path.moveTo(100, 250);
      path.lineTo(200, 50);
      path.lineTo(300, 250);
      path.moveTo(150, 150);
      path.lineTo(250, 150);
      break;

    case 'B':
    // Letter "B"
      path.moveTo(100, 50);
      path.lineTo(100, 350);
      path.moveTo(100, 100);
      path.cubicTo(150, 50, 200, 50, 200, 100);
      path.moveTo(100, 250);
      path.cubicTo(150, 200, 200, 200, 200, 250);
      break;

    case 'S':
    // Letter "C" (Example of letter C)
      path.moveTo(200, 50);
      path.arcToPoint(Offset(100, 250), radius: Radius.circular(150), clockwise: false);
      break;

  // Add more cases for other letters here...

    default:
      throw ArgumentError("Letter not supported");
  }

  return path;
}
