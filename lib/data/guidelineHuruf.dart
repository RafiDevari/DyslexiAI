// letter_paths.dart
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

Path generateLetterPath(String huruf) {
  Path path = Path();

  switch (huruf.toUpperCase()) {
    case 'A':
      path.moveTo(100, 250);
      path.lineTo(200, 50);
      path.lineTo(300, 250);
      path.moveTo(150, 150);
      path.lineTo(250, 150);
      break;

    case 'B':
      path.moveTo(100, 100);
      path.lineTo(100, 350);
      path.moveTo(100, 100);
      path.arcToPoint(Offset(100, 200), radius: Radius.circular(50), clockwise: true);
      path.moveTo(100, 200);
      path.arcToPoint(Offset(100, 350), radius: Radius.circular(50), clockwise: true);
      break;

    case 'C':
      path.moveTo(150, 100);
      path.arcToPoint(Offset(150, 300), radius: Radius.circular(45), clockwise: false);
      break;

    case 'D':
      path.moveTo(100, 50);
      path.lineTo(100, 350);
      path.arcToPoint(Offset(100, 50), radius: Radius.circular(150), clockwise: false);
      break;

    case 'E':
      path.moveTo(250, 50);
      path.lineTo(100, 50);
      path.lineTo(100, 350);
      path.lineTo(250, 350);
      path.moveTo(100, 200);
      path.lineTo(200, 200);
      break;

    case 'F':
      path.moveTo(100, 50);
      path.lineTo(100, 350);
      path.moveTo(100, 50);
      path.lineTo(250, 50);
      path.moveTo(100, 200);
      path.lineTo(200, 200);
      break;

    case 'G':
      path.moveTo(250, 100);
      path.arcToPoint(Offset(150, 300), radius: Radius.circular(150), clockwise: false);
      path.lineTo(250, 300);
      break;

    case 'H':
      path.moveTo(100, 50);
      path.lineTo(100, 350);
      path.moveTo(300, 50);
      path.lineTo(300, 350);
      path.moveTo(100, 200);
      path.lineTo(300, 200);
      break;

    case 'I':
      path.moveTo(150, 50);
      path.lineTo(250, 50);
      path.moveTo(200, 50);
      path.lineTo(200, 350);
      path.moveTo(150, 350);
      path.lineTo(250, 350);
      break;

    case 'J':
      path.moveTo(250, 50);
      path.lineTo(250, 300);
      path.arcToPoint(Offset(150, 300), radius: Radius.circular(100), clockwise: true);
      break;

    case 'K':
      path.moveTo(100, 50);
      path.lineTo(100, 350);
      path.moveTo(100, 200);
      path.lineTo(300, 50);
      path.moveTo(100, 200);
      path.lineTo(300, 350);
      break;

    case 'L':
      path.moveTo(100, 50);
      path.lineTo(100, 350);
      path.lineTo(250, 350);
      break;

    case 'M':
      path.moveTo(100, 350);
      path.lineTo(100, 50);
      path.lineTo(200, 150);
      path.lineTo(300, 50);
      path.lineTo(300, 350);
      break;

    case 'N':
      path.moveTo(100, 350);
      path.lineTo(100, 50);
      path.lineTo(300, 350);
      path.lineTo(300, 50);
      break;

    case 'O':
      path.addOval(Rect.fromCircle(center: Offset(200, 200), radius: 100));
      break;

    case 'P':
      path.moveTo(100, 50);
      path.lineTo(100, 350);
      path.lineTo(250, 50);
      path.arcToPoint(Offset(100, 200), radius: Radius.circular(50), clockwise: true);
      break;

    case 'Q':
      path.addOval(Rect.fromCircle(center: Offset(200, 200), radius: 100));
      path.moveTo(250, 250);
      path.lineTo(300, 350);
      break;

    case 'R':
      path.moveTo(100, 50);
      path.lineTo(100, 350);
      path.arcToPoint(Offset(100, 200), radius: Radius.circular(50), clockwise: true);
      path.moveTo(100, 200);
      path.lineTo(250, 350);
      break;

    case 'S':
      path.moveTo(250, 50);
      path.arcToPoint(Offset(150, 200), radius: Radius.circular(100), clockwise: false);
      path.arcToPoint(Offset(250, 350), radius: Radius.circular(100), clockwise: true);
      break;

    case 'T':
      path.moveTo(150, 50);
      path.lineTo(250, 50);
      path.moveTo(200, 50);
      path.lineTo(200, 350);
      break;

    case 'U':
      path.moveTo(100, 50);
      path.lineTo(100, 250);
      path.arcToPoint(Offset(300, 250), radius: Radius.circular(100), clockwise: true);
      path.lineTo(300, 50);
      break;

    case 'V':
      path.moveTo(100, 50);
      path.lineTo(200, 350);
      path.lineTo(300, 50);
      break;

    case 'W':
      path.moveTo(100, 50);
      path.lineTo(150, 350);
      path.lineTo(200, 200);
      path.lineTo(250, 350);
      path.lineTo(300, 50);
      break;

    case 'X':
      path.moveTo(100, 50);
      path.lineTo(300, 350);
      path.moveTo(300, 50);
      path.lineTo(100, 350);
      break;

    case 'Y':
      path.moveTo(100, 50);
      path.lineTo(200, 200);
      path.lineTo(300, 50);
      path.moveTo(200, 200);
      path.lineTo(200, 350);
      break;

    case 'Z':
      path.moveTo(100, 50);
      path.lineTo(300, 50);
      path.lineTo(100, 350);
      path.lineTo(300, 350);
      break;

    default:
      throw ArgumentError("Letter not supported");
  }
  return path;
}
