import 'package:dyslexiai/susunkata/kataSelector.dart';
import 'package:flutter/material.dart';

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
                  MaterialPageRoute(builder: (context) => kataSelector(type: "Darat")),
                );
              },
              child: Text('Hewan Darat'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => kataSelector(type: "Laut",)),
                );
              },
              child: Text('Hewan Laut'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => kataSelector(type: "Udara",)),
                );
              },
              child: Text('Hewan Udara'),
            ),

            SizedBox(height: 20),


          ],
        ),
      ),
    );
  }
}
