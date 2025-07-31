import 'package:flutter/material.dart';

class TextSettingsDrawer extends StatelessWidget {
  final double textSize;
  final double lineHeight;
  final TextAlign textAlign;
  final Color textColor;
  final Color backgroundColor;
  final Color currentWordBackgroundColor;
  final double speechRate;
  final bool highlightWords;
  final bool showOriginalText; 
  final ValueChanged<double> onTextSizeChanged;
  final ValueChanged<double> onLineHeightChanged;
  final ValueChanged<TextAlign> onTextAlignChanged;
  final ValueChanged<Color> onTextColorChanged;
  final ValueChanged<Color> onBackgroundColorChanged;
  final ValueChanged<Color> onCurrentWordBackgroundColorChanged;
  final ValueChanged<double> onSpeechRateChanged;
  final ValueChanged<bool> onHighlightWordsChanged;
  final ValueChanged<bool> onShowOriginalTextChanged; 

  const TextSettingsDrawer({
    super.key, 
    required this.textSize,
    required this.lineHeight,
    required this.textAlign,
    required this.textColor,
    required this.backgroundColor,
    required this.currentWordBackgroundColor,
    required this.speechRate,
    required this.highlightWords,
    required this.showOriginalText, 
    required this.onTextSizeChanged,
    required this.onLineHeightChanged,
    required this.onTextAlignChanged,
    required this.onTextColorChanged,
    required this.onBackgroundColorChanged,
    required this.onCurrentWordBackgroundColorChanged,
    required this.onSpeechRateChanged,
    required this.onHighlightWordsChanged,
    required this.onShowOriginalTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF064b8d),
            ),
            child: Text(
              'Configuraciones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildExpansionTile(
            title: 'Tamaño de texto',
            children: [
              _buildListTile(
                subtitle: _buildRow(
                  children: [
                    _buildIconButton(
                      label: 'Disminuir tamaño de texto',
                      icon: Icons.remove,
                      onPressed: () => onTextSizeChanged(textSize > 10.0 ? textSize - 1.0 : textSize),
                    ),
                    Text(textSize.toStringAsFixed(0)),
                    _buildIconButton(
                      label: 'Aumentar tamaño de texto',
                      icon: Icons.add,
                      onPressed: () => onTextSizeChanged(textSize + 1.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildExpansionTile(
            title: 'Alineación de texto',
            children: [
              _buildListTile(
                subtitle: _buildRow(
                  children: [
                    _buildIconButton(
                      label: 'Alinear texto a la izquierda',
                      icon: Icons.format_align_left,
                      color: textAlign == TextAlign.left ? Colors.blue : Colors.black,
                      onPressed: () => onTextAlignChanged(TextAlign.left),
                    ),
                    _buildIconButton(
                      label: 'Alinear texto al centro',
                      icon: Icons.format_align_center,
                      color: textAlign == TextAlign.center ? Colors.blue : Colors.black,
                      onPressed: () => onTextAlignChanged(TextAlign.center),
                    ),
                    _buildIconButton(
                      label: 'Alinear texto a la derecha',
                      icon: Icons.format_align_right,
                      color: textAlign == TextAlign.right ? Colors.blue : Colors.black,
                      onPressed: () => onTextAlignChanged(TextAlign.right),
                    ),
                    _buildIconButton(
                      label: 'Justificar texto',
                      icon: Icons.format_align_justify,
                      color: textAlign == TextAlign.justify ? Colors.blue : Colors.black,
                      onPressed: () => onTextAlignChanged(TextAlign.justify),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildExpansionTile(
            title: 'Interlineado',
            children: [
              _buildListTile(
                subtitle: _buildRow(
                  children: [
                    _buildIconButton(
                      label: 'Disminuir interlineado',
                      icon: Icons.remove,
                      onPressed: () => onLineHeightChanged(lineHeight > 1.0 ? lineHeight - 0.1 : lineHeight),
                    ),
                    Text(lineHeight.toStringAsFixed(1)),
                    _buildIconButton(
                      label: 'Aumentar interlineado',
                      icon: Icons.add,
                      onPressed: () => onLineHeightChanged(lineHeight < 2.0 ? lineHeight + 0.1 : lineHeight),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildExpansionTile(
            title: 'Color de texto',
            children: [
              _buildListTile(
                subtitle: _buildRow(
                  children: [
                    _buildColorIconButton(
                      label: 'Color de texto negro',
                      color: Colors.black,
                      isSelected: textColor == Colors.black,
                      onPressed: () => onTextColorChanged(Colors.black),
                    ),
                    _buildColorIconButton(
                      label: 'Color de texto azul',
                      color: Colors.blue,
                      isSelected: textColor == Colors.blue,
                      onPressed: () => onTextColorChanged(Colors.blue),
                    ),
                    _buildColorIconButton(
                      label: 'Color de texto rojo',
                      color: Colors.red,
                      isSelected: textColor == Colors.red,
                      onPressed: () => onTextColorChanged(Colors.red),
                    ),
                    _buildColorIconButton(
                      label: 'Color de texto verde',
                      color: Colors.green,
                      isSelected: textColor == Colors.green,
                      onPressed: () => onTextColorChanged(Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildExpansionTile(
            title: 'Color de fondo de texto',
            children: [
              _buildListTile(
                subtitle: _buildRow(
                  children: [
                    _buildColorIconButton(
                      label: 'Color de fondo negro',
                      color: Colors.black,
                      isSelected: backgroundColor == Colors.black,
                      onPressed: () => onBackgroundColorChanged(Colors.black),
                    ),
                    _buildColorIconButton(
                      label: 'Color de fondo amarillo',
                      color: Colors.yellow,
                      isSelected: backgroundColor == Colors.yellow,
                      onPressed: () => onBackgroundColorChanged(Colors.yellow),
                    ),
                    _buildColorIconButton(
                      label: 'Sin color de fondo',
                      color: Colors.transparent,
                      isSelected: backgroundColor == Colors.transparent,
                      onPressed: () => onBackgroundColorChanged(Colors.transparent),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildExpansionTile(
            title: 'Color de fondo de la palabra actual',
            children: [
              _buildListTile(
                subtitle: _buildRow(
                  children: [
                    _buildColorIconButton(
                      label: 'Color de fondo de la palabra actual negro',
                      color: Colors.black,
                      isSelected: currentWordBackgroundColor == Colors.black,
                      onPressed: () => onCurrentWordBackgroundColorChanged(Colors.black),
                    ),
                    _buildColorIconButton(
                      label: 'Color de fondo de la palabra actual amarillo',
                      color: Colors.yellow,
                      isSelected: currentWordBackgroundColor == Colors.yellow,
                      onPressed: () => onCurrentWordBackgroundColorChanged(Colors.yellow),
                    ),
                    _buildColorIconButton(
                      label: 'Sin color de fondo de la palabra actual',
                      color: Colors.transparent,
                      isSelected: currentWordBackgroundColor == Colors.transparent,
                      onPressed: () => onCurrentWordBackgroundColorChanged(Colors.transparent),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildSwitchListTile(
            label: 'Mostrar original y traducción',
            value: showOriginalText,
            onChanged: onShowOriginalTextChanged,
          ),
          _buildExpansionTile(
            title: 'Velocidad de habla',
            children: [
              _buildListTile(
                subtitle: _buildRow(
                  children: [
                    _buildIconButton(
                      label: 'Disminuir velocidad de habla',
                      icon: Icons.remove,
                      onPressed: () => onSpeechRateChanged(speechRate > 0.5 ? speechRate - 0.1 : speechRate),
                    ),
                    Text(speechRate.toStringAsFixed(1)),
                    _buildIconButton(
                      label: 'Aumentar velocidad de habla',
                      icon: Icons.add,
                      onPressed: () => onSpeechRateChanged(speechRate < 2.0 ? speechRate + 0.1 : speechRate),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildSwitchListTile(
            label: 'Resaltar palabras',
            value: highlightWords,
            onChanged: onHighlightWordsChanged,
          ),
        ],
      ),
    );
  }

  ExpansionTile _buildExpansionTile({required String title, required List<Widget> children}) {
    return ExpansionTile(
      title: Text(title),
      children: children,
    );
  }

  ListTile _buildListTile({required Widget subtitle}) {
    return ListTile(
      subtitle: subtitle,
    );
  }

  Row _buildRow({required List<Widget> children}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    );
  }

  IconButton _buildIconButton({required String label, required IconData icon, Color? color, required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: onPressed,
      tooltip: label,
    );
  }

  IconButton _buildColorIconButton({required String label, required Color color, required bool isSelected, required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(Icons.format_paint, color: color),
      color: isSelected ? Colors.blue : Colors.black,
      onPressed: onPressed,
      tooltip: label,
    );
  }

  SwitchListTile _buildSwitchListTile({required String label, required bool value, required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}