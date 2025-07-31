import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/screens/CustomPainter.dart';
import 'package:flutter_application_1/src/screens/CustomPainterRed.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';
import 'face_detection_screen.dart';
import 'RecognizeObjectsScreen.dart';
import 'photo_view_screens.dart';
import 'TextResultScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr;
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_1/src/services/CameraService.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../generated/l10n.dart';
import 'dart:typed_data';

class CameraScreen extends StatefulWidget {
  final bool isFaceDetectionMode;
  final bool isObjectRecognitionMode;
  final bool isQRScanMode;
  final bool isDocumentMode;

  const CameraScreen({
    super.key,
    this.isFaceDetectionMode = false,
    this.isObjectRecognitionMode = false,
    this.isQRScanMode = false,
    this.isDocumentMode = false,
  });

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  final CameraService _cameraService = CameraService();
  bool isCameraInitialized = false;
  final ImagePicker _imagePicker = ImagePicker();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  qr.QRViewController? qrController;
  qr.Barcode? result;
  double _aspectRatio = 1.2 / 2.1; // Tamaño de aspecto establecido a 1.2:2.1
  final ObjectDetector _objectDetector = ObjectDetector(
    options: ObjectDetectorOptions(
      mode: DetectionMode.stream,
      classifyObjects: false,
      multipleObjects: false,
    ),
  );
  FlutterTts flutterTts = FlutterTts();
  String _errorMessage = '';
  bool _isProcessingText = false;
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  List<TextBlock> detectedTextBlocks = [];
  late Rect documentMargin;
  bool _isSpeaking = false;
  String previousInstructions = '';
  double previousMoveLeft = 0.0;
  double previousMoveRight = 0.0;
  double previousMoveTop = 0.0;
  double previousMoveBottom = 0.0;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _cameraService.initializeLightSensor();
    _configureTTS();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    documentMargin = getDocumentMargin(context);
  }

  Rect getDocumentMargin(BuildContext context) {
    // Obtener las dimensiones de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    // Definir los márgenes dinámicos en función de la pantalla
    double leftMargin = screenWidth * 0.05;
    double topMargin = screenHeight * 0.05;
    double rightMargin = screenWidth * 0.95;
    double bottomMargin = screenHeight * 0.70;
    
    return Rect.fromLTRB(
      leftMargin,
      topMargin,
      rightMargin,
      bottomMargin,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraService.stopLightSensor(); // Detener el sensor de luz
    _cameraService.dispose();
    qrController?.dispose();
    _objectDetector.close();
    flutterTts.stop();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraService.controller == null || !_cameraService.controller!.value.isInitialized) return;
    if (state == AppLifecycleState.paused) {
      _cameraService.controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _isTakingPicture = false;
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initializeCamera();
      if (mounted) {
        setState(() {
          isCameraInitialized = true;
        });
      }

      // Aquí empieza el stream de imágenes y pasa cada imagen a `_processText`
      _cameraService.controller?.startImageStream((CameraImage image) {
        if (mounted && widget.isDocumentMode && !_isProcessingText) {
          _processText(image); // Llama a la función que procesa el texto.
        }
      });

    } catch (e) {
      _showErrorSnackBar('Error initializing camera: $e');
    }
  }

  void _configureTTS() {
    flutterTts.setLanguage("es-ES");
    flutterTts.setSpeechRate(0.5);
  }

  Future<void> _processText(CameraImage cameraImage) async {
    if (_isProcessingText) return;

    _isProcessingText = true;
    try {
      final inputImage = _convertCameraImageToInputImage(cameraImage);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      if (recognizedText.blocks.isNotEmpty) {
        String instructions = '';
        bool isTextInMargin = true;
        bool shouldTakePicture = false;
        setState(() {
          detectedTextBlocks = recognizedText.blocks;
        });
        
        for (final block in recognizedText.blocks) {
          var blockRect = block.boundingBox;
          // Verificar si el texto está dentro del margen amarillo
          if (!documentMargin.contains(Offset(blockRect.left, blockRect.top)) ||
              !documentMargin.contains(Offset(blockRect.right, blockRect.bottom))) {
                isTextInMargin = false;

                // Agregar instrucciones basadas en la dirección en la que se encuentra el texto
                double moveLeft = documentMargin.left - blockRect.left;
                double moveRight = blockRect.right - documentMargin.right;
                double moveTop = documentMargin.top - blockRect.top;
                double moveBottom = blockRect.bottom - documentMargin.bottom;

                // Crear instrucciones detalladas basadas en la posición del texto
                if (moveLeft > 0 && moveLeft != previousMoveLeft) {
                  instructions += "Mueve hacia la izquierda"; // Cambié de "derecha" a "izquierda"
                  previousMoveLeft = moveLeft; // Guardar el último ajuste
                } 
                if (moveRight > 0 && moveRight != previousMoveRight) {
                  instructions += "Mueve hacia la derecha"; // Esta estaba correcta
                  previousMoveRight = moveRight; // Guardar el último ajuste
                }
                if (moveTop > 0 && moveTop != previousMoveTop) {
                  instructions += "Mueve hacia arriba"; // Cambié de "abajo" a "arriba"
                  previousMoveTop = moveTop; // Guardar el último ajuste
                }
                if (moveBottom > 0 && moveBottom != previousMoveBottom) {
                  instructions += "Mueve hacia abajo"; // Esta estaba correcta
                  previousMoveBottom = moveBottom; // Guardar el último ajuste
                }
                break;
              } else {
                if (instructions.isEmpty) {
                  shouldTakePicture = true;  // El texto está centrado, tomar foto
                }
              }
              _handleZoom(block.boundingBox.width);
        }

        // Si no hay instrucciones, es decir, el texto está centrado, tomar foto
        if (instructions.isEmpty && isTextInMargin) {
          instructions = 'Está alineado.';  // Se puede mostrar un mensaje opcional
          if (!shouldTakePicture) {
            shouldTakePicture = true;  // Ya está centrado, tomar foto
            _takePicture();
          }
        }

        // Si el texto está dentro del margen amarillo y no tiene instrucciones, o si se necesitan instrucciones de acercar/alejar
        if (instructions.isEmpty && shouldTakePicture == true) {
          instructions = 'Está alineado.';
          _takePicture(); // Tomar foto solo una vez
        }

        // Si hay instrucciones, dar voz
        if (instructions.isNotEmpty && instructions != previousInstructions) {
          previousInstructions = instructions; // Guardar las instrucciones dadas
          if (!_isSpeaking) {
            _isSpeaking = true;  // Establecer el flag a true
            await flutterTts.speak(instructions); // Solo leer si no está hablando

            // Esperar hasta que termine de hablar
            flutterTts.setCompletionHandler(() {
              setState(() {
                _isSpeaking = false; // Resetear el flag cuando termine de hablar
              });
            });
          }
        }
        
      }
      else {
        if (!_isSpeaking) {
            _isSpeaking = true;
            await flutterTts.speak("No se detecto texto");
            flutterTts.setCompletionHandler(() {
              setState(() {
                _isSpeaking = false;
              });
            });
          }
      }

    } catch (e) {
      _showErrorSnackBar('Error processing text: $e');
    } finally {
      _isProcessingText = false;
    }
  }

  // Función para acercar o alejar (según el tamaño del texto)
  void _handleZoom(double blockWidth) {
    if (blockWidth < 100) {
      // Si el texto está demasiado pequeño (acercar)
      if (!_isSpeaking) {
        flutterTts.speak('Acerca el texto.');
      }
    } else if (blockWidth > 400) {
      // Si el texto está demasiado grande (alejar)
      if (!_isSpeaking) {
        flutterTts.speak('Aleja el texto.');
      }
    }
  }

  Future<void> _toggleFlash() async {
    try {
      await _cameraService.toggleFlash();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _showErrorSnackBar('Error toggling flash: $e');
    }
  }

  Future<void> _switchCamera() async {
    try {
      await _cameraService.switchCamera();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _showErrorSnackBar('Error switching camera: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_isTakingPicture) return;
    _isTakingPicture = true;

    try {
      final XFile? picture = await _cameraService.takePicture();
      if (picture != null) {
        _cameraService.stopLightSensor(); // Detener el sensor de luz
        if (widget.isDocumentMode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoViewScreen(imageFile: File(picture.path)),
            ),
          );
        } else {
          Navigator.pop(context, File(picture.path));
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error taking picture: $e');
    } finally {
      _isTakingPicture = false;
      _cameraService.stopLightSensor();
    }
    _cameraService.stopLightSensor();
  }

  InputImage _convertCameraImageToInputImage(CameraImage image) {
    final bytes = image.planes.fold<Uint8List>(
      Uint8List(0),
      (Uint8List previousValue, Plane plane) => Uint8List.fromList(previousValue + plane.bytes),
    );

    final InputImageMetadata metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotation.rotation90deg,
      bytesPerRow: image.planes[0].bytesPerRow,
      format: InputImageFormat.nv21,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  Future<void> _openGallery() async {
    try {
      XFile? picture = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (picture != null) {
        File imageFile = File(picture.path);
        if (widget.isDocumentMode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoViewScreen(imageFile: imageFile)),
          );
        } if (widget.isFaceDetectionMode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FaceDetectionScreen(imageFile: imageFile)),
          );
        } else if (widget.isObjectRecognitionMode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ObjectRecognitionScreen(imageFile: imageFile)),
          );
        } else if (widget.isQRScanMode) {
          String? qrText = await _cameraService.scanQRFromImage(imageFile);
          if (qrText != null) {
            _processQRContent(qrText);
          } else {
            _showErrorSnackBar(S.current!.WithoutQR);
          }
        } 
        // Detener el sensor de luz y apagar el flash después de navegar
        _cameraService.stopLightSensor();
        await _cameraService.toggleFlash();
        
      }
    } catch (e) {
      _showErrorSnackBar('Error opening gallery: $e');
    }
  }

  void _processQRContent(String qrContent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TextResultScreen(extractedText: qrContent),
      ),
    );
  }

  void _onQRViewCreated(qr.QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) {
      if (mounted) {
        setState(() {
          result = scanData;
        });
        if (result != null && result!.code != null) {
          _processQRContent(result!.code!);
        }
      }
    });
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(S.current!.Camera, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isCameraInitialized
          ? GestureDetector(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: widget.isQRScanMode
                        ? qr.QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                            overlay: qr.QrScannerOverlayShape(
                              borderColor: Color(0xFFFFD700),
                              borderRadius: 10,
                              borderLength: 30,
                              borderWidth: 10,
                              cutOutSize: 250,
                            ),
                          )
                        : Align(
                            alignment: Alignment.topCenter,
                            child: AspectRatio(
                              aspectRatio: _aspectRatio, // Cambiar aquí a 1.2/2.1
                              child: _cameraService.controller != null && _cameraService.controller!.value.isInitialized
                                  ? CameraPreview(_cameraService.controller!)
                                  : Center(child: CircularProgressIndicator()),
                            ),
                          ),
                  ),
                  if (widget.isDocumentMode)
                    CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                      painter: DocumentMarginPainter(margin: documentMargin),
                    ),
                  if (widget.isDocumentMode && detectedTextBlocks.isNotEmpty)
                    CustomPaint(  
                      size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                      painter: TextBlockPainter(textBlocks: detectedTextBlocks), 
                    ),
                  if (!widget.isQRScanMode)
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
                              label: widget.isFaceDetectionMode
                                  ? 'Botón para tomar foto para detección de rostros'
                                  : widget.isObjectRecognitionMode
                                      ? 'Botón para tomar foto para reconocimiento de objetos'
                                      : 'Botón para tomar foto',
                              child: GestureDetector(
                                onTap: _takePicture,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Icon(
                                    widget.isFaceDetectionMode
                                        ? Icons.face
                                        : widget.isObjectRecognitionMode
                                            ? Icons.category
                                            : Icons.camera_alt,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                            Semantics(
                              label: 'Botón para abrir galería',
                              child: IconButton(
                                icon: const Icon(Icons.photo_library, color: Colors.white, size: 30),
                                onPressed: _openGallery,
                                tooltip: 'Abrir galería',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.isQRScanMode)
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
                                icon: const Icon(Icons.flash_on, color: Colors.white, size: 30),
                                onPressed: _toggleFlash,
                                tooltip: 'Activar/Desactivar flash',
                              ),
                            ),
                            Semantics(
                              label: 'Botón para abrir galería',
                              child: IconButton(
                                icon: const Icon(Icons.photo_library, color: Colors.white, size: 30),
                                onPressed: _openGallery,
                                tooltip: 'Abrir galería',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_errorMessage.isNotEmpty)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        color: Colors.red,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.white),
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