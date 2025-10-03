import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsProvider extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();

  TtsProvider() {
    _initTts();
  }

  Future<void> _initTts() async {
    _flutterTts.setSpeechRate(0.4);
    _flutterTts.setLanguage('en-US');
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}