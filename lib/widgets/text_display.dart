import 'package:flutter/material.dart';

class TextDisplay extends StatelessWidget {
  final TextEditingController textEditingController;
  final double textSize;
  final double lineHeight;
  final TextAlign textAlign;
  final Color textColor;
  final Color backgroundColor;
  final int currentWordIndex;

  const TextDisplay({
    super.key,
    required this.textEditingController,
    required this.textSize,
    required this.lineHeight,
    required this.textAlign,
    required this.textColor,
    required this.backgroundColor,
    required this.currentWordIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: TextField(
        controller: textEditingController,
        maxLines: null,
        style: TextStyle(
          fontSize: textSize,
          height: lineHeight,
          color: textColor,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}