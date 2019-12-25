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
    _drawColon(canvas, size);
    canvas.translate(size.width*0.03, size.height*0.9); // left margin 0.04, bottom margin 0.06 // 0.1
    _drawClockFace(canvas: canvas, digitOffset: 3);
    canvas.translate(size.width*0.94, -size.height*0.8); // right margin 0.04, top margin 0.06
    _drawClockFace(hourMode: false, canvas: canvas, digitOffset: 0);
    canvas.restore();
    canvas.translate(size.width*0.98, 0); 
    dialPaint.color = Color(0xFFEEEBEB);
    canvas.drawCircle(Offset(0, 0), 0.177*size.width+1, dialPaint);
    dialPaint.color = Color(0xFFFDFDFD);
    canvas.drawCircle(Offset(0, 0), 0.177*size.width, dialPaint);
  }

  @override
  bool shouldRepaint(ClockFacesPainter oldDelegate) {
    return false;
  }

  void _drawColon(Canvas canvas, Size size) {
    canvas.save();
    dialPaint.color = Color(0xFF333333);
    canvas.translate(size.width/2, size.height/2);
    canvas.translate(5, 20);
    canvas.drawCircle(Offset(0, 0), 5, dialPaint);
    canvas.translate(-10, -40);
    canvas.drawCircle(Offset(0, 0), 5, dialPaint);
    canvas.restore();
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