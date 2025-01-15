import 'package:flutter/material.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasState();
}

class _CanvasState extends State<CanvasPage> {
  List<Offset?> points = []; // Gunakan Offset? untuk mengizinkan nilai null

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canvas Page')),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                top: 400, // Match the y constraint starting point
                left: 0,
                right: 0,
                bottom: 100, // Match the max height constraint
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Warna border
                      width: 2.0,          // Ketebalan border
                    ),
                  ),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      final position = details.localPosition;
                      // Adjust the localPosition to account for the offset
                      if (position.dx >= 0 &&
                          position.dx <= constraints.maxWidth &&
                          position.dy >= 0 &&
                          position.dy <= 400) {
                        setState(() {
                          points.add(position);
                        });
                      }
                    },
                    onPanEnd: (details) {
                      // Menambahkan null untuk memisahkan garis
                      setState(() {
                        points.add(null);
                      });
                    },
                    child: CustomPaint(
                      painter: CanvasPainter(points),
                      size: Size.infinite, // Memenuhi seluruh area layar
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
          // Menghapus semua gambar
          setState(() {
            points.clear();
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
