import 'package:flutter/material.dart';// Add your speech-to-text import

class Susunkata extends StatefulWidget {  // Change to StatefulWidget
  const Susunkata({super.key});

  @override
  State<Susunkata> createState() => _SusunState();
}

class _SusunState extends State<Susunkata> {
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
              child: Text('Placeholder dlu susun'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
