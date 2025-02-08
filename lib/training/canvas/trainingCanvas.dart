import 'package:dyslexiai/data/guidelineHuruf.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_tts/flutter_tts.dart';


class TrainingCanvas extends StatefulWidget {
  final String huruf;
  const TrainingCanvas({super.key, required this.huruf});

  @override
  _TrainingCanvasState createState() => _TrainingCanvasState();
}

class _TrainingCanvasState extends State<TrainingCanvas> {
  List<Offset?> _points = [];
  late Path _guidePath;
  bool isDrawingComplete = false;
  final FlutterTts flutterTts = FlutterTts();
  late double completionPercentage=0.0;


  @override
  void initState() {
    super.initState();
    _guidePath = generateLetterPath(widget.huruf);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Training Camp')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                children: [
                  GestureDetector(
                    onTap: () {
                      speakCorrectWord();
                    },
                    child: Text(
                      widget.huruf,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.4,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Text("Completion: ${completionPercentage.toStringAsFixed(1)}%"),
                ],
              ),
            ),


          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  final localPosition = details.localPosition;
                  if (_isWithinBounds(localPosition)) {
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
                  painter: DrawingPainter(_points, _guidePath),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ],
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
  bool _isWithinBounds(Offset position) {
    return position.dy >= 0 &&
        position.dy <= 500 &&  // Assuming bottom half height
        position.dx >= 0 &&
        position.dx <= 400; // Assuming screen width
  }

  // Generate guide path for letter A (You can modify this for other letters)
  // Path _generateGuidePath() {
  //   Path path = Path();
  //   path.moveTo(100, 250);
  //   path.lineTo(200, 50);
  //   path.lineTo(300, 250);
  //   path.moveTo(150, 150);
  //   path.lineTo(250, 150);
  //   return path;
  // }

  // Check if the drawing sufficiently covers the guide path
  void _checkCompletion() {
    // Count how many guide path points are covered by the user's drawing
    int coveredPoints = 0;
    int totalGuidePoints = 0;
    Set<Offset> checkedPoints = Set(); // To track already checked points for optimization

    // Ensure the user has drawn a sufficient number of points
    if (_points.length < 20) {
      print("Not enough points drawn yet.");
      return; // Don't check completion if the user hasn't drawn enough
    }

    // Iterate over the guide path to get the points and check if the drawn points are near
    for (ui.PathMetric metric in _guidePath.computeMetrics()) {
      for (double i = 0.0; i < metric.length; i += 10.0) {
        Offset guidePoint = metric.getTangentForOffset(i)!.position;
        totalGuidePoints++;

        // Only check if the point hasn't been checked yet
        if (!checkedPoints.contains(guidePoint)) {
          checkedPoints.add(guidePoint);

          // Check if any of the drawn points are close enough to the guide point
          for (Offset? point in _points) {
            if (point != null && (point - guidePoint).distance < 7.5) { // 20 pixels threshold
              coveredPoints++;
              break; // No need to check more points for this guide point
            }
          }
        }
      }
    }

    // Calculate percentage of completion
    completionPercentage = (coveredPoints / totalGuidePoints) * 100;
    print("Completion Percentage: $completionPercentage%");

    // Trigger completion when 80% of the path is covered
    if (completionPercentage >= 95 && !isDrawingComplete) {
      setState(() {
        isDrawingComplete = true;
      });
      _showCongratulations();
    }
  }

  Future<void> speakCorrectWord() async {
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(widget.huruf);
  }

  // Check if drawn points are near the guide path
  bool _isPointNearPath(Offset point) {
    for (ui.PathMetric metric in _guidePath.computeMetrics()) {
      for (double i = 0.0; i < metric.length; i += 10.0) {
        Offset pos = metric.getTangentForOffset(i)!.position;
        if ((pos - point).distance < 20) {
          return true;
        }
      }
    }
    return false;
  }

  // Show a congratulations pop-up
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
  final Path guidePath;

  DrawingPainter(this.points, this.guidePath);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    // Draw user's strokes
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }

    // Draw guide path softly in the background
    final guidePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(guidePath, guidePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
