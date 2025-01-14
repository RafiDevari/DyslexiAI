import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

// The main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech to Text App',
      home: const MyHomePage(),
    );
  }
}

// The main page of the app
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late stt.SpeechToText _speech; // Speech-to-text object
  bool _isListening = false; // Whether the app is currently listening
  String _text = "Press the button and start speaking"; // Displayed text
  String _localeId = "id_ID";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText(); // Initialize the speech-to-text instance
  }

  // Method to start listening
  void _startListening() async {
    // Request microphone permission
    if (await Permission.microphone.request().isGranted) {
      // Try to initialize speech-to-text
      bool isAvailable = await _speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );

      if (isAvailable) {
        // Start listening to speech
        setState(() {
          _isListening = true;
          _text = "Listening... please speak!";
        });

        _speech.listen(
          onResult: (result) {
            // Update the text with recognized speech
            setState(() {
              _text = result.recognizedWords;
            });
          },
          localeId: _localeId,
        );
      } else {
        // If speech recognition is not available
        setState(() {
          _text = "Speech recognition is not available on this device.";
        });
      }
    } else {
      // If microphone permission is denied
      setState(() {
        _text = "Microphone permission is required to use this feature.";
      });
    }
  }

  // Method to stop listening
  void _stopListening() {
    _speech.stop(); // Stop speech-to-text
    setState(() {
      _isListening = false;
      _text = "Press the button and start speaking"; // Reset the text
    });
    print(_speech);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display transcribed text or a message
              Text(
                _text,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Floating button to start/stop listening
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
