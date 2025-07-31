import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:light/light.dart';
import 'dart:io';
import 'dart:async';

class CameraService {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool isFlashOn = false;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  int _selectedCameraIndex = 0;
  StreamSubscription<int>? _lightSubscription;
  final int _luxThreshold = 30; // Umbral de luz en lux para activar el flash
  final int _numReadings = 3; // Número de lecturas a promediar
  List<int> _luxReadings = [];
  String _errorMessage = '';

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(
        cameras![_selectedCameraIndex],
        ResolutionPreset.max,
        enableAudio: false,
      );
      await _controller!.initialize();
      _minAvailableZoom = await _controller!.getMinZoomLevel();
      _maxAvailableZoom = await _controller!.getMaxZoomLevel();
    }
  }

  CameraController? get controller => _controller;

  double get currentZoomLevel => _currentZoomLevel;

  Future<void> toggleFlash() async {
    if (_controller != null) {
      isFlashOn = !isFlashOn;
      await _controller!.setFlashMode(isFlashOn ? FlashMode.torch : FlashMode.off);
    }
  }

  Future<void> switchCamera() async {
    if (cameras != null && cameras!.length > 1) {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras!.length;
      await initializeCamera();
    }
  }

  Future<XFile?> takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      if (isFlashOn) await _controller!.setFlashMode(FlashMode.torch);
      await Future.delayed(const Duration(milliseconds: 800));
      await _controller!.setFocusMode(FocusMode.auto);
      await _controller!.setExposureMode(ExposureMode.auto);
      final XFile picture = await _controller!.takePicture();
      if (isFlashOn) await _controller!.setFlashMode(FlashMode.off);
      return picture;
    }
    return null;
  }

  Future<String?> scanQRFromImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
    final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

    if (barcodes.isNotEmpty) {
      return barcodes.first.displayValue;
    }
    return null;
  }

  void initializeLightSensor() {
    Light light = Light();
    try {
      _lightSubscription = light.lightSensorStream.listen((lux) {
        if (lux >= 0 && lux <= 10000) { // Filtro para lecturas extremas
          _processLightLevel(lux);
        }
      });
    } on LightException catch (e) {
      _errorMessage = "Error al inicializar el sensor de luz: $e";
      print('Error: $e');
    }
  }

  void _processLightLevel(int lux) {
    try {
      // Añadir la nueva lectura y mantener el tamaño de la lista
      if (_luxReadings.length >= _numReadings) {
        _luxReadings.removeAt(0);
      }
      _luxReadings.add(lux);

      // Calcular el promedio de las lecturas
      double averageLux = _luxReadings.reduce((a, b) => a + b) / _luxReadings.length;

      isFlashOn = averageLux < _luxThreshold; // Activar el flash si el nivel promedio de luz es bajo
      _setFlashMode();
    } catch (e) {
      _errorMessage = "Error al procesar el nivel de luz: $e";
      print("Error al procesar el nivel de luz: $e");
    }
  }

  Future<void> _setFlashMode() async {
    if (_controller != null) {
      try {
        if (isFlashOn) {
          await _controller!.setFlashMode(FlashMode.torch);
        } else {
          await _controller!.setFlashMode(FlashMode.off);
        }
      } catch (e) {
        _errorMessage = "Error al cambiar el modo de flash: $e";
        print("Error al cambiar el modo de flash: $e");
      }
    }
  }

  void dispose() {
    _lightSubscription?.cancel();
    _controller?.dispose();
  }

  void stopLightSensor() {
    _lightSubscription?.cancel();
    _lightSubscription = null;
  }
}