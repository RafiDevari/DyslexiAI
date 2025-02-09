import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/user.dart'; // Import the GameData class

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  Map<String, int> misspelledData = {};
  String mistakeString = "";
  String suggestion = "Loading...";

  final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${dotenv.env['GEMINI_API_KEY']}";

  @override
  void initState() {
    super.initState();
    _loadMisspelledData();
  }

  Future<void> _loadMisspelledData() async {
    misspelledData = await GameData.loadMisspelledLetters();
    mistakeString = misspelledData.entries
        .map((entry) => '${entry.key}: ${entry.value} kali')
        .join(', ');

    setState(() {});
    await _getImprovementSuggestions();
  }

  Future<void> _getImprovementSuggestions() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": "Ini adalah aplikasi permainan untuk anak disleksia, user melakukan kesalahan ini $mistakeString. Berikan saran dalam kalimat singkat dan saran latihannya."
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String botResponse = data["candidates"][0]["content"]["parts"][0]["text"] ?? "No improvement suggestion available.";

        setState(() {
          suggestion = botResponse;
        });
      } else {
        setState(() {
          suggestion = "Error fetching suggestions: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        suggestion = "Error fetching suggestions: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Color(0xFFFDFCDC),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF0081A7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Evaluasi Kesalahan',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFF07167),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Kesalahan',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.redAccent, width: 1.5),
                              ),
                              child: Text(
                                mistakeString.isEmpty ? 'No mistakes recorded yet.' : mistakeString,
                                style: TextStyle(fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFF00AFB9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Perbaikan',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.green, width: 1.5),
                              ),
                              child: Text(
                                suggestion,
                                style: TextStyle(fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadMisspelledData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Perbarui Data',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
