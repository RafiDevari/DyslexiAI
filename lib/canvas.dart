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
      body: GestureDetector(
        onPanUpdate: (details) {
          // Menambahkan titik baru saat pengguna menggambar
          setState(() {
            points.add(details.localPosition);
          });
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
