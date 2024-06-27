import 'package:flutter/material.dart';

class MyBoxPainter extends CustomPainter {
  final Map<String, dynamic> dataMap;
  final int originalWidth;
  final int originalHeight;

  MyBoxPainter({
    required this.dataMap,
    required this.originalWidth,
    required this.originalHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // final paint = Paint()
    //   ..color = Colors.red
    //   ..strokeWidth = 2.0
    //   ..style = PaintingStyle.stroke;

    List<List<double>> boxes = List<List<double>>.from(dataMap['boxes']);
    double scaleX = size.width / originalWidth;
    double scaleY = size.height / originalHeight;

    for (int i = 0; i < boxes.length; i++) {
      var box = boxes[i];
      double xmin = box[0] * scaleX;
      double ymin = box[1] * scaleY;
      double xmax = box[2] * scaleX;
      double ymax = box[3] * scaleY;

      // 색상을 조건에 따라 변경
      final paint = Paint()
        ..color = i == 0 ? Colors.red : Colors.green
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      Rect rect = Rect.fromLTRB(xmin, ymin, xmax, ymax);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}