import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/widgets/info_card.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/widgets/custom_slider.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current!.Settings,
          style: GoogleFonts.poppins(
            fontSize: 28,
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
            const SizedBox(height: 20),
            InfoCard(
              icon: CupertinoIcons.volume_up,
              title: S.current!.Audio,
              description: S.current!.ConfigureVoice,
              color: Colors.lightBlueAccent,
              options: [S.current!.Volume, S.current!.Velocity, S.current!.Accent],
              onOptionSelected: (option) {
                if (option == S.current!.Volume) {
                  _showSliderModal(context, S.current!.AdjustVolume, settingsProvider.volume, (value) {
                    settingsProvider.setVolume(value);
                  });
                } else if (option == S.current!.Velocity) {
                  _showSliderModal(context, S.current!.AdjustSpeed, settingsProvider.speed, (value) {
                    settingsProvider.setSpeed(value);
                  });
                } else if (option == S.current!.Accent) {
                  _showAccentOptions(context, settingsProvider);
                }
              },
            ),
            const SizedBox(height: 20),
            InfoCard(
              icon: CupertinoIcons.globe,
              title: S.current!.Language,
              description: S.current!.SelectLanguage,
              color: Colors.orangeAccent,
              options: const ['Español', 'Inglés', 'Deutsch', 'Français', 'Italiano', '日本語', 'Русский'],
              onOptionSelected: (option) {
                String languageCode;
                switch (option) {
                  case 'Español':
                    languageCode = 'es';
                    break;
                  case 'Inglés':
                    languageCode = 'en';
                    break;
                  case 'Deutsch':
                    languageCode = 'de';
                    break;
                  case 'Français':
                    languageCode = 'fr';
                    break;
                  case 'Italiano':
                    languageCode = 'it';
                    break;
                  case '日本語':
                    languageCode = 'ja';
                    break;
                  case 'Русский':
                    languageCode = 'ru';
                    break;
                  default:
                    return;
                }
                settingsProvider.setLocale(languageCode);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${S.current!.YouSelected} $option')),
                );
              },
            ),
            const SizedBox(height: 20),
            InfoCard(
              icon: CupertinoIcons.eye_solid,
              title: S.current!.Accessibility,
              description: S.current!.VisualSettings,
              color: Colors.greenAccent,
              options: [S.current!.HighContrast, S.current!.DarkMode, S.current!.FontSize],
              onOptionSelected: (option) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${S.current!.YouSelected}: $option')),
                );
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: CustomButton(
                text: S.current!.CloseSession,
                onPressed: () {
                  // Acción para cerrar sesión
                },
              ),
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
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF064b8d),
        ),
      ),
    );
  }

  void _showSliderModal(
    BuildContext context,
    String title,
    double initialValue,
    ValueChanged<double> onSave,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CustomSlider(
          title: title,
          initialValue: initialValue,
          onSave: onSave,
        );
      },
    );
  }

  void _showAccentOptions(BuildContext context, SettingsProvider settingsProvider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: settingsProvider.accents.map((accent) {
            return ListTile(
              title: Text(accent == 'es-US' ? 'Latinoamericano' : 'Castellano'),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  settingsProvider.flutterTts.setVoice({"name": accent});
                  settingsProvider.flutterTts.speak(S.current!.TestAccent);
                },
              ),
              onTap: () {
                settingsProvider.setAccent(accent);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}