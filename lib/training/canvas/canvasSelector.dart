import 'package:dyslexiai/training/canvas/trainingCanvas.dart';
import 'package:flutter/material.dart';

class CanvasSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Camp'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainingCanvas(huruf:"A")),
                );
              },
              child: Text('Latihan Nulis'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainingCanvas(huruf:"B")),
                );
              },
              child: Text('Latihan Nulis'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainingCanvas(huruf:"S")),
                );
              },
              child: Text('Latihan Nulis'),
            ),

            SizedBox(height: 20),


          ],
        ),
      ),
    );
  }
}