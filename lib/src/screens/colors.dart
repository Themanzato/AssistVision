import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ColorRecognitionScreen extends StatefulWidget {
  @override
  _ColorRecognitionScreenState createState() => _ColorRecognitionScreenState();
}

class _ColorRecognitionScreenState extends State<ColorRecognitionScreen> {
  CameraController? _cameraController;
  String _colorName = "Esperando color...";
  List<int> _rgbValues = [255, 255, 255];
  final FlutterTts _tts = FlutterTts();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Inicializa la cámara
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras.first, ResolutionPreset.high);
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  // Detecta el color y hace la solicitud al servidor
  Future<void> _detectColor() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessing) return;
    
    setState(() {
      _isProcessing = true; // Marca como procesando
    });

    try {
      final image = await _cameraController!.takePicture();
      final request = http.MultipartRequest(
        'POST',
        //Uri.parse('https://assistvisionapi.onrender.com/detect_color'), 
        Uri.parse('http://192.168.89.16:5001/colors'),  
      );
      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);
        setState(() {
          _colorName = data['color_name'];
          _rgbValues = List<int>.from(data['rgb_values']);
        });
        await _speakColor(_colorName);  // Anuncia el color detectado
      } else {
        setState(() {
          _colorName = "Error al detectar el color";
        });
      }
    } catch (e) {
        setState(() {
        _colorName = "Error al procesar la imagen";
      });

      // Solo decir "Procesando..." si hay un error en la captura
      await _tts.setLanguage("es-ES");
      await _tts.speak("Procesando...");
    } finally {
      setState(() {
        _isProcessing = false; // Marca como no procesando
      });
    }
  }

  // Función TTS para decir el nombre del color
  Future<void> _speakColor(String color) async {
    await _tts.setLanguage("es-ES");
    await _tts.speak("$color");
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Detector de Colores"),
        backgroundColor: Colors.black,
        toolbarTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Cambia el color del texto del AppBar
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Cambia el color del texto del AppBar
      ),
      body: Stack(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            Positioned.fill(
              child: Semantics(
                label: 'Vista previa de la cámara',
                child: AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            ),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent, width: 3),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  label: 'Nombre del color detectado',
                  child: Text(
                    "Color: $_colorName",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Semantics(
                  label: 'Valores RGB del color detectado',
                  child: Text(
                    "RGB: ${_rgbValues.join(', ')}",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                Semantics(
                  label: 'Botón para detectar color',
                  child: FloatingActionButton(
                    onPressed: _isProcessing ? null : _detectColor,
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    child: Icon(FontAwesomeIcons.eyeDropper, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}