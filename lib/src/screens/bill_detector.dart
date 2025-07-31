import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BillDetector {
  Interpreter? _interpreter;
  FlutterTts _flutterTts = FlutterTts();

  BillDetector() {
    _loadModel();
  }

  // Carga el modelo de TensorFlow Lite
  void _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/billete_model.tflite');
      print("Modelo cargado exitosamente");
    } catch (e) {
      print("Error al cargar el modelo: $e");
    }
  }

  Uint8List preprocessImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;

    // Crear una imagen RGB vacía con dimensiones especificadas
    img.Image rgbImage = img.Image(width: width, height: height);

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex = image.planes[1].bytesPerRow * (y ~/ 2) + (x ~/ 2) * 2;
        final int yValue = image.planes[0].bytes[y * image.planes[0].bytesPerRow + x];
        final int uValue = image.planes[1].bytes[uvIndex];
        final int vValue = image.planes[2].bytes[uvIndex];

        int r = (yValue + 1.370705 * (vValue - 128)).toInt().clamp(0, 255);
        int g = (yValue - 0.337633 * (uValue - 128) - 0.698001 * (vValue - 128)).toInt().clamp(0, 255);
        int b = (yValue + 1.732446 * (uValue - 128)).toInt().clamp(0, 255);

        // Configurar el píxel manualmente usando ARGB directo
        rgbImage.setPixelRgba(x, y, r, g, b, 255);
      }
    }

    final img.Image resizedImage = img.copyResize(rgbImage, width: 150, height: 150);

    return Uint8List.fromList(img.encodeJpg(resizedImage));
  }

  int runModel(Uint8List input) {
    var output = List.filled(6, 0).reshape([1, 6]); // Asume 6 clases (20, 50, 100, 200, 500, 1000)
    _interpreter?.run(input, output);
    int classIndex = output[0].indexWhere((element) => element == output[0].reduce((a, b) => a > b ? a : b));
    return classIndex;
  }

  // Retorna el nombre de la denominación según el índice de clase
  String getDenomination(int classIndex) {
    switch (classIndex) {
      case 0:
        return "20";
      case 1:
        return "50";
      case 2:
        return "100";
      case 3:
        return "200";
      case 4:
        return "500";
      case 5:
        return "1000";
      default:
        return "Desconocido";
    }
  }

  void close() {
    _interpreter?.close();
    _flutterTts.stop();
  }
}
