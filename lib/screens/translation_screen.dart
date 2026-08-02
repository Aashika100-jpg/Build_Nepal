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

  void _swapLanguages() {
    setState(() {
      String temp = _sourceLangCode;
      _sourceLangCode = _targetLangCode;
      _targetLangCode = temp;

      _textController.text =
          _translatedText == "Translation will appear here..." ||
              _translatedText.startsWith("Error")
          ? ""
          : _translatedText;
      _translatedText = "Translation will appear here...";
    });
  }

  // --- NEW: Widget to build the Dropdown Menu ---
  Widget _buildLanguageDropdown(bool isSource) {
    String currentValue = isSource ? _sourceLangCode : _targetLangCode;

    return DropdownButton<String>(
      value: currentValue,
      icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.indigo),
      elevation: 16,
      dropdownColor: Colors.white,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.indigo,
      ),
      underline: const SizedBox(), // Removes the default underline
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            if (isSource) {
              _sourceLangCode = newValue;
            } else {
              _targetLangCode = newValue;
            }
          });
        }
      },
      items: _supportedLanguages.keys.map<DropdownMenuItem<String>>((
        String key,
      ) {
        return DropdownMenuItem<String>(
          value: key,
          child: Text(_supportedLanguages[key]!),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Voice Translator',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        elevation: 0,
        backgroundColor: Colors.indigo[700],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.indigo[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- UPDATED: Language Dropdowns & Swap Button ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Center(child: _buildLanguageDropdown(true))),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo[50],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.swap_horiz_rounded,
                        size: 28,
                        color: Colors.indigo,
                      ),
                      onPressed: _swapLanguages,
                    ),
                  ),
                  Expanded(child: Center(child: _buildLanguageDropdown(false))),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Input Area
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Type or tap the mic to speak...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? Colors.redAccent : Colors.indigo[400],
                    size: 32,
                  ),
                  onPressed: _listen,
                  tooltip: "Tap to talk",
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Translate Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _isTranslating ? null : _translateText,
                icon: _isTranslating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.g_translate_rounded),
                label: Text(
                  _isTranslating
                      ? 'Translating & Speaking...'
                      : 'Translate & Speak',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[600],
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Output Area
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.indigo[100]!, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Translated Text:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[800],
                            fontSize: 14,
                          ),
                        ),
                        // Replay Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.volume_up_rounded,
                              color: Colors.indigo[700],
                            ),
                            onPressed: _speakText,
                            tooltip: "Replay Audio",
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          _translatedText,
                          style: TextStyle(
                            fontSize: 24,
                            height: 1.5,
                            color: Colors.blueGrey[900],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
