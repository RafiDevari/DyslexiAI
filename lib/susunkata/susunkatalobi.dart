import 'package:dyslexiai/susunkata/levelselector.dart';
import 'package:flutter/material.dart';

class Susunkatalobi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Susunkatalobi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Susunkatalevelselector()),
                );
              },
              child: Text('Adventure Mode'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Define the action for the second button
                print('Second button pressed');
              },
              child: Text('Endless Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
