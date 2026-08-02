import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TranslationScreen extends StatefulWidget {
  final String userNationality;

  const TranslationScreen({super.key, this.userNationality = 'United Kingdom'});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final GoogleTranslator _translator = GoogleTranslator();
  final FlutterTts _flutterTts = FlutterTts();
  late stt.SpeechToText _speechToText;
  final TextEditingController _textController = TextEditingController();

  String _translatedText = "Translation will appear here...";
  bool _isTranslating = false;
  bool _isListening = false;

  late String _sourceLangCode;
  String _targetLangCode = 'ne'; // Default target is Nepali

  // --- NEW: Full List of Supported Languages for the UI ---
  final Map<String, String> _supportedLanguages = {
    'en': 'English',
    'ne': 'Nepali',
    'hi': 'Hindi',
    'es': 'Spanish',
    'zh-cn': 'Chinese',
    'fr': 'French',
    'de': 'German',
    'ja': 'Japanese',
    'ko': 'Korean',
    'ar': 'Arabic',
    'ru': 'Russian',
    'it': 'Italian',
  };

  // --- NEW: Expanded Text-To-Speech & Speech-to-Text Codes ---
  final Map<String, String> _regionalCodes = {
    'en': 'en-US',
    'ne': 'ne-NP',
    'hi': 'hi-IN',
    'es': 'es-ES',
    'zh-cn': 'zh-CN',
    'fr': 'fr-FR',
    'de': 'de-DE',
    'ja': 'ja-JP',
    'ko': 'ko-KR',
    'ar': 'ar-SA',
    'ru': 'ru-RU',
    'it': 'it-IT',
  };

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();

    // Set initial source language based on nationality or default to English
    Map<String, String> nationalityToLang = {
      'United States': 'en',
      'United Kingdom': 'en',
      'Spain': 'es',
      'China': 'zh-cn',
      'France': 'fr',
      'India': 'hi',
      'Nepal': 'ne',
    };
    _sourceLangCode = nationalityToLang[widget.userNationality] ?? 'en';

    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print('STT Status: $status'),
        onError: (errorNotification) => print('STT Error: $errorNotification'),
      );

      if (available) {
        setState(() => _isListening = true);

        // Dynamically use the selected source language for the microphone
        String localeId = _regionalCodes[_sourceLangCode] ?? 'en-US';

        _speechToText.listen(
          localeId: localeId,
          onResult: (val) {
            setState(() {
              _textController.text = val.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();

      if (_textController.text.isNotEmpty) {
        _translateText();
      }
    }
  }

  Future<void> _speakText() async {
    if (_translatedText.isNotEmpty &&
        _translatedText != "Translation will appear here...") {
      // Dynamically use the selected target language for the speaker
      String ttsCode = _regionalCodes[_targetLangCode] ?? 'en-US';
      await _flutterTts.setLanguage(ttsCode);
      await _flutterTts.speak(_translatedText);
    }
  }

  Future<void> _translateText() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() => _isTranslating = true);

    try {
      var translation = await _translator.translate(
        _textController.text,
        from: _sourceLangCode,
        to: _targetLangCode,
      );

      setState(() {
        _translatedText = translation.text;
      });

      await _speakText();
    } catch (e) {
      setState(() {
        _translatedText = "Connection error. Please try again.";
      });
    } finally {
      setState(() => _isTranslating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
