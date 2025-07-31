import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:photo_view/photo_view.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'TextResultScreen.dart';
import 'camera_screen.dart';

class FaceDetectionScreen extends StatefulWidget {
  final File imageFile;

  const FaceDetectionScreen({super.key, required this.imageFile});

  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  late FlutterTts flutterTts;
  String faceDescription = "";
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
    detectFacesInImage();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> detectFacesInImage() async {
    final inputImage = InputImage.fromFile(widget.imageFile);
    final faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableTracking: true,
      ),
    );

    final List<Face> faces = await faceDetector.processImage(inputImage);
    await faceDetector.close();

    faces.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));

    faceDescription = _generateFaceDescription(faces);

    if (faces.isEmpty) {
      speakMessage(S.current!.WithoutFaces);
    } else {
      speakMessage(
          "${faces.length == 1 ? S.current!.TheyMet : '${S.current!.TheyMets} ${faces.length} ${S.current!.face4}'}. ${S.current!.PressContinue}.");
    }
  }

  String _describeLocation(Rect rect) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String horizontalPosition;
    String verticalPosition;

    // Descripción de la posición horizontal 
    if (rect.left < screenWidth * 0.2) {
      horizontalPosition = "en el lado izquierdo de la imagen";
    } else if (rect.right > screenWidth * 0.8) {
      horizontalPosition = "en el lado derecho de la imagen";
    } else if (rect.left > screenWidth * 0.4 &&
        rect.right < screenWidth * 0.6) {
      horizontalPosition = "en el centro de la imagen";
    } else if (rect.left > screenWidth * 0.3) {
      horizontalPosition = "ligeramente a la derecha";
    } else {
      horizontalPosition = "ligeramente a la izquierda";
    }

    // Descripción de la posición vertical 
    if (rect.top < screenHeight * 0.2) {
      verticalPosition = "en la parte superior de la imagen";
    } else if (rect.bottom > screenHeight * 0.8) {
      verticalPosition = "en la parte inferior de la imagen";
    } else if (rect.top > screenHeight * 0.4 &&
        rect.bottom < screenHeight * 0.6) {
      verticalPosition = "en el centro de la imagen";
    } else if (rect.top > screenHeight * 0.3) {
      verticalPosition = "ligeramente hacia abajo";
    } else {
      verticalPosition = "ligeramente hacia arriba";
    }

    return "$verticalPosition, $horizontalPosition";
  }

  String _generateFaceDescription(List<Face> faces) {
    String description =
        'Se ${faces.length == 1 ? 'encontró un rostro' : 'encontraron ${faces.length} rostros'}.\n';

    for (int i = 0; i < faces.length; i++) {
      final face = faces[i];
      final rect = face.boundingBox;
      final smilingProbability = face.smilingProbability;
      final leftEyeOpenProbability = face.leftEyeOpenProbability;
      final rightEyeOpenProbability = face.rightEyeOpenProbability;
      final headEulerAngleY = face.headEulerAngleY;
      final headEulerAngleZ = face.headEulerAngleZ;

      description += 'Rostro ${i + 1}: \n';
      description += 'Está ${_describeLocation(rect)}.\n';

      description += smilingProbability != null
          ? _describeSmile(smilingProbability)
          : 'No se pudo determinar si está sonriendo.\n';

      description +=
          _describeEyes(leftEyeOpenProbability, rightEyeOpenProbability);
      description += _describeHeadPosition(headEulerAngleY, headEulerAngleZ);

      if (faces.length > 1) {
        if (i == 0) {
          description += "Este es el rostro en el extremo izquierdo.\n";
        } else if (i == faces.length - 1) {
          description += "Este es el rostro en el extremo derecho.\n";
        } else {
          description += "Este rostro está entre los demás.\n";
        }
      }
      description += '\n';
    }

    return description;
  }

  String _describeSmile(double probability) {
    if (probability > 0.7) {
      return "Tiene una gran sonrisa.\n";
    } else if (probability > 0.3) {
      return "Tiene una sonrisa leve.\n";
    } else {
      return "No está sonriendo.\n";
    }
  }

  String _describeEyes(
      double? leftEyeOpenProbability, double? rightEyeOpenProbability) {
    if (leftEyeOpenProbability != null && rightEyeOpenProbability != null) {
      if (leftEyeOpenProbability > 0.5 && rightEyeOpenProbability > 0.5) {
        return "Ambos ojos están abiertos.\n";
      } else if (leftEyeOpenProbability > 0.5) {
        return "El ojo izquierdo está abierto y el derecho cerrado.\n";
      } else if (rightEyeOpenProbability > 0.5) {
        return "El ojo derecho está abierto y el izquierdo cerrado.\n";
      } else {
        return "Ambos ojos están cerrados.\n";
      }
    } else {
      return "No se pudo determinar el estado de los ojos.\n";
    }
  }

  String _describeHeadPosition(
      double? headEulerAngleY, double? headEulerAngleZ) {
    String description = '';
    if (headEulerAngleY != null) {
      if (headEulerAngleY > 10) {
        description += "La cabeza está girada hacia la derecha.\n";
      } else if (headEulerAngleY < -10) {
        description += "La cabeza está girada hacia la izquierda.\n";
      } else {
        description += "La cabeza está centrada.\n";
      }
    }
    if (headEulerAngleZ != null) {
      if (headEulerAngleZ > 10) {
        description += "La cabeza está inclinada hacia la derecha.\n";
      } else if (headEulerAngleZ < -10) {
        description += "La cabeza está inclinada hacia la izquierda.\n";
      } else {
        description += "La cabeza está recta.\n";
      }
    }
    return description;
  }

  Future<void> speakMessage(String message) async {
    setState(() {
      isSpeaking = true;
    });
    await flutterTts.setLanguage('es-US');
    await flutterTts.speak(message);
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
        iconTheme: const IconThemeData(color: Colors.white),
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
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                ),
                imageProvider: FileImage(widget.imageFile),
              ),
            ),
          ),
          const SizedBox(height: 23.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Semantics(
              label: 'Botón para continuar',
              child: ElevatedButton(
                onPressed: isSpeaking
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TextResultScreen(
                              extractedText: faceDescription,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF064b8d),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Semantics(
              label: 'Botón para cancelar',
              child: ElevatedButton(
                onPressed: isSpeaking
                    ? null
                    : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraScreen(),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.redAccent, 
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
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