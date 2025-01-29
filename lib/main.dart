import 'package:dyslexiai/canvas/modeSelector.dart';
import 'package:dyslexiai/chatbot/chatbot.dart';
import 'package:dyslexiai/susunkata/modeSelector.dart';
import 'package:dyslexiai/training/trainingmain.dart';
import 'package:flutter/material.dart';
import 'package:dyslexiai/speechrecog.dart';
import 'package:dyslexiai/canvas/canvas.dart';


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
      body: Container(
        color: Color(0xFFFDFCDC), // Change background color here
        child: Stack(
          children: [
            Center(
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
                        MaterialPageRoute(builder: (context) => Canvaslobi()),
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
            Positioned(
              top: 20, // Distance from the top
              right: 20, // Distance from the right
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Chatbot()),
                  );
                },
                backgroundColor: Colors.blue,
                child: Image.asset('assets/logo.jpeg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
