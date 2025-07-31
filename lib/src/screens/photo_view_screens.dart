import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_application_1/src/screens/TextResultScreen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_application_1/src/screens/camera_screen.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';

class PhotoViewScreen extends StatefulWidget {
  const PhotoViewScreen({super.key, required this.imageFile});
  final File imageFile;

  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  late FlutterTts flutterTts;
  String extractedText = "";
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    extractTextFromImage();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> extractTextFromImage() async {
    try {
      final inputImage = InputImage.fromFile(widget.imageFile);
      final textDetector = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognizedText = await textDetector.processImage(inputImage);

      StringBuffer buffer = StringBuffer();

      List<TextBlock> sortedBlocks = recognizedText.blocks..sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

      for (TextBlock block in sortedBlocks) {
        for (TextLine line in block.lines) {
          buffer.write('${line.text} ');
        }
        buffer.writeln(); // Añadir un salto de línea entre bloques para crear párrafos
      }

      extractedText = buffer.toString().trim(); 

      await textDetector.close();

      await applySettings();

      if (extractedText.isEmpty) {
        await speakMessage(S.current!.PhotoViewNoImage);
      } else {
        await speakMessage(S.current!.PhotoViewYesImage);
      }
    } catch (e) {
      _showErrorSnackBar('Error extracting text from image: $e');
    }
  }

  Future<void> applySettings() async {
    try {
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      
      await flutterTts.setLanguage(settingsProvider.selectedAccent ?? 'es-US');
      await flutterTts.setVolume(settingsProvider.volume / 5); 
      await flutterTts.setSpeechRate(settingsProvider.speed / 5); 
    } catch (e) {
      _showErrorSnackBar('Error applying TTS settings: $e');
    }
  }

  Future<void> speakMessage(String message) async {
    try {
      await flutterTts.setLanguage('es-US');
      await flutterTts.setPitch(1.0);
      if (await flutterTts.isLanguageAvailable('es-US')) {
        await flutterTts.speak(message);
      }
    } catch (e) {
      _showErrorSnackBar('Error speaking message: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assist Vision',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF064b8d),
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 255, 255, 255)), 
        actions: const [],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color.fromRGBO(255, 255, 255, 1), 
              width: MediaQuery.of(context).size.width, 
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: const Color.fromRGBO(195, 195, 195, 1).withOpacity(0.1),), 
                imageProvider: FileImage(widget.imageFile),
              ),
            ),
          ), 
          const SizedBox(height: 23.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: GestureDetector(
              onTap: () async {
                flutterTts.stop(); 
                if (extractedText.isNotEmpty) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TextResultScreen(extractedText: extractedText),
                    ),
                  );
                } else {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraScreen(),  
                    ),      
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF064b8d), 
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 72.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.campaign_outlined, size: 60, color: Color.fromARGB(255, 255, 255, 255)), 
                      const SizedBox(width: 10),
                      Text(
                        S.current!.PhotoViewBtnContinue,
                        style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)), 
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}