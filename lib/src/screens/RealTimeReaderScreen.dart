import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:light/light.dart';
import 'dart:typed_data';
import 'dart:async';

class RealTimeTextReaderScreen extends StatefulWidget {
  @override
  _RealTimeTextReaderScreenState createState() => _RealTimeTextReaderScreenState();
}

class _RealTimeTextReaderScreenState extends State<RealTimeTextReaderScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();
  FlutterTts flutterTts = FlutterTts();
  bool _isProcessing = false;
  bool _isSpeaking = false;
  final int _initialProcessingDelay = 1500; // Retraso inicial (milisegundos) entre procesamientos
  List<String> _readTexts = [];
  bool _isFlashOn = false;
  int _currentProcessingDelay = 1500; // Valor de retraso dinámico basado en el entorno
  String _lastReadText = "";
  final ResolutionPreset _currentResolutionPreset = ResolutionPreset.ultraHigh; 
  double _aspectRatio = 1.2 / 2.1; 
  StreamSubscription<int>? _lightSubscription;
  final int _luxThreshold = 30;
  final int _numReadings = 3; 
  List<int> _luxReadings = [];

  String convertAbbreviation(String text) {
    String lowercaseText = text.toLowerCase(); 
    if (_abbreviationDictionary.containsKey(lowercaseText)) {
      return _abbreviationDictionary[lowercaseText]!;
    }
    return text; 
  }

  final Map<String, String> _abbreviationDictionary = {
    "mg": "miligramos",
    "kg": "kilogramos",
    "g": "gramos",
    "ml": "mililitros",
    "l": "litros",
    "cm": "centímetros",
    "mm": "milímetros",
    "m": "metros",
    "km": "kilómetros",
    "m2": "metros cuadrados",
    "m3": "metros cúbicos",
    "km2": "kilómetros cuadrados",
    "km3": "kilómetros cúbicos",
    "ha": "hectáreas",
    "gb": "gigabytes",
    "mb": "megabytes",
    "kb": "kilobytes",
    "tb": "terabytes"
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _initializeLightSensor();
    _configureTTS();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _textRecognizer.close();
    _cameraController?.dispose();
    flutterTts.stop();
    _lightSubscription?.cancel();
    _isFlashOn = false;
    _setFlashMode(); 
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    if (state == AppLifecycleState.paused) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(cameras.first, _currentResolutionPreset);
      await _cameraController!.initialize();
      await _cameraController!.setZoomLevel(1); 
      setState(() {});
      _startTextRecognition();
    } catch (e) {
      print("Error al inicializar la cámara: $e");
      _showErrorSnackBar("Error al inicializar la cámara");
    }
  }

  void _initializeLightSensor() {
    Light light = Light();
    try {
      _lightSubscription = light.lightSensorStream.listen((lux) {
        if (lux >= 0 && lux <= 10000) { 
          _processLightLevel(lux);
        }
      });
    } on LightException catch (e) {
      print('Error: $e');
    }
  }

  void _processLightLevel(int lux) {
    try {
      
      if (_luxReadings.length >= _numReadings) {
        _luxReadings.removeAt(0);
      }
      _luxReadings.add(lux);

      double averageLux = _luxReadings.reduce((a, b) => a + b) / _luxReadings.length;

      setState(() {
        _isFlashOn = averageLux < _luxThreshold; 
      });
      _setFlashMode();
    } catch (e) {
      print("Error al procesar el nivel de luz: $e");
    }
  }

  Future<void> _setFlashMode() async {
    if (_cameraController != null) {
      try {
        if (_isFlashOn) {
          await _cameraController!.setFlashMode(FlashMode.torch);
        } else {
          await _cameraController!.setFlashMode(FlashMode.off);
        }
      } catch (e) {
        print("Error al cambiar el modo de flash: $e");
      }
    }
  }

  void _configureTTS() {
    flutterTts.setLanguage("es-US");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  void _startTextRecognition() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (_isProcessing || _isSpeaking) return;
      _isProcessing = true;
      final inputImage = _convertCameraImageToInputImage(image);
      try {
        final recognizedText = await _textRecognizer.processImage(inputImage);

        if (recognizedText.text.isNotEmpty) {
          final newText = _expandAbbreviations(recognizedText.text);
          if (newText != _lastReadText) {
            _lastReadText = newText;
            _isSpeaking = true;
            await flutterTts.speak(newText);
          }
        }
      } catch (e) {
        print("Error al procesar la imagen: $e");
        _showErrorSnackBar("Error al procesar la imagen");
      } finally {
        await Future.delayed(Duration(milliseconds: _currentProcessingDelay));
        _isProcessing = false;
      }
    });
  }

  InputImage _convertCameraImageToInputImage(CameraImage image) {
    final bytes = image.planes.fold<Uint8List>(
      Uint8List(0),
      (Uint8List previousValue, Plane plane) => Uint8List.fromList(previousValue + plane.bytes),
    );
    final InputImageMetadata metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotation.rotation0deg,
      bytesPerRow: image.planes[0].bytesPerRow,
      format: InputImageFormat.nv21,
    );
    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;
    try {
      _isFlashOn = !_isFlashOn;
      await _cameraController!.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
      setState(() {});
      await flutterTts.speak(_isFlashOn ? "Flash activado" : "Flash desactivado");
    } catch (e) {
      print("Error al cambiar el flash: $e");
      _showErrorSnackBar("Error al cambiar el flash");
    }
  }

  Future<void> _switchCamera() async {
    if (_cameraController == null) return;
    try {
      final cameras = await availableCameras();
      final lensDirection = _cameraController!.description.lensDirection;
      CameraDescription newDescription;
      if (lensDirection == CameraLensDirection.front) {
        newDescription = cameras.firstWhere((description) => description.lensDirection == CameraLensDirection.back);
      } else {
        newDescription = cameras.firstWhere((description) => description.lensDirection == CameraLensDirection.front);
      }
      _cameraController = CameraController(newDescription, _currentResolutionPreset);
      await _cameraController!.initialize();
      await _cameraController!.setZoomLevel(1);
      setState(() {});
      _startTextRecognition();
    } catch (e) {
      print("Error al cambiar la cámara: $e");
      _showErrorSnackBar("Error al cambiar la cámara");
    }
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _stopSpeaking() async {
    await flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  String _expandAbbreviations(String text) {
    _abbreviationDictionary.forEach((abbreviation, fullForm) {
      text = text.replaceAll(RegExp(r'\b' + abbreviation + r'\b'), fullForm);
    });
    return text;
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Lector de Texto', style: const TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _cameraController != null && _cameraController!.value.isInitialized
          ? GestureDetector(
              onScaleUpdate: (details) {
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: AspectRatio(
                        aspectRatio: _aspectRatio, 
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Semantics(
                            label: 'Botón para activar y desactivar flash',
                            child: IconButton(
                              icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
                              onPressed: _toggleFlash,
                              tooltip: 'Activar/Desactivar flash',
                            ),
                          ),
                          Semantics(
                            label: 'Botón para detener la lectura',
                            child: IconButton(
                              icon: Icon(Icons.stop, color: Colors.white, size: 30),
                              onPressed: _stopSpeaking,
                              tooltip: 'Detener lectura',
                            ),
                          ),
                          Semantics(
                            label: 'Botón para cambiar de cámara',
                            child: IconButton(
                              icon: const Icon(Icons.switch_camera, color: Colors.white, size: 30),
                              onPressed: _switchCamera,
                              tooltip: 'Cambiar cámara',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}