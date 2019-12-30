import 'package:flutter/material.dart';
import 'dart:math';
import 'theme.dart';

class ClockFacesPainter extends CustomPainter {
  double radius;
  double angle;
  double borderWidth;
  final Map<ClockTheme, Color> colors;
  final Paint dialPaint = new Paint();

  ClockFacesPainter(this.colors);

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
    dialPaint.color = colors[ClockTheme.secondBorder];
    canvas.drawCircle(Offset(0, 0), 0.177*size.width+1, dialPaint);
    dialPaint.color = colors[ClockTheme.secondFace];
    canvas.drawCircle(Offset(0, 0), 0.177*size.width, dialPaint);
  }

  @override
  bool shouldRepaint(ClockFacesPainter oldDelegate) {
    return oldDelegate.colors != colors; 
  }

  void _drawColon(Canvas canvas, Size size) {
    canvas.save();
    dialPaint.color = colors[ClockTheme.colon];
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
        ..color = colors[ClockTheme.shadow]
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 40)
    );
    dialPaint.color = colors[ClockTheme.border];
    canvas.drawCircle(center, radius, dialPaint);
    dialPaint.color = colors[ClockTheme.face];
    canvas.drawCircle(center, radius-borderWidth, dialPaint);
    
    // draw lines
    dialPaint.color = colors[ClockTheme.dialLine];
    dialPaint.strokeWidth = 0.5;
    int gray = colors[ClockTheme.dialLineGrayScale].red;
    bool islightMode = colors == lightMode;
    for (var i = 0; i < 60; i++ ) {
      int difference = hourMode ? (7-i).abs() : (38-i).abs();
      int grayScale = islightMode ? gray+15*difference: gray-20*difference;
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