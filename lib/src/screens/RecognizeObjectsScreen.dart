import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'TextResultScreen.dart';

class ObjectRecognitionScreen extends StatefulWidget {
  final File imageFile;

  const ObjectRecognitionScreen({super.key, required this.imageFile});

  @override
  _ObjectRecognitionScreenState createState() => _ObjectRecognitionScreenState();
}

class _ObjectRecognitionScreenState extends State<ObjectRecognitionScreen> {
  late FlutterTts flutterTts;
  String objectDescription = "";
  bool isSpeaking = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    detectObjectsInImage();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> detectObjectsInImage() async {
    try {
      final inputImage = InputImage.fromFile(widget.imageFile);
      final imageLabeler = GoogleMlKit.vision.imageLabeler();
      final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
      await imageLabeler.close();

      if (labels.isEmpty) {
        speakMessage("No se detectaron objetos. Inténtalo de nuevo.");
      } else {
        objectDescription = await _generateTranslatedObjectDescription(labels);
        speakMessage("Se detectaron los siguientes objetos: $objectDescription. Presiona continuar.");
      }
    } catch (e) {
      speakMessage("Ocurrió un error al procesar la imagen. Inténtalo de nuevo.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> _generateTranslatedObjectDescription(List<ImageLabel> labels) async {
    String description = '';
    List<String> detectedObjects = [];

    for (var label in labels) {
      if (label.confidence >= 0.6) {  
        String translatedLabel = await _translateText(label.label, 'en', 'es');  
        detectedObjects.add('$translatedLabel con una confianza de ${(label.confidence * 100).toStringAsFixed(2)}%');
      }
    }

    if (detectedObjects.isEmpty) {
      return "No se detectaron objetos con suficiente confianza.";
    }

    if (detectedObjects.length == 1) {
      description = "Parece que hay un ${detectedObjects[0]} en la imagen.";
    } else {
      description = "Parece que hay varios objetos en la imagen. Estos son: ";
      for (int i = 0; i < detectedObjects.length; i++) {
        if (i == detectedObjects.length - 1) {
          description += "y un ${detectedObjects[i]}.";
        } else {
          description += "${detectedObjects[i]}, ";
        }
      }
    }

    return description;
  }

  Future<String> _translateText(String text, String fromLang, String toLang) async {
    final onDeviceTranslator = GoogleMlKit.nlp.onDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.spanish,
    );
    String translatedText = await onDeviceTranslator.translateText(text);
    await onDeviceTranslator.close();  
    return translatedText;
  }

  Future<void> speakMessage(String message) async {
    if (isSpeaking) {
      await flutterTts.stop();
    }
    setState(() {
      isSpeaking = true;
    });
    await flutterTts.setLanguage('es-US');
    await flutterTts.setSpeechRate(0.5);  
    await flutterTts.speak(message);
    setState(() {
      isSpeaking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reconocimiento de Objetos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: PhotoView(
                backgroundDecoration: const BoxDecoration(
                  color: Colors.white,
                ),
                imageProvider: FileImage(widget.imageFile),
              ),
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () async {
                      flutterTts.stop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TextResultScreen(extractedText: objectDescription),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 72.0, vertical: 10.0),
                        child: Text(
                          'Continuar',
                          style: TextStyle(fontSize: 20, color: Colors.white),
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
