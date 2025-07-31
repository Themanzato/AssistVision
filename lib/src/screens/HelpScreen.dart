import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/widgets/info_card.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ayuda',
          style: GoogleFonts.poppins(
            fontSize: 20,
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
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(height: 20.h),
            CustomInfoCard(
              icon: CupertinoIcons.info,
              title: '¿Cómo usar Assist Vision?',
              description:
                  'Assist Vision es una aplicación diseñada para ayudar a personas con discapacidad visual a reconocer objetos, textos y códigos QR mediante tecnologías avanzadas de reconocimiento y análisis de imágenes. Utiliza la cámara de tu dispositivo para identificar objetos, leer textos y escanear códigos QR. Personaliza la aplicación según tus necesidades en la sección de configuración. Para más detalles, consulta la guía paso a paso a continuación.',
              color: Colors.lightBlueAccent,
              options: const [],
              onOptionSelected: (option) {},
            ),
             SizedBox(height: 20.h),
            _buildSectionTitle('Guía Paso a Paso'),
            
            SizedBox(height: 15.h),
            CustomInfoCard(
              icon: Icons.text_fields,
              title: 'Lectura de Texto',
              description:
                  'Dirige la cámara hacia un texto y la aplicación lo leerá en voz alta para ti. Ideal para leer carteles, documentos o menús.',
              color: Colors.greenAccent,
              options: const [],
              onOptionSelected: (option) {},
            ),
            SizedBox(height: 15.h),
            CustomInfoCard(
              icon: Icons.qr_code_scanner,
              title: 'Escaneo de Códigos QR',
              description:
                  'Escanea cualquier código QR con la cámara y recibirás la información almacenada, como sitios web o detalles de productos.',
              color: Colors.purpleAccent,
              options: const [],
              onOptionSelected: (option) {},
            ),
            SizedBox(height: 15.h),
            CustomInfoCard(
              icon: Icons.face,
              title: 'Detección de Rostros',
              description:
                  'La aplicación puede detectar rostros y proporcionarte información sobre las personas que te rodean.',
              color: Colors.blueAccent,
              options: const [],
              onOptionSelected: (option) {},
            ),
            SizedBox(height: 15.h),
            CustomInfoCard(
              icon: Icons.emergency_share,
              title: 'Pedir Ayuda',
              description:
                  'Esta función te permite enviar una alerta a tus contactos de emergencia con tu ubicación actual. Ideal para situaciones de peligro o emergencia.',
              color: Colors.redAccent,
              options: const [],
              onOptionSelected: (option) {},
            ),
            SizedBox(height: 20.h),
            CustomInfoCard(
              icon: Icons.help_outline,
              title: 'Preguntas Frecuentes',
              description: '',
              color: Colors.blueGrey,
              options: const [
                '¿Cómo puedo ajustar el volumen de la voz?',
                '¿Puedo usar la aplicación sin conexión?',
                '¿Es compatible con otros idiomas?',
              ],
              onOptionSelected: (option) {
                String answer;
                switch (option) {
                  case '¿Cómo puedo ajustar el volumen de la voz?':
                    answer =
                        'Puedes ajustar el volumen de la voz a través de los ajustes de sonido en la aplicación o directamente en los controles de volumen de tu dispositivo.';
                    break;
                  case '¿Puedo usar la aplicación sin conexión?':
                    answer =
                        'No, Assist Vision necesita una conexión a internet para poder acceder a las bases de datos de reconocimiento de objetos y textos.';
                    break;
                  case '¿Es compatible con otros idiomas?':
                    answer =
                        'Sí, Assist Vision está disponible en varios idiomas. Puedes cambiar el idioma en los ajustes de la aplicación.';
                    break;
                  default:
                    answer = '';
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(answer)),
                );
              },
            ),
           
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF064b8d),
        ),
      ),
    );
  }
}
