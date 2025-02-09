import 'dart:math';
import 'package:dyslexiai/training/canvas/trainingCanvas.dart';
import 'package:dyslexiai/training/trainingmain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:dyslexiai/data/susunKataEndlessData.dart';
import 'package:dyslexiai/data/user.dart';


class modeEndless extends StatefulWidget {
  final int health;// Add a constructor parameter
  final int score;
  final String mispelledDetails;

  const modeEndless({super.key, required this.health, required this.score, this.mispelledDetails = ''});
  @override
  State<modeEndless> createState() => _SusunState();
}

class _SusunState extends State<modeEndless> {

  String mispelledDetails = '';
  late String correctWord;
  late int score ;
  late List<String> letters;
  late List<String?> blocks;
  final Map<String, bool> usedLetters = {};
  final FlutterTts flutterTts = FlutterTts();
  List<bool> correctPositions = [];
  late int lives;
  Map<String, int> wrongLetterCounts = {};



  @override
  void initState() {
    super.initState();
    mispelledDetails = widget.mispelledDetails;
    correctWord = wordList[Random().nextInt(wordList.length)];
    lives = widget.health;
    score = widget.score;
    letters = generateLetters();
    blocks = List.generate(correctWord.length, (index) => null);
    correctPositions = List.generate(correctWord.length, (index) => false);
    initializeUsedLetters();
  }

  List<String> generateLetters() {
    List<String> generatedLetters = correctWord.split('');
    Random random = Random();

    // Add additional letters based on rules
    for (String letter in correctWord.split('')) {
      if (letterRules.containsKey(letter)) {
        generatedLetters.addAll(letterRules[letter]!);
      }
    }

    // Fill the rest with random letters to reach double the correct word size
    while (generatedLetters.length < correctWord.length * 2) {
      String randomLetter = String.fromCharCode(random.nextInt(26) + 65); // Random A-Z
      generatedLetters.add(randomLetter);
    }

    generatedLetters.shuffle();
    return generatedLetters;
  }

  void initializeUsedLetters() {
    for (int i = 0; i < letters.length; i++) {
      usedLetters['$i-${letters[i]}'] = false;
    }
    wrongLetterCounts = {};
  }

   // Initial number of hearts

  Future<void> checkWord() async {
    String word = blocks.map((block) => block?.split('-')[1] ?? '').join();
    List<bool> newCorrectPositions = List.generate(correctWord.length, (index) => false);
    String currentMispelledDetails = '';

    for (int i = 0; i < correctWord.length; i++) {
      if (blocks[i]?.split('-')[1] == correctWord[i]) {
        newCorrectPositions[i] = true;
      } else {
        String wrongLetter = blocks[i]?.split('-')[1] ?? '';
        await GameData.updateMisspelledLetters({wrongLetter: 1});
        if (wrongLetter.isNotEmpty) {
          currentMispelledDetails += '\nMispelled ${correctWord[i] } to $wrongLetter';
          wrongLetterCounts[wrongLetter] = (wrongLetterCounts[wrongLetter] ?? 0) + 1;
        }
      }
    }

    setState(() {
      correctPositions = newCorrectPositions;
    });

    if (currentMispelledDetails.isNotEmpty) {
      mispelledDetails += currentMispelledDetails;
    }

    if (word == correctWord) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Correct Word!'),
        backgroundColor: Colors.green,
      ));

      await GameData.updateExperience(5);

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
        resetGame(lives,score+1,mispelledDetails);
      });
    } else {
      lives--; // Deduct a heart

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Wrong Word! Your answer: "$word"'),
        backgroundColor: Colors.red,
      ));

      if (lives <= 0) {
        showGameOverDialog();
      }
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,  // Prevent closing the dialog without choosing
      builder: (context) {
        return AlertDialog(
          title: Text('💔 Game Over'),
          content: Text('You have used all your hearts! What would you like to do next?'+mispelledDetails),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();   // Close the dialog
                resetGame(3,0);  // Restart the current game
              },
              child: Text('Restart'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => TrainingCanvas(huruf: correctWord[0])),
                );
              },
              child: Text('Go to Training'),
            )
          ],
        );
      },
    );
  }


  void resetGame(int lives,int score, [String mispelledDetails = ""]) {// Close the pop-up
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => modeEndless(health: lives,score: score,mispelledDetails: mispelledDetails),
      ),
    );
  }


  Future<void> speakCorrectWord() async {
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(correctWord);
  }

  @override
  Widget build(BuildContext context) {
    final double gridSpacing = 8.0;
    final int crossAxisCount = correctWord.length;
    final double blockSize =
        (MediaQuery.of(context).size.width - (crossAxisCount + 1) * gridSpacing) / crossAxisCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mode Tanpa Batas'),
        actions: [
          Text('Score: $score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

          Row(
            children:
            List.generate(3, (index) {
              return Icon(
                index < lives ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              );
            }),

          ),

          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'In Maintenance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: speakCorrectWord,
            child: Image.asset(
              'assets/speaker_icon.png',
              width: 100,
              height: 100,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: GridView.builder(
              padding: EdgeInsets.all(gridSpacing),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: gridSpacing,
                crossAxisSpacing: gridSpacing,
              ),
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                String? value = blocks[index];
                bool isCorrect = correctPositions[index];

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    DragTarget<String>(
                      onWillAccept: (letter) => value == null && usedLetters[letter] == false,
                      onAccept: (letter) {
                        setState(() {
                          blocks[index] = letter;
                          usedLetters[letter] = true;
                        });
                      },
                      builder: (context, candidateData, rejectedData) {
                        return GestureDetector(
                          onTap: () {
                            if (value != null) {
                              setState(() {
                                usedLetters[value] = false;
                                blocks[index] = null;
                              });
                            }
                          },
                          child: Container(
                            width: blockSize,
                            height: blockSize,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8.0),
                              color: isCorrect
                                  ? Colors.green[100]
                                  : (value != null ? Colors.blue[100] : Colors.grey[200]),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              value != null ? value.split('-')[1] : '',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                    if (isCorrect)
                      Positioned(
                        top: 0,
                        child: Icon(Icons.check_circle, color: Colors.green, size: 24),
                      ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 10),
          SizedBox(height: 10),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: usedLetters.entries.map((entry) {
                  String key = entry.key;
                  bool isUsed = entry.value;
                  String letter = key.split('-')[1];

                  return Draggable<String>(
                    data: key,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          letter,
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                    childWhenDragging: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        letter,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                    child: Opacity(
                      opacity: isUsed ? 0.5 : 1.0,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: isUsed ? Colors.grey : Colors.blue,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          letter,
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: checkWord,
            child: Text('Check Word'),
          ),
        ],
      ),
    );
  }
}
