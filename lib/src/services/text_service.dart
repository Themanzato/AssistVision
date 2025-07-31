import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextService {
  final FlutterTts flutterTts = FlutterTts();
  final LanguageIdentifier languageIdentifier = GoogleMlKit.nlp.languageIdentifier();

  Future<void> configureVoice(String languageCode) async {
    // Configure the voice based on the language code
    await flutterTts.setLanguage(languageCode);
  }

  Future<String> detectLanguage(String text) async {
    final String languageCode = await languageIdentifier.identifyLanguage(text);
    return languageCode;
  }

  Future<void> speakText(String text, double speechRate, String languageCode) async {
    await flutterTts.setLanguage(languageCode);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
  }

  Future<String> translateText(String text, String targetLanguageCode) async {
    final GoogleTranslator translator = GoogleTranslator();
    final Translation translatedText = await translator.translate(text, to: targetLanguageCode);
    return translatedText.text;
  }
}