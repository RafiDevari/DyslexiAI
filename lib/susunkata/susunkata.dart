import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Susunkata extends StatefulWidget {
  const Susunkata({Key? key}) : super(key: key);

  @override
  State<Susunkata> createState() => _SusunState();
}

class _SusunState extends State<Susunkata> {
  final String correctWord = 'CRY'; // Single correct word
  late List<String?> blocks;
  final List<String> letters = ['C', 'R', 'Y', 'A', 'B', 'C']; // Pool of letters
  final Map<String, bool> usedLetters = {}; // Track used letter instances
  final FlutterTts flutterTts = FlutterTts(); // TTS instance
  List<bool> correctPositions = []; // Track correct positions
  int wrongAttempts = 0; // Counter for wrong attempts
  Map<String, int> wrongLetterCounts = {}; // Track wrong letter frequencies

  @override
  void initState() {
    super.initState();
    blocks = List.generate(correctWord.length, (index) => null); // Initialize blocks
    correctPositions = List.generate(correctWord.length, (index) => false); // Initialize correct positions
    initializeUsedLetters();
  }

  void initializeUsedLetters() {
    for (int i = 0; i < letters.length; i++) {
      usedLetters['$i-${letters[i]}'] = false; // e.g., "0-C", "1-R"
    }
    wrongLetterCounts = {};
  }

  void checkWord() {
    String word = blocks.map((block) => block?.split('-')[1] ?? '').join(); // Form the word
    List<bool> newCorrectPositions = List.generate(correctWord.length, (index) => false);

    for (int i = 0; i < correctWord.length; i++) {
      if (blocks[i]?.split('-')[1] == correctWord[i]) {
        newCorrectPositions[i] = true;
      } else {
        String wrongLetter = blocks[i]?.split('-')[1] ?? '';
        if (wrongLetter.isNotEmpty) {
          wrongLetterCounts[wrongLetter] = (wrongLetterCounts[wrongLetter] ?? 0) + 1;
        }
      }
    }

    setState(() {
      correctPositions = newCorrectPositions;
    });

    if (word == correctWord) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Correct Word! 🎉'),
        backgroundColor: Colors.green,
      ));
      wrongAttempts = 0; // Reset wrong attempts
    } else {
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
          content: Text(
            maxWrongCount > 0
                ? 'LU BODOH DI HURUF : "$mostWrongLetter".'
                : 'coba lagi ya :D',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return AnotherPage(); // Replace with your target page
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
          ElevatedButton(
            onPressed: checkWord,
            child: Text('Check Word'),
          ),
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
