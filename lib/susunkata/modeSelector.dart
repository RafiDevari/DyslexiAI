import 'package:flutter/material.dart';
import 'package:dyslexiai/susunkata/levelSelector.dart';
import 'package:dyslexiai/susunkata/modePermainan/modeEndless.dart';
import '../data/user.dart';

class Susunkatalobi extends StatefulWidget {
  @override
  _SusunkatalobiState createState() => _SusunkatalobiState();
}

class _SusunkatalobiState extends State<Susunkatalobi> {
  String misspelledData = "Loading..";

  @override
  void initState() {
    super.initState();
    _loadMisspelledData();
  }

  Future<void> _loadMisspelledData() async {
    Map<String, int> loadedMisspelled = await GameData.loadMisspelledLetters();
    setState(() {
      misspelledData = loadedMisspelled.isNotEmpty
          ? loadedMisspelled.toString()
          : "No data available";
    });
  }

  Widget _buildImageButton(String imagePath, String title, String description, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [

            Ink.image(
              image: AssetImage(imagePath),
              width: MediaQuery.of(context).size.width * (11 / 12),
              height: 300,
              fit: BoxFit.cover,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            Positioned(
              top: 20,
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFCDC), // Set background color here
      appBar: AppBar(
        title: Text('Susun Kata'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            _buildImageButton(
              'assets/adventure.png',
              'Adventure Mode',
              'Explore levels and complete challenges',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Susunkatalevelselector()),
                );
              },
            ),
            _buildImageButton(
              'assets/endless.png',
              'Endless Mode',
              'Survive as long as possible',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => modeEndless(health: 3, score: 0),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}