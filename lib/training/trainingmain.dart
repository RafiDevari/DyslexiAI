import 'package:dyslexiai/training/canvas/trainingCanvas.dart';
import 'package:flutter/material.dart';

import 'canvas/canvasSelector.dart';

class TrainingMain extends StatelessWidget {
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
                  MaterialPageRoute(builder: (context) => CanvasSelector()),
                );
              },
              child: Text('Latihan Nulis'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Define the action for the second button
                print('Second button pressed');
              },
              child: Text('Button 2'),
            ),
          ],
        ),
      ),
    );
  }
}