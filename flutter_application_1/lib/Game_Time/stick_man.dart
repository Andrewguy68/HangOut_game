import 'package:flutter/material.dart';

class drawMan extends CustomPainter {
  final int frame; // Animation value to control line position
  drawMan(this.frame);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black // Line color
      ..style = PaintingStyle.stroke // Stroke style
      ..strokeWidth = 5.0; // Stroke width
    

    canvas.drawLine(Offset(25, 250), Offset(125, 250), paint); // Base
    canvas.drawLine(Offset(75, 250), Offset(75, 10), paint); // Pole
    canvas.drawLine(Offset(75, 10), Offset(150, 10), paint); // Top beam
    canvas.drawLine(Offset(150, 10), Offset(150, 50), paint); // Rope

    if (frame >= 1) {
      canvas.drawCircle(Offset(150, 75), 25, paint); // Head
    }
    if (frame >= 2) {
      canvas.drawLine(Offset(150, 100), Offset(150, 175), paint); // Body
      
    }
    if (frame >= 3) {
      canvas.drawLine(Offset(150, 115), Offset(125, 150), paint); // Left arm

    }
    if (frame >= 4) {
      canvas.drawLine(Offset(150, 115), Offset(175, 150), paint); // Right arm

    }
    if (frame >= 5) {
      canvas.drawLine(Offset(150, 175), Offset(125, 200), paint); // Left leg
    }
    if (frame >= 6) {
      canvas.drawLine(Offset(150, 175), Offset(175, 200), paint); // Right leg
    
    }
  }

  @override
  bool shouldRepaint(covariant drawMan oldDelegate) {
    return oldDelegate.frame != frame; // Repaint the line continuously
  }
}

  