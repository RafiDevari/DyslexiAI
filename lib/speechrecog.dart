import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

class PronunciationCheckerPage extends StatefulWidget {
  const PronunciationCheckerPage({super.key});
  @override
  State<PronunciationCheckerPage> createState() => _PronunciationCheckerPageState();
}

class _PronunciationCheckerPageState extends State<PronunciationCheckerPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = "";
  String _targetWord = "";
  String _feedback = "";
  List<TextSpan> _highlightedText = [];

  final List<String> _wordList = ["kucing", "ayam", "burung", "ikan"];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _selectNewWord();
  }

  void _selectNewWord() {
    setState(() {
      _targetWord = _wordList[DateTime.now().microsecondsSinceEpoch % _wordList.length];
      _feedback = "";
      _highlightedText = [TextSpan(text: _targetWord, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold))];
    });
  }

  void _provideFeedback(String spokenText) {
    setState(() {
      _spokenText = spokenText;
      _highlightedText = _getHighlightedText(spokenText, _targetWord);
      _feedback = spokenText.toLowerCase() == _targetWord.toLowerCase() 
          ? "Bagus! Pengucapan Anda benar! ✅" 
          : "Coba perbaiki kesalahan yang ditandai merah!";
    });
  }

  List<TextSpan> _getHighlightedText(String spoken, String target) {
    List<TextSpan> spans = [];
    int minLength = spoken.length < target.length ? spoken.length : target.length;
    
    for (int i = 0; i < minLength; i++) {
      if (spoken[i].toLowerCase() == target[i].toLowerCase()) {
        spans.add(TextSpan(text: target[i], style: const TextStyle(color: Colors.black, fontSize: 48)));
      } else {
        spans.add(TextSpan(text: target[i], style: const TextStyle(color: Colors.red, fontSize: 48, fontWeight: FontWeight.bold)));
      }
    }
    
    if (target.length > spoken.length) {
      spans.add(TextSpan(text: target.substring(minLength), style: const TextStyle(color: Colors.red, fontSize: 48, fontWeight: FontWeight.bold)));
    }
    return spans;
  }

  void _startListening() async {
    if (await Permission.microphone.request().isGranted) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Error: $error'),
      );

      if (available) {
        setState(() {
          _isListening = true;
          _spokenText = "Mendengarkan...";
          _feedback = "";
        });

        _speech.listen(
          onResult: (result) {
            if (result.finalResult) {
              _provideFeedback(result.recognizedWords);
            }
          },
          localeId: 'id_ID',
          partialResults: false,
        );
      }
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
      appBar: AppBar(
        title: Text('Latihan Pengucapan', style: GoogleFonts.lexend()),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ucapkan kata ini:', style: GoogleFonts.lexend(fontSize: 20, color: Colors.grey[600])),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: _highlightedText,
                  style: GoogleFonts.lexend(fontSize: 48),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _spokenText,
                style: GoogleFonts.lexend(fontSize: 24, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                _feedback,
                style: GoogleFonts.lexend(fontSize: 20, color: _spokenText.toLowerCase() == _targetWord.toLowerCase() ? Colors.green : Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _isListening ? _stopListening : _startListening,
                    child: Icon(_isListening ? Icons.mic_off : Icons.mic),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: _selectNewWord,
                    child: const Icon(Icons.skip_next),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
