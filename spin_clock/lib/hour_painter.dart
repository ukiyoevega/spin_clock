import 'package:flutter/material.dart';
import 'dart:math';

class HourPainter extends CustomPainter {
  final double trackerPosition;
  double radius;
  double angle;
  double borderWidth;
  final DateTime dateTime;
  final TextPainter textPainter = TextPainter(textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

  HourPainter({this.dateTime, this.trackerPosition});

  @override
  void paint(Canvas canvas, Size size) {
    borderWidth = size.width*0.02; 
    angle = 2 * pi / 60;
    radius = size.width/2;
    canvas.save();
    canvas.translate(size.width*0.04, size.height*0.94); // left margin 0.04, bottom margin 0.06
    _drawHourDigits(canvas: canvas, digitOffset: 3);
    canvas.translate(size.width*0.92, -size.height*0.88); // right margin 0.04, top margin 0.06
    _drawMarker(canvas: canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(HourPainter oldDelegate) {
    return true;
  }
  
  final hourTextStyle = TextStyle(color: Color(0xFF999999), fontFamily: 'Poppins', fontWeight: FontWeight.w200, fontSize:13.0);
  final largeTextStyle = TextStyle(color: Color(0xFF333333), fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize:115.0);

  void _drawMarker({Canvas canvas}) {
    canvas.translate(-radius*1/12, radius*5/9);
    final style = TextStyle(color: Color(0xFF333333), fontFamily: 'Poppins', fontSize: 40, fontWeight: FontWeight.w200);
    textPainter.text= TextSpan(text: dateTime.hour > 12 ? " PM" : " AM", style: style);
    textPainter.layout();
    var painterOffset = new Offset(-(textPainter.width/2), -(textPainter.height/2));
    textPainter.paint(canvas, painterOffset);
  }

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

  void _drawHourDigits({Canvas canvas, int digitOffset}) {
    for (var i = 0; i < 60; i++ ) {
      _drawHourDigit(canvas: canvas, i: i, digitOffset: digitOffset);
      canvas.rotate(angle);
    }
  }

  void _drawHourDigit({Canvas canvas, int i, int digitOffset}) {
    if ((i+digitOffset)%5!=0) { return; }
    int hourText = _hourText(i: i, digitOffset: digitOffset);
    int currentHour = (dateTime.hour > 12) ? (dateTime.hour - 12) : dateTime.hour;
    bool isCurrentHour = hourText == currentHour;
    // 5 lines per digit in hour mode
    canvas.save();
    canvas.translate(0.0, -radius+borderWidth+14);
    if (isCurrentHour) { canvas.translate(10, 60); }
      textPainter.text= new TextSpan(text: '$hourText',
        style: isCurrentHour ? largeTextStyle : hourTextStyle);
    canvas.rotate(-angle*i);
    textPainter.layout();
    var painterOffset = new Offset(-(textPainter.width/2), -(textPainter.height/2));
    textPainter.paint(canvas, painterOffset);
    canvas.restore();
  }
}