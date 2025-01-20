import 'package:flutter/material.dart';
import 'package:dyslexiai/susunkata/susunkata.dart';

class Susunkatalevelselector extends StatelessWidget {
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
                  MaterialPageRoute(builder: (context) => Susunkata(correctWord: "IKAN",)),
                );
              },
              child: Text('Level 1'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Susunkata(correctWord: "RUMAH",)),
                );
              },
              child: Text('Level 2'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Susunkata(correctWord: "MAKANAN",)),
                );
              },
              child: Text('Level 3'),
            ),

            SizedBox(height: 20),


          ],
        ),
      ),
    );
  }
}
