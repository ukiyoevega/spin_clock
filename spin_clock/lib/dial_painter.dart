import 'package:flutter/material.dart';
import 'dart:math';

class DialPainter extends CustomPainter {
  final double trackerPosition;
  final Paint trackerPaint = new Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;
  double radius;
  double angle;
  double borderWidth;
  final TextPainter textPainter = TextPainter(textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

  DialPainter({this.trackerPosition});

  @override
  void paint(Canvas canvas, Size size) {
    borderWidth = size.width*0.02; 
    angle = 2 * pi / 60;
    radius = size.width/2;
    canvas.save();

    canvas.translate(size.width*0.04, size.height*0.94); // left margin 0.04, bottom margin 0.06
    _drawDigits(canvas: canvas, digitOffset: 3);
    _drawTracker(canvas);
    canvas.translate(size.width*0.92, -size.height*0.88); // right margin 0.04, top margin 0.06
    _drawDigits(hourMode: false, canvas: canvas, digitOffset: 0);
    _drawTracker(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(DialPainter oldDelegate) {
    return true;
  }
  
  final hourTextStyle = TextStyle(color: Color(0xFF999999), fontFamily: 'Poppins', fontWeight: FontWeight.w200, fontSize:13.0);
  final minuteTextStyle = TextStyle(color: Color(0xFF999999), fontFamily: 'Poppins', fontWeight: FontWeight.w200, fontSize:10.0);
  final largeTextStyle = TextStyle(color: Color(0xFF333333), fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize:115.0);

  int _hourText({int i, int digitOffset}) { // text offset by digitOffset on the clock
    final hour = (dateTime.hour > 12) ? (dateTime.hour - 12) : dateTime.hour;
    int hourOffset = hour - 2;
    int text = (i+digitOffset)~/5;
    if (text + hourOffset > 12) {
      return text + hourOffset - 12;
    } else {
      return text + hourOffset;
    }
  }

  int _minuteText({int i}) {
    int minuteOffset = dateTime.minute - 38;
    if (minuteOffset + i < 0) {
      return minuteOffset + i + 60;
    } else if (minuteOffset + i >= 60) {
      return minuteOffset + i - 60;
    } else {
      return minuteOffset + i;
    }
  }

  void _drawDigit({bool hourMode = true, Canvas canvas, int i, int digitOffset}) {
    int hourText = _hourText(i: i, digitOffset: digitOffset);
    int currentHour = (dateTime.hour > 12) ? (dateTime.hour - 12) : dateTime.hour;
    int minuteText = _minuteText(i: i);
    bool isCurrentHour = hourText == currentHour;
    bool isCurrentMinute = minuteText == dateTime.minute;
    // 5 lines per digit in hour mode
    if (hourMode && (i+digitOffset)%5!=0) { return; }
    canvas.save();
    canvas.translate(0.0, -radius+borderWidth+14);
    if (hourMode) {
      if (isCurrentHour) { canvas.translate(10, 60); }
      textPainter.text= new TextSpan(text: '$hourText',
        style: isCurrentHour ? largeTextStyle : hourTextStyle);
    } else {
      if (isCurrentMinute) { canvas.translate(-30, 120); }
      textPainter.text= new TextSpan(
        text: '${minuteText.toString().padLeft(2, '0')}', 
        children: isCurrentMinute ? [TextSpan(text: dateTime.hour > 12 ? " PM" : " AM", style: largeTextStyle.copyWith(fontSize: 35, fontWeight: FontWeight.w200))]: [],
        style: isCurrentMinute ? largeTextStyle : minuteTextStyle);
    }
    canvas.rotate(-angle*i);
    textPainter.layout();
    var painterOffset = new Offset(-(textPainter.width/2), -(textPainter.height/2));
    textPainter.paint(canvas, painterOffset);
    canvas.restore();
  }

  void _drawDigits({bool hourMode = true, Canvas canvas, int digitOffset}) {
    for (var i = 0; i < 60; i++ ) {
      _drawDigit(hourMode: hourMode, canvas: canvas, i: i, digitOffset: digitOffset);
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