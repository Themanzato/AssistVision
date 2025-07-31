import 'package:flutter/material.dart';

class DocumentMarginPainter extends CustomPainter {
  final Rect? margin;

  DocumentMarginPainter({this.margin});

  @override
  void paint(Canvas canvas, Size size) {
    if (margin != null) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      
      canvas.drawRect(margin!, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}