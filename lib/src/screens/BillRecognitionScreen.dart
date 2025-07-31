import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:light/light.dart';
import 'dart:async';
import 'dart:io';

class BillRecognitionFromCamera extends StatefulWidget {
  @override
  _BillRecognitionFromCameraState createState() => _BillRecognitionFromCameraState();
}

class _BillRecognitionFromCameraState extends State<BillRecognitionFromCamera> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isModelLoaded = false;
  bool _isFlashOn = false;
  String _resultText = "No se ha tomado ninguna foto.";
  final ResolutionPreset _currentResolutionPreset = ResolutionPreset.ultraHigh;
  double _aspectRatio = 1.2 / 2.1;
  StreamSubscription<int>? _lightSubscription;
  final int _luxThreshold = 30;
  final int _numReadings = 3;
  List<int> _luxReadings = [];
  
  final Map<String, String> _labelMap = {
   "Billetes_20pesos_n": "Billete de 20 pesos nuevo",
    "Billetes_20pesos_v": "Billete de 20 pesos viejo",
    "Billetes_50pesos_n": "Billete de 50 pesos nuevo",
    "Billetes_100pesos_v": "Billete de 100 pesos viejo",

  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _initializeLightSensor();
    _loadModel();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    Tflite.close();
    _lightSubscription?.cancel();
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
      setState(() {
        _isCameraInitialized = true;
      });
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

  Future<void> _loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
      );
      setState(() {
        _isModelLoaded = true;
      });
    } catch (e) {
      setState(() {
        _resultText = 'Error al cargar el modelo: $e';
      });
    }
  }

  Future<void> _takePhoto() async {
    if (!_cameraController!.value.isInitialized) return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      _recognizeImage(photo.path);
    } catch (e) {
      setState(() {
        _resultText = 'Error al tomar la foto: $e';
      });
    }
  }

  Future<void> _recognizeImage(String imagePath) async {
    if (!_isModelLoaded) {
      setState(() {
        _resultText = "El modelo no está cargado.";
      });
      return;
    }

    var recognitions = await Tflite.runModelOnImage(
      path: imagePath,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 1,
      threshold: 0.85,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      setState(() {
        var recognition = recognitions[0];
        String label = recognition['label'];
        String friendlyLabel = _labelMap[label] ?? label;
        _resultText = "Billete detectado: $friendlyLabel\n"
                      "Confianza: ${(recognition['confidence'] * 100).toStringAsFixed(2)}%";
      });
    } else {
      setState(() {
        _resultText = "No se detectó ningún billete.";
      });
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
    } catch (e) {
      print("Error al cambiar la cámara: $e");
      _showErrorSnackBar("Error al cambiar la cámara");
    }
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        title: Text('Reconocimiento de Billetes', style: const TextStyle(color: Colors.white, fontSize: 20)),
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
                            label: 'Botón para cambiar de cámara',
                            child: IconButton(
                              icon: const Icon(Icons.switch_camera, color: Colors.white, size: 30),
                              onPressed: _switchCamera,
                              tooltip: 'Cambiar cámara',
                            ),
                          ),
                          Semantics(
                            label: 'Botón para tomar una foto',
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, color: Colors.white, size: 30),
                              onPressed: _takePhoto,
                              tooltip: 'Tomar foto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        _resultText,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
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