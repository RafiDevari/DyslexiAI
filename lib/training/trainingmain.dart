import 'package:dyslexiai/training/trainingCanvas.dart';
import 'package:flutter/material.dart';

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
                  MaterialPageRoute(builder: (context) => TrainingCanvas()),
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