import 'package:flutter/material.dart';

class Susunkata extends StatefulWidget {
  const Susunkata({Key? key}) : super(key: key);

  @override
  State<Susunkata> createState() => _SusunState();
}

class _SusunState extends State<Susunkata> {
  int blockCount = 6; // Number of blocks
  final List<String?> blocks = [];
  final List<String> letters = ['A', 'B', 'C', 'D', 'E', 'A', 'B', 'C', 'D', 'E', 'A', 'B', 'C', 'D', 'E', 'A', 'B', 'C', 'D', 'E']; // Letters
  final Map<String, bool> usedLetters = {}; // Track used letter instances

  @override
  void initState() {
    super.initState();
    blocks.addAll(List.generate(blockCount, (index) => null)); // Initialize blocks

    // Initialize usedLetters with unique keys for each letter
    for (int i = 0; i < letters.length; i++) {
      usedLetters['$i-${letters[i]}'] = false; // e.g., "0-A", "1-B"
    }
  }

  void updateBlockCount(int newCount) {
    setState(() {
      blockCount = newCount;
      blocks.clear();
      blocks.addAll(List.generate(blockCount, (index) => null));
      usedLetters.forEach((key, value) {
        usedLetters[key] = false; // Reset all letters
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double gridSpacing = 8.0;
    final int crossAxisCount = blockCount < 6 ? blockCount : 6; // Max columns = 6
    final double blockSize =
        (MediaQuery.of(context).size.width - (crossAxisCount + 1) * gridSpacing) / crossAxisCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Drag and Drop Harusnya ya'),
        actions: [
          PopupMenuButton<int>(
            onSelected: updateBlockCount,
            itemBuilder: (context) => [
              PopupMenuItem(value: 4, child: Text('4 Blocks')),
              PopupMenuItem(value: 5, child: Text('5 Blocks')),
              PopupMenuItem(value: 6, child: Text('6 Blocks')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'TOLONK COOOOOKKK AJG FLUTTER', // Placeholder text
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
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

                return DragTarget<String>(
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
                          color: value != null ? Colors.blue[100] : Colors.grey[200],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          value != null ? value.split('-')[1] : '', // Display only the letter
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10), // Space between the blocks and letter pool
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
