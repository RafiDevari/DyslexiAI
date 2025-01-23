import 'package:flutter/material.dart';

class TrainingCanvas extends StatefulWidget {
  final String huruf;
  const TrainingCanvas({super.key, required this.huruf});

  @override
  _TrainingCanvasState createState() => _TrainingCanvasState();
}

class _TrainingCanvasState extends State<TrainingCanvas> {
  List<Offset?> _points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Camp'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _points.add(details.localPosition);
          });
        },
        onPanEnd: (details) {
          setState(() {
            _points.add(null);
          });
        },
        child: CustomPaint(
          painter: DrawingPainter(_points, widget.huruf),  // Pass huruf here
          size: Size.infinite,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _points.clear();
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final String huruf;  // Add huruf variable

  DrawingPainter(this.points, this.huruf);  // Modify constructor to accept huruf

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    // Display the letter (huruf) in the center of the canvas
    final textPainter = TextPainter(
      text: TextSpan(
        text: huruf,  // Using huruf passed from widget
        style: TextStyle(
          color: Colors.grey.withOpacity(0.5),
          fontSize: size.width * 0.5,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final offsetX = (size.width - textPainter.width) / 2;
    final offsetY = (size.height - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(offsetX, offsetY));

    // Draw the user's drawn points
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
