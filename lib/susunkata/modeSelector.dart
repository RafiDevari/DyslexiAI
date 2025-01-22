import 'package:flutter/material.dart';
import 'package:dyslexiai/susunkata/levelSelector.dart';
import 'package:dyslexiai/susunkata/modePermainan/modeEndless.dart';

import '../data/user.dart';

class Susunkatalobi extends StatefulWidget {
  @override
  _SusunkatalobiState createState() => _SusunkatalobiState();
}

class _SusunkatalobiState extends State<Susunkatalobi> {
  String misspelledData = "Loading...";  // Initial loading text

  @override
  void initState() {
    super.initState();
    _loadMisspelledData();  // Automatically load data when the widget is created
  }

  // Function to load misspelled data and update the UI
  Future<void> _loadMisspelledData() async {
    Map<String, int> loadedMisspelled = await GameData.loadMisspelledLetters();
    setState(() {
      misspelledData = loadedMisspelled.isNotEmpty
          ? loadedMisspelled.toString()
          : "No data available";
    });
  }

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
            Text(
              misspelledData,  // Automatically display loaded data
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 20),

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => modeEndless(health: 3, score: 0),
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
