import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleWithBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Color circleColor = Colors.teal.shade300;
    final Paint outerPaint = Paint()
      ..color = circleColor // 외부 원 색상
      ..style = PaintingStyle.fill;

    //외부 원 테두리 높이 여기서 변경
    canvas.drawCircle(Offset(radius, radius), radius + 4.0, outerPaint );


    double tempWidth = 5.sp;
    final Paint whiteBorderPaint = Paint()
      ..color = Colors.white // 하얀 테두리 색상
      ..style = PaintingStyle.stroke
      ..strokeWidth = tempWidth; // 테두리 두께

    canvas.drawCircle(Offset(radius, radius), radius - tempWidth/2, whiteBorderPaint);

    final Paint innerPaint = Paint()
      ..color = circleColor // 내부 원 색상
      ..style = PaintingStyle.fill;

    //하얀 테두리는 5 증가시키면 됨
    canvas.drawCircle(Offset(radius, radius), radius - 5, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}