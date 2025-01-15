import 'package:flutter/material.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasState();
}

class _CanvasState extends State<CanvasPage> {
  final int numberOfSections = 5; // Change this to control the number of blocks
  List<List<Offset?>> allPoints = []; // Store points for each border

  @override
  void initState() {
    super.initState();
    // Initialize the points list based on the number of sections
    allPoints = List.generate(numberOfSections, (_) => []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canvas Page')),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final totalGaps = numberOfSections - 1; // Number of gaps
          final gapSize = 10.0; // Define the size of each gap
          final totalGapWidth = totalGaps * gapSize; // Total width occupied by gaps
          final availableWidth = constraints.maxWidth - totalGapWidth;
          final sectionWidth = availableWidth / numberOfSections; // Width of each section

          return Stack(
            children: [
              for (int i = 0; i < numberOfSections; i++) // Create sections
                Positioned(
                  left: i * (sectionWidth + gapSize), // Adjust position with gaps
                  top: 400,
                  width: sectionWidth,
                  height: constraints.maxHeight - 800, // Adjust height dynamically
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Border color
                        width: 2.0, // Border thickness
                      ),
                    ),
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        final position = details.localPosition;
                        // Check if the position is within the current section
                        if (position.dx >= 0 &&
                            position.dx <= sectionWidth &&
                            position.dy >= 0 &&
                            position.dy <= constraints.maxHeight - 800) {
                          setState(() {
                            allPoints[i].add(position);
                          });
                        }
                      },
                      onPanEnd: (details) {
                        // Add null to separate lines
                        setState(() {
                          allPoints[i].add(null);
                        });
                      },
                      child: CustomPaint(
                        painter: CanvasPainter(allPoints[i]),
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
          // Clear all drawings
          setState(() {
            for (var points in allPoints) {
              points.clear();
            }
          });
        },
        child: Icon(Icons.clear),
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  final List<Offset?> points;

  CanvasPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => true;
}
