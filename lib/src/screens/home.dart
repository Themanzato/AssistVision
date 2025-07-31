  import 'package:flutter/material.dart';
  import 'dart:io';
  import 'photo_view_screens.dart';
  import 'settings.dart';
  import 'camera_screen.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:flutter/cupertino.dart';
  import 'ProfileScreen.dart';
  import 'package:flutter_application_1/widgets/secondary_button.dart';
  import 'face_detection_screen.dart';
  import 'RealTimeReaderScreen.dart';
  import 'AboutScreen.dart';
  import 'HelpScreen.dart';
  //import 'camerawesome_screen.dart';
  import 'RecognizeObjectsScreen.dart';
  import 'qr_scan_screen.dart';
  import 'pedir_ayuda.dart';
  import 'package:speech_to_text/speech_to_text.dart' as stt;
  import 'package:flutter_tts/flutter_tts.dart';
  import 'colors.dart';
  import 'dart:async';
  import 'BillDetectionScreen.dart';
  import 'BillRecognitionScreen.dart';
  import 'CameraScreen2.dart';

  late FlutterTts _flutterTts;

  class HomeScreen extends StatefulWidget {
    @override
    _HomeScreenState createState() => _HomeScreenState();
  }

  class _HomeScreenState extends State<HomeScreen> {
    final ImagePicker imagePicker = ImagePicker();
    int _selectedFunction = 0;
    final PageController _pageController = PageController(viewportFraction: 0.6);

    // Variables para reconocimiento de voz
    late stt.SpeechToText _speech;
    bool _isListening = false;
    String _command = '';
    Timer? _timer;
    bool _isNavigating = false;

    final List<Map<String, dynamic>> functions = [
      {
        'name': 'Leer Texto',
        'icon': CupertinoIcons.textformat_abc,
      }, //cambio de icono
      {'name': 'Leer Documento', 'icon': CupertinoIcons.doc_text_viewfinder},
      {'name': 'Escanear QR', 'icon': CupertinoIcons.qrcode_viewfinder},
      {'name': 'Detección de Rostros', 'icon': CupertinoIcons.person_crop_circle},
      {'name': 'Pedir Ayuda', 'icon': CupertinoIcons.location_solid},
      {'name': 'Reconocimiento de Colores', 'icon': CupertinoIcons.color_filter},
      {
        'name': 'Detector de Billetes',
        'icon': CupertinoIcons.money_dollar_circle
      },
    ];

    @override
    void initState() {
      super.initState();
      _speech = stt.SpeechToText();
      _flutterTts = FlutterTts();
    }

    @override
    void dispose() {
      _pageController.dispose();
      super.dispose();
    }

  // Función para hablar
    Future<void> _speak(String message) async {
      await _flutterTts.speak(message);
    }

    // Función para cambiar la página del carrusel
    void _onFunctionChanged(int index) {
      setState(() {
        _selectedFunction = index;
      });
    }

    // Función para animar el carrusel hacia una página específica
    void _scrollToFunction(int index) {
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }

    // Función para iniciar la cámara con diferentes modos
    void _openCamera(
        {bool isDocumentMode = false,
        bool isFaceDetectionMode = false,
        bool isObjectRecognitionMode = false,
        bool isQRScanMode = false}) async {
      final File? image = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(
            isDocumentMode: isDocumentMode,
            isFaceDetectionMode: isFaceDetectionMode,
            isQRScanMode: isQRScanMode,
            isObjectRecognitionMode: isObjectRecognitionMode,
          ),
        ),
      );
      if (isDocumentMode && image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoViewScreen(imageFile: image),
          ),
        );
      } else if (isFaceDetectionMode && image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FaceDetectionScreen(imageFile: image),
          ),
        );
      } else if (isObjectRecognitionMode && image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ObjectRecognitionScreen(imageFile: image),
          ),
        );
      } else if (image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoViewScreen(imageFile: image),
          ),
        );
      }
    }

    // Función para abrir la galería
    void _openGallery() async {
      XFile? picture = await imagePicker.pickImage(source: ImageSource.gallery);
      if (picture != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoViewScreen(imageFile: File(picture.path)),
          ),
        );
      }
    }

    // Función para iniciar el reconocimiento de voz
    void _startListening() async {
      bool available = await _speech.initialize();
      if (available) {
        await _speak("Escuchando");
        await Future.delayed(Duration(milliseconds: 1000)); // Pausa inicial.
        setState(() => _isListening = true);

        _timer = Timer(Duration(seconds: 5), () {
          if (_isListening) {
            _speech.stop();
            _speak("No se ha reconocido ningún comando de voz");
            setState(() {
              _isListening = false;
            });
          }
        });

        // Iniciar la escucha del comando
        _speech.listen(onResult: (val) {
          setState(() {
            _command = val.recognizedWords.toLowerCase();
            if (_command.isNotEmpty) {
              _timer?.cancel();
              _executeCommand(_command);
              _speech.stop();
              setState(() => _isListening = false);
            }
          });
        });
      } else {
        await _speak("No se pudo iniciar el reconocimiento de voz");
      }
    }

    // Función para ejecutar el comando basado en el reconocimiento de voz
    void _executeCommand(String command) async {
    if (_isNavigating) return; 

    _isNavigating = true; 

    // Comandos para las funciones del carrusel
    if (command.contains('leer texto') ||
        command.contains('extraer texto') ||
        command.contains('detectar texto') ||
        command.contains('reconocimiento de texto') ||
        command.contains('escaneo de texto')) {
      await _speak("Abriendo cámara para extraer texto");
      _scrollToFunction(0);
      _openCamera();
    } else if (command.contains('leer documento') ||
        command.contains('escanear documento') ||
        command.contains('capturar documento') ||
        command.contains('documento')) {
      await _speak("Abriendo cámara para leer documento");
      _scrollToFunction(1);
      _openCamera(isDocumentMode: true);
    } else if (command.contains('escanear qr') ||
        command.contains('leer qr') ||
        command.contains('escaneo qr') ||
        command.contains('código qr') ||
        command.contains('qr') ||
        command.contains('escanear código qr') ||
        command.contains('escaneo de código qr')) {
      await _speak("Abriendo cámara para escanear código QR");
      _scrollToFunction(2);
      _openCamera(isQRScanMode: true);
    } else if (command.contains('detección de rostros') ||
        command.contains('detectar rostros') ||
        command.contains('reconocimiento facial') ||
        command.contains('detectar caras') ||
        command.contains('reconocimiento de caras')) {
      await _speak("Abriendo cámara para detección de rostros");
      _scrollToFunction(3);
      _openCamera(isFaceDetectionMode: true);
    } else if (command.contains('pedir ayuda') ||
        command.contains('solicitar ayuda') ||
        command.contains('enviar ubicación') ||
        command.contains('ayuda de emergencia') ||
        command.contains('necesito ayuda') ||
        command.contains('buscar ayuda')) {
      await _speak("Abriendo pantalla para pedir ayuda");
      _scrollToFunction(4);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PedirAyudaScreen()),
      ).then((_) => _isNavigating = false); // Liberar bloqueo al regresar.
    } else if (command.contains('reconocimiento de colores') ||
        command.contains('detectar colores') ||
        command.contains('reconocer colores') ||
        command.contains('ver colores') ||
        command.contains('colores') ||
        command.contains('identificar colores')) {
      await _speak("Abriendo pantalla para reconocimiento de colores");
      _scrollToFunction(5);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ColorRecognitionScreen()),
      ).then((_) => _isNavigating = false);
    } else if (command.contains('detector de billetes') ||
        command.contains('reconocer billetes') ||
        command.contains('detectar billetes') ||
        command.contains('identificar billetes') ||
        command.contains('billetes') ||
        command.contains('reconocimiento de billetes')) {
      await _speak("Abriendo pantalla para detección de billetes");
      _scrollToFunction(6);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageUploadScreen()),
      ).then((_) => _isNavigating = false);
    }

    // Comandos para las opciones adicionales (Configuración, Perfil, Ayuda, Acerca de)
    else if (command.contains('configuración') ||
        command.contains('ajustes') ||
        command.contains('abrir configuración') ||
        command.contains('ir a configuración')) {
      await _speak("Abriendo configuración");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      ).then((_) => _isNavigating = false);
    } else if (command.contains('perfil') ||
        command.contains('ver perfil') ||
        command.contains('abrir perfil') ||
        command.contains('mostrar perfil')) {
      await _speak("Abriendo perfil");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      ).then((_) => _isNavigating = false);
    } else if (command.contains('ayuda') ||
        command.contains('abrir ayuda') ||
        command.contains('tutorial') ||
        command.contains('solicitar ayuda') ||
        command.contains('buscar ayuda')) {
      await _speak("Abriendo pantalla de ayuda");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HelpScreen()),
      ).then((_) => _isNavigating = false);
    } else if (command.contains('acerca de') ||
        command.contains('información') ||
        command.contains('sobre la app') ||
        command.contains('acerca de la app')) {
      await _speak("Mostrando información sobre la aplicación");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutScreen()),
      ).then((_) => _isNavigating = false);
    } else {
      _isNavigating = false; // Liberar bloqueo si no coincide ningún comando.
    }
  }


    @override
    Widget build(BuildContext context) {
      ScreenUtil.init(context, designSize: Size(360, 690));

      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Assist Vision',
            style: GoogleFonts.poppins(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xFF064b8d),
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actions: [
            Semantics(
              label: 'Botón para activar comandos de voz por micrófono',
              child: IconButton(
                icon: Icon(CupertinoIcons.mic),
                onPressed: _isListening ? null : _startListening,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 60.h),
            Container(
              height: 190.h,
              child: PageView.builder(
                itemCount: functions.length,
                controller: _pageController,
                onPageChanged: _onFunctionChanged,
                itemBuilder: (context, index) {
                  return Semantics(
                    label:
                        '${functions[index]['name']}, ${index + 1} de ${functions.length}',
                    button: true,
                    onDidGainAccessibilityFocus: () {
                      _scrollToFunction(index);
                    },
                    child: AnimatedScale(
                      duration: Duration(milliseconds: 150),
                      scale: index == _selectedFunction ? 1.0 : 0.8,
                      child: Opacity(
                        opacity: index == _selectedFunction ? 1.0 : 0.5,
                        child: GestureDetector(
                          onTap: () {
                            if (functions[index]['name'] == 'Leer Texto') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RealTimeTextReaderScreen()),
                              );
                            } else if (functions[index]['name'] ==
                                'Leer Documento') {
                              _openCamera(isDocumentMode: true);
                            } else if (functions[index]['name'] ==
                                'Escanear QR') {
                              _openCamera(isQRScanMode: true);
                            } else if (functions[index]['name'] ==
                                'Detección de Rostros') {
                              _openCamera(isFaceDetectionMode: true);
                            } else if (functions[index]['name'] ==
                                'Pedir Ayuda') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PedirAyudaScreen()),
                              );
                            } else if (functions[index]['name'] ==
                                'Reconocimiento de Colores') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ColorRecognitionScreen()),
                              );
                            } else if (functions[index]['name'] ==
                                'Detector de Billetes') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageUploadScreen()),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.05),
                                  Colors.black26.withOpacity(0.03),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  functions[index]['icon'],
                                  size: 100.w,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  functions[index]['name'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 35.h),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                padding: const EdgeInsets.all(16),
                children: [
                  SecondaryButton(
                    icon: CupertinoIcons.gear,
                    label: 'Configuración',
                    color: Color(0xFFFFD700),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen()),
                      );
                    },
                  ),
                  SecondaryButton(
                    icon: CupertinoIcons.person,
                    label: 'Perfil',
                    color: Color(0xFFFFD700),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                  ),
                  SecondaryButton(
                    icon: CupertinoIcons.question_circle,
                    label: 'Ayuda',
                    color: Color(0xFF064b8d),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpScreen()),
                      );
                    },
                  ),
                  SecondaryButton(
                      icon: CupertinoIcons.info,
                      label: 'Acerca de',
                      color: Color(0xFF064b8d),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutScreen()),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
