import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_application_1/src/services/text_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';

class TextResultScreen extends StatefulWidget {
  final String extractedText;
  const TextResultScreen({super.key, required this.extractedText});

  @override
  _TextResultScreenState createState() => _TextResultScreenState();
}

class _TextResultScreenState extends State<TextResultScreen> {
  final TextService textService = TextService();
  final ValueNotifier<bool> isSpeaking = ValueNotifier(false);
  final ValueNotifier<bool> isPaused = ValueNotifier(false);
  late TextEditingController _textEditingController;
  late Future<void> _settingsLoaded;

  double textSize = 16.0;
  double lineHeight = 1.5;
  TextAlign textAlign = TextAlign.justify;
  Color textColor = Colors.black;
  Color backgroundColor = Colors.transparent;
  double speechRate = 0.5;
  bool showOriginalText = true;
  String detectedLanguage = 'en, es, fr, it, de, ru';
  String translatedText = '';
  String targetLanguage = 'es, en, fr, it, de, ru';

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.extractedText);
    _settingsLoaded = _loadTextResultSettings();
    _detectLanguageAndSpeak();
    textService.flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
    });
  }

  @override
  void dispose() {
    textService.stopSpeaking();
    _saveTextResultSettings();
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _loadTextResultSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      textSize = prefs.getDouble('textSize') ?? 16.0;
      lineHeight = prefs.getDouble('lineHeight') ?? 1.5;
      textAlign = TextAlign.values[prefs.getInt('textAlign') ?? TextAlign.justify.index];
      textColor = Color(prefs.getInt('textColor') ?? Colors.black.value);
      backgroundColor = Color(prefs.getInt('backgroundColor') ?? Colors.transparent.value);
      speechRate = prefs.getDouble('speechRate') ?? 0.5;
      showOriginalText = prefs.getBool('showOriginalText') ?? true;
    });
  }

  Future<void> _saveTextResultSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textSize', textSize);
    await prefs.setDouble('lineHeight', lineHeight);
    await prefs.setInt('textAlign', textAlign.index);
    await prefs.setInt('textColor', textColor.value);
    await prefs.setInt('backgroundColor', backgroundColor.value);
    await prefs.setDouble('speechRate', speechRate);
    await prefs.setBool('showOriginalText', showOriginalText);
  }

  Future<void> _detectLanguageAndSpeak() async {
    detectedLanguage = await textService.detectLanguage(_textEditingController.text);
    setState(() {});
    await speakText();
  }

  Future<void> speakText() async {
    if (isSpeaking.value) {
      await textService.stopSpeaking();
      isSpeaking.value = false;
      isPaused.value = true;
    } else if (isPaused.value) {
      isSpeaking.value = true;
      isPaused.value = false;
      await textService.speakText(
        translatedText.isEmpty ? _textEditingController.text : translatedText,
        speechRate,
        detectedLanguage,
      );
    } else {
      isSpeaking.value = true;
      isPaused.value = false;
      await textService.speakText(
        translatedText.isEmpty ? _textEditingController.text : translatedText,
        speechRate,
        detectedLanguage,
      );
    }
  }

  void restartSpeaking() {
    isPaused.value = false;
    isSpeaking.value = true;
    textService.speakText(
      translatedText.isEmpty ? _textEditingController.text : translatedText,
      speechRate,
      detectedLanguage,
    );
  }

  Future<void> _translateText(String toLanguage) async {
    translatedText = await textService.translateText(_textEditingController.text, toLanguage);
    setState(() {
      targetLanguage = toLanguage;
    });
    // Detect the language of the translated text
    detectedLanguage = await textService.detectLanguage(translatedText);
  }

  void _showTranslationOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Traducir a:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: [
                  _buildTranslationButton('es', 'Español'),
                  _buildTranslationButton('en', 'Inglés'),
                  _buildTranslationButton('fr', 'Francés'),
                  _buildTranslationButton('it', 'Italiano'),
                  _buildTranslationButton('de', 'Alemán'),
                  _buildTranslationButton('ru', 'Ruso'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTranslationButton(String languageCode, String languageName) {
    return ElevatedButton(
      onPressed: () {
        _translateText(languageCode);
        Navigator.of(context).pop();
      },
      child: Text(languageName),
    );
  }

  void _updateSpeechRate() {
    setState(() {
      speechRate = (speechRate >= 2.0) ? 0.5 : speechRate + 0.1;
      _saveTextResultSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assist Vision',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF064b8d),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    textSize: textSize,
                    lineHeight: lineHeight,
                    textAlign: textAlign,
                    textColor: textColor,
                    backgroundColor: backgroundColor,
                    speechRate: speechRate,
                    showOriginalText: showOriginalText,
                    onSettingsChanged: (settings) {
                      setState(() {
                        textSize = settings['textSize'];
                        lineHeight = settings['lineHeight'];
                        textAlign = settings['textAlign'];
                        textColor = settings['textColor'];
                        backgroundColor = settings['backgroundColor'];
                        speechRate = settings['speechRate'];
                        showOriginalText = settings['showOriginalText'];
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _settingsLoaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      translatedText.isEmpty ? _textEditingController.text : translatedText,
                      style: TextStyle(
                        fontSize: textSize,
                        height: lineHeight,
                        color: textColor,
                      ),
                      textAlign: textAlign,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: isSpeaking,
                builder: (context, value, child) {
                  return IconButton(
                    onPressed: speakText,
                    icon: Column(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: value
                              ? Icon(
                                  Icons.pause,
                                  key: UniqueKey(),
                                )
                              : Icon(
                                  Icons.play_arrow,
                                  key: UniqueKey(),
                                ),
                        ),
                        Text(
                          value ? S.current!.Pause : S.current!.Play,
                          style: const TextStyle(color: Colors.black, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: restartSpeaking,
                icon: Column(
                  children: [
                    const Icon(Icons.replay),
                    Text(
                      S.current!.Reboot,
                      style: const TextStyle(color: Colors.black, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _updateSpeechRate,
                icon: Column(
                  children: [
                    const Icon(Icons.speed),
                    Text(
                      'x${speechRate.toStringAsFixed(1)}',
                      style: const TextStyle(color: Colors.black, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _showTranslationOptions,
                icon: Column(
                  children: [
                    const Icon(Icons.translate),
                    Text(
                      'Traducir',
                      style: const TextStyle(color: Colors.black, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}