import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart' show rootBundle; // Importa rootBundle para cargar archivos desde assets
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/widgets/CustomInfoCard.dart'; // Importa CustomInfoCard

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializa ScreenUtil para adaptarse a diferentes tamaños de pantalla
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Acerca de Assist Vision',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInfoCard(
              icon: Icons.info_outline,
              title: 'Sobre Assist Vision',
              description:
                'Assist Vision es una aplicación de asistencia visual diseñada para facilitar la vida de las personas con discapacidad visual. La app integra funciones avanzadas como la lectura de textos, el reconocimiento de objetos y la descripción de rostros, utilizando tecnología de vanguardia para proporcionar una experiencia de mayor autonomía y accesibilidad. Actualmente, Assist Vision está en su versión 1.0.0, desarrollada por un equipo de estudiantes del Instituto Tecnológico Superior de Xalapa, comprometidos con crear soluciones inclusivas y accesibles',           
              color: Colors.lightBlueAccent,
              options: const [],
              onOptionSelected: (option) {},
            ),
            SizedBox(height: 20.h),

            CustomInfoCard(
              icon: Icons.group,
              title: 'Equipo Assist Vision',
              description: '',              
              color: Colors.orangeAccent,
              options: const [
                'Sánchez Hernández Joseph Alejandro (Líder)',
                'Trejo Landa Omar - Desarrollador',
                'Flores Méndez Brian Delfino - Desarrollador',
                'Arroyo Utrera Mario Alberto - Desarrollador',
                'Alarcón Hernández Anna Joselyne - Gestora de Proyectos y Finanzas',
                'Alejandré Apolinar María Salomé - Asesora',
                'Lagunes Barradas Virginia - Asesora',
              ],
              onOptionSelected: (option) {},
            ),
            SizedBox(height: 20.h),

            CustomInfoCard(
              icon: Icons.info,
              title: 'Información Adicional',
              description: '',
              color: Colors.greenAccent,
              options: const [
                'Versión de la App: 1.0.0',
                'Política de Privacidad',
                'Aviso Legal',
              ],
              onOptionSelected: (option) {},
            ),
            SizedBox(height: 20.h),

            CustomInfoCard(
              icon: Icons.contact_mail,
              title: 'Contacto',
              description: '',
              color: Colors.purpleAccent,
              options: const [
                'Facebook: Assist Vision',
              ],
              onOptionSelected: (option) {},
            ),
            SizedBox(height: 20.h),

            CustomInfoCard(
              icon: Icons.library_books,
              title: 'Licencias de Dependencias y Recursos',
              description: '',
              color: Colors.blueGrey,
              options: const [
                'Toca para ver las Licencias',
              ],
              onOptionSelected: (option) {
                if (option == 'Toca para ver las Licencias') {
                  _showLicenseDetails(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLicenseDetails(BuildContext context) async {
    String licenseContent = await _loadLicenseContent();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Licencias de Dependencias y Recursos',
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF064b8d),
            ),
          ),
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
                children: _buildLicenseText(licenseContent),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cerrar',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: const Color(0xFF064b8d),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _loadLicenseContent() async {
    try {
      return await rootBundle.loadString('assets/licencias.txt'); // Ruta del archivo de licencia en assets
    } catch (e) {
      return 'No se pudo cargar el contenido de la licencia.';
    }
  }

  List<TextSpan> _buildLicenseText(String content) {
    List<TextSpan> spans = [];
    List<String> lines = content.split('\n');
    for (String line in lines) {
      if (line.startsWith('- **')) {
        spans.add(TextSpan(
          text: '$line\n',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (line.trim().isEmpty) {
        spans.add(const TextSpan(text: '\n'));
      } else {
        spans.add(TextSpan(text: '$line\n'));
      }
    }
    return spans;
  }
}