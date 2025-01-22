import 'package:dyslexiai/data/kataList.dart';
import 'package:flutter/material.dart';
import 'package:dyslexiai/susunkata/modePermainan/modeAdventure.dart';

class kataSelector extends StatelessWidget {
  final String type;
  kataSelector({super.key, required this.type});


  @override
  Widget build(BuildContext context) {
    List<String> tipe = ambilKataSesuaiTipe(type);

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
                  MaterialPageRoute(builder: (context) => Susunkata(correctWord: tipe[0])),
                );
              },
              child: Text('Level 1'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Susunkata(correctWord: tipe[1])),
                );
              },
              child: Text('Level 2'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Susunkata(correctWord: tipe[2])),
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


List<String> ambilKataSesuaiTipe(String type) {
  if (type == "Darat") {
    return hewanDarat;
  } else if (type == "Laut") {
    return hewanLaut;
  } else if (type == "Udara") {
    return hewanUdara;
  }
  else {return [];}
}


