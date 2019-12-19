import 'package:flutter/material.dart';
import 'dart:math';

class ClockFacePainter extends CustomPainter {
  final double trackerPosition;
  final Paint trackerPaint = new Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;
  double radius;
  double angle;
  double borderWidth;
  final Paint dialPaint = new Paint();
  final TextPainter textPainter = TextPainter(textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        );

  ClockFacePainter({this.trackerPosition});

  @override
  void paint(Canvas canvas, Size size) {
    borderWidth = size.width*0.02; 
    angle = 2 * pi / 60;
    radius = size.width/2;
    canvas.save();

    canvas.translate(size.width*0.05, size.height);
    _drawClockFace(canvas: canvas, digitOffset: 3);
    _drawTracker(canvas);
    canvas.translate(size.width*0.9, -size.height);
    _drawClockFace(hourMode: false, canvas: canvas, digitOffset: 0);
    _drawTracker(canvas);

    canvas.restore();
  }

  @override
  bool shouldRepaint(ClockFacePainter oldDelegate) {
    return true;
  }

  void _drawDigit({bool hourMode = true, Canvas canvas, int i, int digitOffset}) {
    canvas.save();
    canvas.translate(0.0, -radius+borderWidth+14);
    textPainter.text= new TextSpan(
      text: hourMode ? '${i+digitOffset == 0 ? 12 : (i+digitOffset)~/5}' : '$i',
      style: TextStyle(fontFamily: 'Poppins', fontSize: hourMode ? 20.0 : 10),
    );
    canvas.rotate(-angle*i);
    textPainter.layout();
    var painterOffset = new Offset(-(textPainter.width/2), -(textPainter.height/2));
    textPainter.paint(canvas, painterOffset);
    canvas.restore();
  }

  void _drawClockFace({bool hourMode = true, Canvas canvas, int digitOffset}) {
    dialPaint.color = Color(0xFFFAFAFA);
    canvas.drawCircle(Offset(0.0, 0.0), radius, dialPaint);
    dialPaint.color = Colors.white;
    canvas.drawCircle(Offset(0.0, 0.0), radius-borderWidth, dialPaint);
    dialPaint.color = Color(0xFF999999);
    for (var i = 0; i < 60; i++ ) {
      dialPaint.strokeWidth = 0.5;
      canvas.drawLine(
          new Offset(0.0, -radius), new Offset(0.0, -radius+borderWidth), dialPaint);
      if (hourMode) {
        if ((i+digitOffset)%5==0){
        _drawDigit(canvas: canvas, i: i, digitOffset: digitOffset);
       }
      } else {
        _drawDigit(hourMode: false, canvas: canvas, i: i, digitOffset: digitOffset);
      }
      canvas.rotate(angle);
    }
  }

  void _drawTracker(Canvas canvas) {
    final trackerAngle = 2 * pi * trackerPosition - (pi / 2);
    final x = cos(trackerAngle) * radius ;
    final y = sin(trackerAngle) * radius ;
    final center = new Offset(x, y);
    canvas.drawCircle(center, 10.0, trackerPaint);
    debugPrint('position $trackerPosition center $Offset(x, y) angle $trackerAngle');
  }
}