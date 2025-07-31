import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final double textSize;
  final double lineHeight;
  final TextAlign textAlign;
  final Color textColor;
  final Color backgroundColor;
  final double speechRate;
  final bool showOriginalText;
  final ValueChanged<Map<String, dynamic>> onSettingsChanged;

  const SettingsScreen({
    super.key,
    required this.textSize,
    required this.lineHeight,
    required this.textAlign,
    required this.textColor,
    required this.backgroundColor,
    required this.speechRate,
    required this.showOriginalText,
    required this.onSettingsChanged,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double textSize;
  late double lineHeight;
  late TextAlign textAlign;
  late Color textColor;
  late Color backgroundColor;
  late double speechRate;
  late bool showOriginalText;

  @override
  void initState() {
    super.initState();
    textSize = widget.textSize;
    lineHeight = widget.lineHeight;
    textAlign = widget.textAlign;
    textColor = widget.textColor;
    backgroundColor = widget.backgroundColor;
    speechRate = widget.speechRate;
    showOriginalText = widget.showOriginalText;
  }

  void _saveSettings() {
    widget.onSettingsChanged({
      'textSize': textSize,
      'lineHeight': lineHeight,
      'textAlign': textAlign,
      'textColor': textColor,
      'backgroundColor': backgroundColor,
      'speechRate': speechRate,
      'showOriginalText': showOriginalText,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuraciones'),
        
        backgroundColor: const Color(0xFF064b8d),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildIncrementDecrementTile(
                    'Tamaño de texto',
                    textSize,
                    10.0,
                    30.0,
                    (value) {
                      setState(() {
                        textSize = value;
                        _saveSettings();
                      });
                    },
                  ),
                  _buildIncrementDecrementTile(
                    'Interlineado',
                    lineHeight,
                    1.0,
                    2.0,
                    (value) {
                      setState(() {
                        lineHeight = value;
                        _saveSettings();
                      });
                    },
                  ),
                  _buildTextAlignButtons(),
                  _buildColorPicker(
                    'Color de texto',
                    textColor,
                    (color) {
                      setState(() {
                        textColor = color;
                        _saveSettings();
                      });
                    },
                  ),
                  _buildColorPicker(
                    'Color de fondo',
                    backgroundColor,
                    (color) {
                      setState(() {
                        backgroundColor = color;
                        _saveSettings();
                      });
                    },
                  ),
                  _buildIncrementDecrementTile(
                    'Velocidad de habla',
                    speechRate,
                    0.5,
                    2.0,
                    (value) {
                      setState(() {
                        speechRate = value;
                        _saveSettings();
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Mostrar texto original y traducido'),
                    value: showOriginalText,
                    onChanged: (value) {
                      setState(() {
                        showOriginalText = value;
                        _saveSettings();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildPreviewArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildIncrementDecrementTile(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return ListTile(
      title: Text(label),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (value > min) {
                onChanged(value - 1.0);
              }
            },
          ),
          Text(value.toStringAsFixed(1)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (value < max) {
                onChanged(value + 1.0);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextAlignButtons() {
    return ListTile(
      title: const Text('Alineación de texto'),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.format_align_left),
            color: textAlign == TextAlign.left ? Colors.blue : Colors.black,
            onPressed: () {
              setState(() {
                textAlign = TextAlign.left;
                _saveSettings();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_align_center),
            color: textAlign == TextAlign.center ? Colors.blue : Colors.black,
            onPressed: () {
              setState(() {
                textAlign = TextAlign.center;
                _saveSettings();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_align_right),
            color: textAlign == TextAlign.right ? Colors.blue : Colors.black,
            onPressed: () {
              setState(() {
                textAlign = TextAlign.right;
                _saveSettings();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_align_justify),
            color: textAlign == TextAlign.justify ? Colors.blue : Colors.black,
            onPressed: () {
              setState(() {
                textAlign = TextAlign.justify;
                _saveSettings();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(String label, Color currentColor, ValueChanged<Color> onColorChanged) {
    final List<Color> accessibleColors = [Colors.black, Colors.blueGrey, Colors.teal, Colors.amber];
    return ListTile(
      title: Text(label),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: accessibleColors.map((color) {
          return IconButton(
            icon: const Icon(Icons.circle, size: 24),
            color: color,
            onPressed: () {
              onColorChanged(color);
            },
          );
        }).toList(),
      ),
    );
  }



  Widget _buildPreviewArea() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Text(
        'Texto de prueba:\nConfigura aquí cómo deseas ver el texto.',
        style: TextStyle(
          fontSize: textSize,
          height: lineHeight,
          color: textColor,
        ),
        textAlign: textAlign,
      ),
    );
  }
}