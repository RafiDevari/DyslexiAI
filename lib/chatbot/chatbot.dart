import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  // Store the conversation history
  List<Map<String, String>> messages = [];
  String userInput = "";
  final String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=";

  // Function to send the user's input to the bot and fetch its response
  Future<void> generateResponse() async {
    if (userInput.isEmpty) return;

    // Add user message to the chat
    setState(() {
      messages.add({"sender": "user", "message": userInput});
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": userInput
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String botResponse = data["candidates"][0]["content"]["parts"][0]["text"] ?? "Error generating response";

        // Add bot's message to the chat
        setState(() {
          messages.add({"sender": "bot", "message": botResponse});
        });
      } else {
        setState(() {
          messages.add({"sender": "bot", "message": "API Error: ${response.statusCode}"});
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"sender": "bot", "message": "Error: $e"});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatbot')),
      body: Column(
        children: [
          // Display the chat messages
          Expanded(
            child: ListView.builder(
              reverse: true, // Start from the bottom
              itemCount: messages.length,
              itemBuilder: (context, index) {
                String sender = messages[index]["sender"] ?? "";
                String message = messages[index]["message"] ?? "";

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: sender == "user" ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: sender == "user" ? Colors.blue : Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input field for user
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        userInput = text;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    generateResponse();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
