import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Susunkata extends StatefulWidget {
  const Susunkata({Key? key}) : super(key: key);

  @override
  State<Susunkata> createState() => _SusunState();
}

class _SusunState extends State<Susunkata> {
  String mispelledDetails = '';
  final String correctWord = 'CRY';
  late List<String> letters;
  late List<String?> blocks;
  final Map<String, bool> usedLetters = {};
  final FlutterTts flutterTts = FlutterTts();
  List<bool> correctPositions = [];
  int wrongAttempts = 0;
  Map<String, int> wrongLetterCounts = {};

  final Map<String, List<String>> letterRules = {
    'P': ['D', 'B'],
    'B': ['D'],
    'D': ['B'],
  };

  @override
  void initState() {
    super.initState();
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

    generatedLetters.shuffle(); // Shuffle the letters
    return generatedLetters;
  }

  void initializeUsedLetters() {
    for (int i = 0; i < letters.length; i++) {
      usedLetters['$i-${letters[i]}'] = false;
    }
    wrongLetterCounts = {};
  }

  void checkWord() {
    String word = blocks.map((block) => block?.split('-')[1] ?? '').join();
    List<bool> newCorrectPositions = List.generate(correctWord.length, (index) => false);
    String currentMispelledDetails = ''; // Store details for the current attempt

    for (int i = 0; i < correctWord.length; i++) {
      if (blocks[i]?.split('-')[1] == correctWord[i]) {
        newCorrectPositions[i] = true;
      } else {
        String wrongLetter = blocks[i]?.split('-')[1] ?? '';
        if (wrongLetter.isNotEmpty) {
          currentMispelledDetails += 'Mispelled $wrongLetter to ${correctWord[i]}\n';
          wrongLetterCounts[wrongLetter] = (wrongLetterCounts[wrongLetter] ?? 0) + 1;
        }
      }
    }

    setState(() {
      correctPositions = newCorrectPositions;
    });

    // Accumulate all mispelled words over time
    if (currentMispelledDetails.isNotEmpty) {
      mispelledDetails += currentMispelledDetails;
    }

    if (word == correctWord) {
      // Word is correct
      Future.delayed(Duration(seconds: 2), () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('🎉 Congratulations!'),
              content: Text('You have guessed the correct word: "$correctWord"!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    } else {
      // Word is incorrect
      wrongAttempts++;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Wrong Word! Your answer: "$word"'),
        backgroundColor: Colors.red,
      ));

      if (wrongAttempts >= 3) {
        showWrongAnalysisDialog();
      }
    }
  }




  void showWrongAnalysisDialog() {
    String mostWrongLetter = '';
    int maxWrongCount = 0;

    wrongLetterCounts.forEach((letter, count) {
      if (count > maxWrongCount) {
        mostWrongLetter = letter;
        maxWrongCount = count;
      }
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hint'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mispelledDetails.isNotEmpty)
                Text('Details:\n$mispelledDetails', style: TextStyle(color: Colors.red))
              else
                Text('You have been wrong 3 times in a row'),
              if (maxWrongCount > 0)
                Text(
                  'You have been wrong the most with the letter "$mostWrongLetter".',
                  style: TextStyle(color: Colors.blue),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return AnotherPage();
                }));
              },
              child: Text('Go to Help Page'),
            ),
          ],
        );
      },
    );
  }

  Future<void> speakCorrectWord() async {
    await flutterTts.setLanguage("en-US");
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
        title: Text('Drag and Drop Letters'),
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
              width: 50,
              height: 50,
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

class AnotherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help Page')),
      body: Center(child: Text('This is the help page!')),
    );
  }
}
