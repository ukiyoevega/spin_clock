import 'package:flutter/material.dart';
import 'dart:math';

class DialPainter extends CustomPainter {
  final double trackerPosition;
  double radius;
  double angle;
  double borderWidth;
  final DateTime dateTime;
  final TextPainter textPainter = TextPainter(textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

  DialPainter({this.dateTime, this.trackerPosition});

  @override
  void paint(Canvas canvas, Size size) {
    borderWidth = size.width*0.02; 
    angle = 2 * pi / 60;
    radius = size.width/2;
    canvas.save();

    canvas.translate(size.width*0.04, size.height*0.94); // left margin 0.04, bottom margin 0.06
    _drawHourDigits(canvas: canvas, digitOffset: 3);
    canvas.translate(size.width*0.92, -size.height*0.88); // right margin 0.04, top margin 0.06
    _drawMinuteDigits(canvas: canvas);
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

  void _drawMinuteDigits({Canvas canvas}) {
    canvas.save();
    canvas.rotate(-angle*trackerPosition);
    for (var i = 0; i < 60; i++ ) {
      _drawMinuteDigit(canvas: canvas, i: i);
      canvas.rotate(angle);
    }
    canvas.restore();
  }

  void _drawHourDigits({Canvas canvas, int digitOffset}) {
    for (var i = 0; i < 60; i++ ) {
      _drawHourDigit(canvas: canvas, i: i, digitOffset: digitOffset);
      canvas.rotate(angle);
    }
  }

  void _drawMinuteDigit({Canvas canvas, int i}) {
    var minuteText = _minuteText(i: i);
    canvas.save();
    canvas.translate(0.0, -radius+borderWidth+14);
    // i  = 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45
    // dif = 8  7  6  5  4  3  2  1  0  1  2  3  4  5  6  7
    final difference = (38-i).abs();
    final grayScale = 51+20*difference;
    if (i == 38) { // largest digit for current minute
      int currentGrayScale = grayScale+20*trackerPosition.toInt(); // 51->71
      TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize:115.0);
      final textStyle = TextStyle(color: Color.fromRGBO(currentGrayScale, currentGrayScale, currentGrayScale, 1), 
          fontFamily: 'Poppins', 
          fontWeight: trackerPosition == 1 ? FontWeight.w200 : FontWeight.w400, 
          fontSize: 10.0+105.0*(1-trackerPosition));
        canvas.translate(-30*(1-trackerPosition), 120*(1-trackerPosition)); 
        textPainter.text= TextSpan(text: '${minuteText.toString().padLeft(2, '0')}', style: textStyle);
    } else if (i == 39) { // next up largest digit
      int currentGrayScale = grayScale-20*trackerPosition.toInt(); // 71->51
      final textStyle = TextStyle(color: Color.fromRGBO(currentGrayScale, currentGrayScale, currentGrayScale, 1), 
        fontFamily: 'Poppins', 
        fontWeight: FontWeight.w400, 
        fontSize: 10+105.0*trackerPosition);
      canvas.translate(-30*trackerPosition, 120*trackerPosition); 
      textPainter.text= TextSpan(text: '${minuteText.toString().padLeft(2, '0')}', style: textStyle);
    } else {
      final color = Color.fromRGBO(grayScale, grayScale, grayScale, 1);
      textPainter.text= new TextSpan(
        text: '${minuteText.toString().padLeft(2, '0')}', 
        style:  minuteTextStyle.copyWith(color: color));
    }
    canvas.rotate(-angle*i+angle*trackerPosition);
    textPainter.layout();
    var painterOffset = new Offset(-(textPainter.width/2), -(textPainter.height/2));
    textPainter.paint(canvas, painterOffset);
    canvas.restore();
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