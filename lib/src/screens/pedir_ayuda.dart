import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class PedirAyudaScreen extends StatefulWidget {
  const PedirAyudaScreen({super.key});

  @override
  _PedirAyudaScreenState createState() => _PedirAyudaScreenState();
}

class _PedirAyudaScreenState extends State<PedirAyudaScreen> {
  String ubicacion = "Obteniendo ubicación...";
  String direccion = "Obteniendo dirección...";
  Position? _position;
  String _contactoConfianza = "Sin contacto de confianza";
  final TextEditingController _contactoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _obtenerUbicacion();
    _cargarContacto();
  }

  Future<void> _obtenerUbicacion() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _position = position;
        ubicacion = 'Latitud: ${position.latitude}, Longitud: ${position.longitude}';
      });
      _obtenerDireccion(position);
    } catch (e) {
      setState(() {
        ubicacion = "Error al obtener la ubicación";
      });
    }
  }

  Future<void> _obtenerDireccion(Position position) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${position.latitude}&lon=${position.longitude}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          direccion = data['display_name'] ?? 'No se encontró dirección';
        });
      } else {
        setState(() {
          direccion = "Error al obtener la dirección";
        });
      }
    } catch (e) {
      setState(() {
        direccion = "Error al conectar con el servicio de direcciones";
      });
    }
  }

  Future<void> _enviarMensaje() async {
    if (_contactoConfianza == "Sin contacto de confianza" || _contactoConfianza.isEmpty) {
      _mostrarError('No se ha configurado un contacto de confianza.');
      return;
    }

    if (_position == null) {
      _mostrarError('No se ha podido obtener la ubicación.');
      return;
    }

    try {
      final lat = _position!.latitude;
      final lon = _position!.longitude;
      final linkMaps = 'https://maps.google.com/?q=$lat,$lon';
      final mensaje =
          "¡Ayuda! Estoy en: $direccion\nUbicación en Google Maps: $linkMaps";

      final Uri smsUri = Uri(
        scheme: 'sms',
        path: _contactoConfianza,
        queryParameters: {'body': mensaje},
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        throw 'No se pudo enviar el mensaje.';
      }
    } catch (e) {
      _mostrarError('Error al intentar enviar SMS: $e');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> _agregarContacto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('contacto_confianza', _contactoController.text);
    setState(() {
      _contactoConfianza = _contactoController.text;
    });
    Navigator.of(context).pop(); 
  }

  Future<void> _cargarContacto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _contactoConfianza = prefs.getString('contacto_confianza') ?? '';
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('El servicio de ubicación está deshabilitado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación fueron denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación están permanentemente denegados.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _mostrarDialogoAgregarContacto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Agregar o editar contacto de confianza"),
          content: TextField(
            controller: _contactoController,
            decoration: const InputDecoration(hintText: "Número de teléfono"),
            keyboardType: TextInputType.phone,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: _agregarContacto,
              child: Text("Guardar"),
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text(
          'Pedir Ayuda',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF064b8d),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.redAccent, size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Tu Ubicación',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ubicacion,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      direccion,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _enviarMensaje,
              icon: const Icon(Icons.message, size: 30, color: Colors.white),
              label: const Text('Enviar Mensaje de Ayuda', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.contact_phone, color: Colors.redAccent, size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Contacto de Confianza',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _contactoConfianza,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _mostrarDialogoAgregarContacto,
                      icon: const Icon(Icons.edit, size: 30, color: Colors.white),
                      
                      label: const Text('Agregar o Editar Contacto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),

                        backgroundColor: const Color(0xFF064b8d),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}