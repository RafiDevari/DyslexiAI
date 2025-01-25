import 'package:dyslexiai/training/canvas/trainingCanvas.dart';
import 'package:flutter/material.dart';

class CanvasSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Camp'),
      ),
      body:
      Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(26, (index) {
              String letter = String.fromCharCode(65 + index); // Convert ASCII to A-Z
              return Column(
                children: [
                  LetterButton(letter: letter),
                  SizedBox(height: 20),
                ],
              );
            }),
          ),
        ),
      )
    );
  }
}



class LetterButton extends StatelessWidget {
  final String letter;

  const LetterButton({Key? key, required this.letter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrainingCanvas(huruf: letter)),
            );
          },
          child: Text('Latihan Nulis $letter'),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}