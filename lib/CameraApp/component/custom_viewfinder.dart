import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewfinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.w;

    final double cornerLength = 40.w;
    final double padding = 30.w;

    // Top left corner
    canvas.drawLine(Offset(padding, padding), Offset(padding + cornerLength, padding), paint);
    canvas.drawLine(Offset(padding, padding), Offset(padding, padding + cornerLength), paint);

    // Top right corner
    canvas.drawLine(Offset(size.width - padding, padding), Offset(size.width - padding - cornerLength, padding), paint);
    canvas.drawLine(Offset(size.width - padding, padding), Offset(size.width - padding, padding + cornerLength), paint);

    // Bottom left corner
    canvas.drawLine(Offset(padding, size.height - padding), Offset(padding + cornerLength, size.height - padding), paint);
    canvas.drawLine(Offset(padding, size.height - padding), Offset(padding, size.height - padding - cornerLength), paint);

    // Bottom right corner
    canvas.drawLine(Offset(size.width - padding, size.height - padding), Offset(size.width - padding - cornerLength, size.height - padding), paint);
    canvas.drawLine(Offset(size.width - padding, size.height - padding), Offset(size.width - padding, size.height - padding - cornerLength), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}