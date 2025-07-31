import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';
import 'dart:convert';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> with WidgetsBindingObserver {
  late CameraController _cameraController;
  late FlutterTts flutterTts;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  String? detectedBill;  // Variable para almacenar el resultado del billete detectado

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.paused) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(cameras.first, ResolutionPreset.veryHigh);
      await _cameraController.initialize();
      await _cameraController.setFlashMode(FlashMode.off); // Asegurarse de que el flash esté apagado
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print("Error al inicializar la cámara: $e");
      _showErrorSnackBar("Error al inicializar la cámara");
    }
  }

  Future<void> _captureAndUploadImage() async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    try {
      await _cameraController.setFlashMode(FlashMode.off); // Asegurarse de que el flash esté apagado antes de tomar la foto
      final image = await _cameraController.takePicture();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.89.16:5000/billetes'),
        //Uri.parse('https://assistvisionapi.onrender.com/predict'),
      );

      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        String result = data[0]['label'];
        detectedBill = result;

        await flutterTts.speak("$result");

        if (mounted) {
          setState(() {});
        }
      } else {
        print('Error al enviar la imagen: ${response.statusCode}');
      }
    } catch (e) {
      print("Error en la captura o procesamiento de la imagen: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
        title: Text("Reconocimiento de Billetes"),
        backgroundColor: Colors.black,
        toolbarTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Cambia el color del texto del AppBar
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Cambia el color del texto del AppBar
      ),      body: _isCameraInitialized
          ? Stack(
              children: [
                Semantics(
                  label: 'Vista previa de la cámara',
                  child: CameraPreview(_cameraController),
                ),
                if (detectedBill != null)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.black54,
                      child: Semantics(
                        label: 'Billete detectado: $detectedBill',
                        child: Text(
                          'Billete detectado: $detectedBill',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Semantics(
                      label: 'Botón para tomar una foto',
                      child: FloatingActionButton(
                        onPressed: _isProcessing ? null : _captureAndUploadImage,
                        child: Icon(Icons.attach_money),
                        backgroundColor: _isProcessing ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}