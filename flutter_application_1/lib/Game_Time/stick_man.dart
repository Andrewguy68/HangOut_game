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
    

    canvas.drawLine(Offset(2, 200), Offset(125, 200), paint); // Base
    canvas.drawLine(Offset(7, 200), Offset(75, 50), paint); // Pole
    canvas.drawLine(Offset(7, 50), Offset(150, 50), paint); // Top beam
    canvas.drawLine(Offset(15, 50), Offset(150, 75), paint); // Rope

    if (frame == 1) {
      canvas.drawCircle(Offset(150, 100), 25, paint); // Head
    }
    else if (frame == 2) {
      canvas.drawCircle(Offset(150, 100), 25, paint); // Head
      canvas.drawLine(Offset(150, 125), Offset(150, 175), paint); // Body
      
    }
    else if (frame == 3) {
      canvas.drawCircle(Offset(150, 100), 25, paint); // Head
      canvas.drawLine(Offset(150, 125), Offset(150, 175), paint); // Body
      canvas.drawLine(Offset(150, 125), Offset(125, 150), paint); // Left arm

    }
    else if (frame == 4) {
      canvas.drawCircle(Offset(150, 100), 25, paint); // Head
      canvas.drawLine(Offset(150, 125), Offset(150, 175), paint); // Body
      canvas.drawLine(Offset(150, 125), Offset(125, 150), paint); // Left arm
      canvas.drawLine(Offset(150, 125), Offset(175, 150), paint); // Right arm

    }
    else if (frame == 5) {
      canvas.drawCircle(Offset(150, 100), 25, paint); // Head
      canvas.drawLine(Offset(150, 125), Offset(150, 175), paint); // Body
      canvas.drawLine(Offset(150, 125), Offset(125, 150), paint); // Left arm
      canvas.drawLine(Offset(150, 125), Offset(175, 150), paint); // Right arm
      canvas.drawLine(Offset(150, 175), Offset(125, 200), paint); // Left leg
    }
    else if (frame == 6) {
      canvas.drawCircle(Offset(150, 100), 25, paint); // Head
      canvas.drawLine(Offset(150, 125), Offset(150, 175), paint); // Body
      canvas.drawLine(Offset(150, 125), Offset(125, 150), paint); // Left arm
      canvas.drawLine(Offset(150, 125), Offset(175, 150), paint); // Right arm
      canvas.drawLine(Offset(150, 175), Offset(125, 200), paint); // Left leg
      canvas.drawLine(Offset(150, 175), Offset(175, 200), paint); // Right leg
    }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint the line continuously
  }
  
}