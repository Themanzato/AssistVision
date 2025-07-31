import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSController extends StatefulWidget {
  final String text;

  const TTSController({super.key, required this.text});

  @override
  _TTSControllerState createState() => _TTSControllerState();
}

class _TTSControllerState extends State<TTSController> {
  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _togglePlayPause() {
    if (isPlaying) {
      flutterTts.pause();
    } else {
      flutterTts.speak(widget.text);
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _togglePlayPause,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          onPressed: () {
            flutterTts.stop();
            setState(() {
              isPlaying = false;
            });
          },
        ),
      ],
    );
  }
}