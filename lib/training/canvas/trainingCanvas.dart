import 'package:flutter/material.dart';

class TrainingCanvas extends StatefulWidget {
  final String huruf;
  const TrainingCanvas({super.key, required this.huruf});

  @override
  _TrainingCanvasState createState() => _TrainingCanvasState();
}

class _TrainingCanvasState extends State<TrainingCanvas> {
  List<Offset?> _points = [];
  late double drawingTopBoundary;
  bool isDrawingComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Training Camp')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          drawingTopBoundary = constraints.maxHeight / 2;

          return Column(
            children: [
              // Top half to display the letter
              Expanded(
                child: Center(
                  child: Text(
                    widget.huruf,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.4,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              // Bottom half with border and drawing area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0),
                  ),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      final localPosition = details.localPosition;
                      if (_isWithinBounds(localPosition, constraints)) {
                        setState(() {
                          _points.add(localPosition);
                          _checkCompletion();
                        });
                      }
                    },
                    onPanEnd: (details) {
                      setState(() {
                        _points.add(null);
                      });
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(_points, widget.huruf),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _points.clear();
            isDrawingComplete = false;
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  // Ensure drawing stays inside the lower half of the screen
  bool _isWithinBounds(Offset position, BoxConstraints constraints) {
    return position.dy >= 0 &&
        position.dy <= constraints.maxHeight / 2 &&
        position.dx >= 0 &&
        position.dx <= constraints.maxWidth;
  }

  // Check if the drawing sufficiently covers the guide
  void _checkCompletion() {
    double coverageThreshold = 0.75; // Percentage of guide to be covered
    int matchingPoints = _points.where((point) {
      if (point == null) return false;
      return _isPointOnGuide(point);
    }).length;

    if (matchingPoints / _points.length > coverageThreshold) {
      setState(() {
        isDrawingComplete = true;
      });
      _showCongratulations();
    }
  }

  // Detect if the drawn point matches the guide area (simplified detection)
  bool _isPointOnGuide(Offset point) {
    double guideTolerance = 20.0;
    return (point.dx - 100).abs() < guideTolerance && (point.dy - 150).abs() < guideTolerance;
  }

  // Show a congratulations pop-up when the drawing is completed
  void _showCongratulations() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Congratulations!'),
        content: Text('You successfully traced the letter ${widget.huruf}!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final String huruf;

  DrawingPainter(this.points, this.huruf);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    // Draw user's strokes
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }

    // Draw guide letter softly in the background
    final guidePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final textPainter = TextPainter(
      text: TextSpan(
        text: huruf,
        style: TextStyle(
          fontSize: size.width * 0.5,
          fontWeight: FontWeight.bold,
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final offsetX = (size.width - textPainter.width) / 2;
    final offsetY = (size.height - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(offsetX, offsetY));

    // Drawing guide lines (A shape example)
    Path path = Path();
    if (huruf.toUpperCase() == 'A') {
      path.moveTo(size.width * 0.3, size.height * 0.8);
      path.lineTo(size.width * 0.5, size.height * 0.2);
      path.lineTo(size.width * 0.7, size.height * 0.8);
      path.moveTo(size.width * 0.4, size.height * 0.5);
      path.lineTo(size.width * 0.6, size.height * 0.5);
    }
    canvas.drawPath(path, guidePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
