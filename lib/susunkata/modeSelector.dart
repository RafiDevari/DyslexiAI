import 'package:dyslexiai/susunkata/levelSelector.dart';
import 'package:flutter/material.dart';
import 'package:dyslexiai/susunkata/modePermainan/modeEndless.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => modeEndless(health: 3,score: 0,),
                  ),
                );
              },
              child: Text('Endless Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
