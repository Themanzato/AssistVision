import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextBlockPainter extends CustomPainter {
  final List<TextBlock> textBlocks;
  final double _aspectRatio = 1.2 / 2.1;
  final double offsetX = -30; // --
  final double offsetY = -35;  // ||

  TextBlockPainter({required this.textBlocks});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final paint2 = Paint()
      ..color = Colors.red.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var block in textBlocks) {
      final blockRect = block.boundingBox;

      final adjustedRect2 = Rect.fromLTRB(
        blockRect.left * _aspectRatio + offsetX,
        blockRect.top * _aspectRatio + offsetY,
        blockRect.right * _aspectRatio + offsetX,
        blockRect.bottom * _aspectRatio + offsetY,
      );

      canvas.drawRect(adjustedRect2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
