import 'package:flutter/material.dart';
import 'dart:math';

class ClockFacesPainter extends CustomPainter {
  double radius;
  double angle;
  double borderWidth;
  final Paint dialPaint = new Paint();

  @override
  void paint(Canvas canvas, Size size) {
    borderWidth = size.width*0.02; 
    angle = 2 * pi / 60;
    radius = size.width/2;
    canvas.save();

    canvas.translate(size.width*0.04, size.height*0.94); // left margin 0.04, bottom margin 0.06
    _drawClockFace(canvas: canvas, digitOffset: 3);
    canvas.translate(size.width*0.92, -size.height*0.88); // right margin 0.04, top margin 0.06
    _drawClockFace(hourMode: false, canvas: canvas, digitOffset: 0);

    canvas.restore();
  }

  @override
  bool shouldRepaint(ClockFacesPainter oldDelegate) {
    return false;
  }

  void _drawClockFace({bool hourMode = true, Canvas canvas, int digitOffset}) {
    Offset center = Offset(0.0, 0.0);
    canvas.drawPath(
       Path()
          ..addOval(
              Rect.fromCircle(center: center, radius: radius+10))
          ..fillType = PathFillType.evenOdd,
        Paint() 
        ..color= Colors.black.withAlpha(30)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 40)
    );
    dialPaint.color = Color(0xFFFAFAFA);
    canvas.drawCircle(center, radius, dialPaint);
    dialPaint.color = Colors.white;
    canvas.drawCircle(center, radius-borderWidth, dialPaint);
    
    // draw lines
    dialPaint.color = Color(0xFF999999);
    dialPaint.strokeWidth = 0.5;
    for (var i = 0; i < 60; i++ ) {
      int difference = hourMode ? (7-i).abs() : (38-i).abs();
      int grayScale = 100+15*difference;
      dialPaint.color = Color.fromRGBO(grayScale, grayScale, grayScale, 1);
      bool isCurrentHour = !hourMode && i==38;
      bool isCurrentMinute = hourMode && i==7;
      if (isCurrentHour || isCurrentMinute) {
        canvas.drawLine(new Offset(0.0, -radius), new Offset(0.0, -radius+borderWidth+16), dialPaint);
      } else {
        canvas.drawLine(
          new Offset(0.0, -radius), new Offset(0.0, -radius+borderWidth), dialPaint); 
      } 
      canvas.rotate(angle);
    }
  }
}