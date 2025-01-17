import 'package:flutter/material.dart';

class Susunkata extends StatefulWidget {
  const Susunkata({Key? key}) : super(key: key);

  @override
  State<Susunkata> createState() => _SusunState();
}

class _SusunState extends State<Susunkata> {
  final List<String?> blocks = List.generate(5, (index) => null); // Five blocks
  final List<String> letters = ['A', 'B', 'C', 'D', 'E']; // Letters to drag

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Drag and Drop Letters')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: blocks.asMap().entries.map((entry) {
              int index = entry.key;
              String? value = entry.value;
              return DragTarget<String>(
                onAccept: (letter) {
                  setState(() {
                    blocks[index] = letter; // Update the block with the letter
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                      color: value != null ? Colors.blue[100] : Colors.grey[200],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      value ?? '',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 40),
          Wrap(
            spacing: 10,
            children: letters.map((letter) {
              return Draggable<String>(
                data: letter,
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
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
