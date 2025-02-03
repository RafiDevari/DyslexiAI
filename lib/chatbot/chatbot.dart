import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

  // Scroll controller for automatic scrolling
  ScrollController _scrollController = ScrollController();

  // Speech recognition object
  stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;

  // Function to send the user's input to the bot and fetch its response
  Future<void> generateResponse() async {
    if (userInput.isEmpty) return;

    // Add user message to chat history
    setState(() {
      messages.add({"sender": "user", "message": userInput});
    });

    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": "Kamu adalah Beemo, asisten AI yang ramah untuk anak anak. "
                      "Kamu suka membantu pengguna, bercanda, dan memberikan saran. "
                      "Berbicaralah dengan santai, ceria, dan menarik!, tetapi text mu tidak boleh panjang panjang karena user bakal bosan\n\n"
                      "Percakapan sejauh ini:\n"
                      "${_buildConversationHistory()}\n"
                      "Pengguna: $userInput"
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String botResponse = data["candidates"][0]["content"]["parts"][0]["text"] ?? "Oops! Beemo got confused! 😵";

        // Add Beemo's response to chat
        setState(() {
          messages.add({"sender": "beemo", "message": botResponse});
        });

        _scrollToBottom();
      } else {
        print("API Error Response: ${response.body}");
        setState(() {
          messages.add({"sender": "beemo", "message": "API Error: ${response.statusCode} - ${response.body}"});
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"sender": "beemo", "message": "Oops! Beemo encountered an error: $e"});
      });
    }

    _scrollToBottom();
  }



  String _buildConversationHistory() {
    String history = "";
    for (var msg in messages) {
      // Change "bot" to "Beemo" in history
      String sender = msg['sender'] == "bot" ? "Beemo" : "User";
      history += "$sender: ${msg['message']}\n";
    }
    return history + "User: $userInput"; // Append new message
  }


  // Function to scroll to the bottom of the ListView
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // Start listening to user's voice
  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            userInput = result.recognizedWords;
          });
          if (result.hasConfidenceRating && result.confidence > 0.5) {
            generateResponse(); // Call the function to send the message after the voice input is recognized
          }
        },
        localeId: "id_ID",
      );
    }
  }

  // Stop listening
  void _stopListening() {
    _speech.stop();
    _isListening = false;
    setState(() {
      _isListening = false;
    });
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
              controller: _scrollController, // Controller added here
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
          // Row for controlling the voice input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    color: _isListening ? Colors.red : Colors.blue,
                  ),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                // Display the recognized text
                Expanded(
                  child: Text(
                    userInput,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
