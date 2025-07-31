import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences prefs;
  final FlutterTts flutterTts = FlutterTts();
  
  List<String> accents = ['es-US', 'es-ES'];  
  String? _selectedAccent;
  double _volume = 3;
  double _speed = 3;
  Locale _locale = const Locale('es');  

  SettingsProvider(this.prefs) {
    _loadSettings();
  }

  String? get selectedAccent => _selectedAccent;
  double get volume => _volume;
  double get speed => _speed;
  Locale get locale => _locale;

  Future<void> _loadSettings() async {
    _volume = prefs.getDouble('volume') ?? 3;
    _speed = prefs.getDouble('speed') ?? 3;
    _selectedAccent = prefs.getString('accent') ?? accents.first;
    String? languageCode = prefs.getString('language_code');
    _locale = Locale(languageCode ?? 'es');

    await flutterTts.setVolume(_volume / 5);
    await flutterTts.setSpeechRate(_speed / 5);
    await flutterTts.setVoice({"name": _selectedAccent!});

    notifyListeners();
  }

  Future<void> _saveSettings() async {
    await prefs.setDouble('volume', _volume);
    await prefs.setDouble('speed', _speed);
    await prefs.setString('accent', _selectedAccent!);
    await prefs.setString('language_code', _locale.languageCode);
  }

  void setVolume(double value) {
    _volume = value;
    flutterTts.setVolume(_volume / 5);
    _saveSettings();
    notifyListeners();
  }

  void setSpeed(double value) {
    _speed = value;
    flutterTts.setSpeechRate(_speed / 5);
    _saveSettings();
    notifyListeners();
  }

  void setAccent(String accent) {
    _selectedAccent = accent;
    flutterTts.setVoice({"name": accent});
    _saveSettings();
    notifyListeners();
  }

  void setLocale(String languageCode) {
    _locale = Locale(languageCode);
    _saveSettings();
    notifyListeners();
  }
}