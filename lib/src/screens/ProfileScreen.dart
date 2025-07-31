import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/widgets/profile_widgets.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
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
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ProfileHeader(
              imagePath: 'assets/profile_picture.png',
              name: 'Omar Trejo',
              email: 'omi@mail.com',
              onCameraTap: () {
              },
            ),
            const SizedBox(height: 20),
            ProfileOption(
              icon: CupertinoIcons.person,
              title: 'Nombre',
              description: 'Configura tu nombre',
              color: Colors.blueAccent,
              options: const ['Editar Nombre'],
              onOptionSelected: (option) {
              },
            ),
            ProfileOption(
              icon: CupertinoIcons.mail,
              title: 'Correo',
              description: 'Configura tu correo',
              color: Colors.orangeAccent,
              options: const ['Editar Correo'],
              onOptionSelected: (option) {
              },
            ),
          ],
        ),
      ),
    );
  }
}