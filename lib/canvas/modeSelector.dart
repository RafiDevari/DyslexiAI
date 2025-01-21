import 'package:flutter/material.dart';
import 'canvas.dart';
import 'levelSelector.dart';

class Canvaslobi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canvas Lobi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Canvaslevelselector()),
                );
              },
              child: Text('Mode Huruf'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => modeEndless(health: 3,score: 0,),
                //   ),
                // );
              },
              child: Text('Endless Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
