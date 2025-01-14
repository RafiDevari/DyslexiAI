import 'package:flutter/material.dart';// Add your speech-to-text import

class CanvasPage extends StatefulWidget {  // Change to StatefulWidget
  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasState();
}

class _CanvasState extends State<CanvasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canvas Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {},
              child: Text('Placeholder dlu'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
