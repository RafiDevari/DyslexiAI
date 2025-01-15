import 'package:flutter/material.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasState();
}

class _CanvasState extends State<CanvasPage> {
  final int numberOfSections = 4; // Change this to control the number of blocks
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
      appBar: AppBar(title: const Text('Canvas Page')),

      body: LayoutBuilder(
        builder: (context, constraints) {
          const double gapSize = 10.0; // Define the size of each gap
          final double totalGapsWidth = (numberOfSections - 1) * gapSize;
          final double sectionSize = (constraints.maxWidth - totalGapsWidth) / numberOfSections;

          return Stack(
            children: [
              for (int i = 0; i < numberOfSections; i++) // Create sections
                Positioned(
                  left: i * (sectionSize + gapSize), // Adjust position with gaps
                  top: 100, // Start 100 pixels from the top
                  width: sectionSize,
                  height: sectionSize, // Make the sections square
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
                            position.dx <= sectionSize &&
                            position.dy >= 0 &&
                            position.dy <= sectionSize) {
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
        child: const Icon(Icons.clear),
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
