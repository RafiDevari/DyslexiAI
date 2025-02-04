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
  List<Map<String, String>> messages = [];
  TextEditingController _textController = TextEditingController();
  String userInput = "";
  final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key="; // Replace with your actual API key

  ScrollController _scrollController = ScrollController();
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  Future<void> generateResponse() async {
    if (userInput.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "message": userInput});
    });

    _textController.clear(); // Clear text field after sending
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
                  "text": "Kamu adalah Beemo, asisten AI yang ramah untuk anak-anak. "
                      "Berbicaralah dengan santai, ceria, dan menarik!\n\n"
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

        setState(() {
          messages.add({"sender": "beemo", "message": botResponse});
        });

        _scrollToBottom();
      } else {
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
      String sender = msg['sender'] == "bot" ? "Beemo" : "User";
      history += "$sender: ${msg['message']}\n";
    }
    return history;
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

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
            _textController.text = userInput; // Update text field with recognized speech
          });
          if (result.hasConfidenceRating && result.confidence > 0.5) {
            generateResponse();
          }
        },
        localeId: "id_ID",
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFCDC),
      appBar: AppBar(
        backgroundColor: Color(0xFF0081A7),
        title: Row(
          children: [
            Image.asset('assets/logo.jpeg', height: 40, width: 40, fit: BoxFit.cover),
            SizedBox(width: 10),
            Text('Beemo'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
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
                        color: sender == "user" ? Color(0xFFF07167) : Color(0XFFFED9B7),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Microphone button
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    color: _isListening ? Colors.red : Colors.blue,
                  ),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                // Text input field
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onChanged: (text) {
                      setState(() {
                        userInput = text;
                      });
                    },
                    onSubmitted: (text) {
                      generateResponse();
                    },
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                  ),
                ),
                // Send button
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: userInput.trim().isEmpty ? null : generateResponse,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
