import 'package:dyslexiai/susunkata/modeSelector.dart';
import 'package:dyslexiai/training/trainingmain.dart';
import 'package:flutter/material.dart';
import 'package:dyslexiai/speechrecog.dart';
import 'package:dyslexiai/canvas.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainingMain()),
                );
              },
              child: Text('Training camp'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeechToTextPage()),
                );
              },
              child: Text('ini speech to text'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CanvasPage()),
                );
              },
              child: Text('Canvas'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Susunkatalobi()),
                );
              },
              child: Text('SusunKata'),
            ),
          ],
        ),
      ),
    );
  }
}
