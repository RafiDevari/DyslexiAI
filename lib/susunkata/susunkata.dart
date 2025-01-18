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

  @override
  void initState() {
    super.initState();
    blocks = List.generate(correctWord.length, (index) => null); // Initialize blocks
    correctPositions = List.generate(correctWord.length, (index) => false); // Initialize correct positions
    initializeUsedLetters();
  }

  void initializeUsedLetters() {
    // Initialize usedLetters with unique keys for each letter
    for (int i = 0; i < letters.length; i++) {
      usedLetters['$i-${letters[i]}'] = false; // e.g., "0-C", "1-R"
    }
  }

  void checkWord() {
    String word = blocks.map((block) => block?.split('-')[1] ?? '').join(); // Form the word
    List<bool> newCorrectPositions = List.generate(correctWord.length, (index) => false);

    for (int i = 0; i < correctWord.length; i++) {
      if (blocks[i]?.split('-')[1] == correctWord[i]) {
        newCorrectPositions[i] = true;
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
    } else {
      // Display the incorrect word
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Wrong Word! Your answer: "$word"'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> speakCorrectWord() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(correctWord);
  }

  @override
  Widget build(BuildContext context) {
    final double gridSpacing = 8.0;
    final int crossAxisCount = correctWord.length; // Number of blocks = word length
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
            'In Maintenance', // Placeholder text
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: speakCorrectWord, // Play TTS on image tap
            child: Image.asset(
              'assets/speaker_icon.png', // Add your image in assets folder
              width: 50,
              height: 50,
            ),
          ),
          SizedBox(height: 10), // Space between text and blocks
          Expanded(
            flex: 2, // Use 2/3 of available space for the blocks
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
                bool isCorrect = correctPositions[index]; // Check if the position is correct

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    DragTarget<String>(
                      onWillAccept: (letter) => value == null && usedLetters[letter] == false,
                      onAccept: (letter) {
                        setState(() {
                          blocks[index] = letter;
                          usedLetters[letter] = true; // Mark letter as used
                        });
                      },
                      builder: (context, candidateData, rejectedData) {
                        return GestureDetector(
                          onTap: () {
                            if (value != null) {
                              setState(() {
                                usedLetters[value] = false; // Unmark letter as used
                                blocks[index] = null; // Clear block
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
                              value != null ? value.split('-')[1] : '', // Display only the letter
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
          SizedBox(height: 10), // Space between the blocks and button
          ElevatedButton(
            onPressed: checkWord,
            child: Text('Check Word'),
          ),
          SizedBox(height: 10), // Space between the button and letters
          Flexible(
            flex: 1, // Use 1/3 of available space for the letter pool
            child: Padding(
              padding: const EdgeInsets.all(10.0), // Add padding around the letter pool
              child: Wrap(
                spacing: 10, // Horizontal spacing between letters
                runSpacing: 10, // Vertical spacing between rows of letters
                children: usedLetters.entries.map((entry) {
                  String key = entry.key;
                  bool isUsed = entry.value;
                  String letter = key.split('-')[1]; // Extract letter from key

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
