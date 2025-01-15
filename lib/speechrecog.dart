import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechToTextPage extends StatefulWidget {
  const SpeechToTextPage({super.key});

  @override
  State<SpeechToTextPage> createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Tekan tombol dan mulai berbicara";
  String _localeId = "id_ID"; // Locale for Indonesian language

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    if (await Permission.microphone.request().isGranted) {
      bool isAvailable = await _speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );

      if (isAvailable) {
        setState(() {
          _isListening = true;
          _text = "Mendengarkan... Silakan bicara!";
        });

        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
          localeId: _localeId,
          partialResults: true,
        );
      } else {
        setState(() {
          _text = "Pengenal ucapan tidak tersedia di perangkat ini.";
        });
      }
    } else {
      setState(() {
        _text = "Izin mikrofon diperlukan untuk menggunakan fitur ini.";
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
      _text = "Tekan tombol dan mulai berbicara";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _text,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: _isListening ? _stopListening : _startListening,
                child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
