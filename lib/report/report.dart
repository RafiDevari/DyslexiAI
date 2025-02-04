import 'package:dyslexiai/training/canvas/trainingCanvas.dart';
import 'package:flutter/material.dart';


class Report extends StatelessWidget {
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