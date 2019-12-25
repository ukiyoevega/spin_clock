import 'package:flutter/material.dart';
import 'dart:math';

class HourPainter extends CustomPainter {
  double _radius;
  double _angle;
  double _borderWidth;
  final DateTime dateTime;
  final double trackerPosition;
  final TextPainter _textPainter = TextPainter(textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

  HourPainter({this.dateTime, this.trackerPosition});

  @override
  void paint(Canvas canvas, Size size) {
    _borderWidth = size.width*0.02; 
    _angle = 2 * pi / 60;
    _radius = size.width/2;
    canvas.save();
    canvas.translate(size.width*0.03, size.height*0.9); // left margin 0.04, bottom margin 0.06
    _drawHourDigits(canvas: canvas, digitOffset: 3);
    canvas.translate(size.width*0.94, -size.height*0.8); // right margin 0.04, top margin 0.06
    _drawMarker(canvas: canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(HourPainter oldDelegate) {
    return true;
  }
  
  void _drawMarker({Canvas canvas}) {
    canvas.translate(-_radius*1/15, _radius*5/9);
    final style = TextStyle(color: Color(0xFF333333), fontFamily: 'Poppins', fontSize: 40, fontWeight: FontWeight.w200);
    _textPainter.text= TextSpan(text: dateTime.hour > 12 ? " PM" : " AM", style: style);
    _textPainter.layout();
    var painterOffset = new Offset(-(_textPainter.width/2), -(_textPainter.height/2));
    _textPainter.paint(canvas, painterOffset);
  }

  int _hourText({int i, int digitOffset}) { // text offset by digitOffset on the clock
    final hour = (dateTime.hour > 12) ? (dateTime.hour - 12) : dateTime.hour;
    int hourOffset = hour - 2;
    int text = (i+digitOffset)~/5 + hourOffset;
    if (text > 12) {
      return text - 12;
    } else if (text <= 0) {
      return text + 12;
    } else {
      return text;
    }
  }

  void _drawHourDigits({Canvas canvas, int digitOffset}) {
    canvas.save();
    canvas.rotate(-_angle*5*trackerPosition);
    for (var i = 0; i < 60; i++ ) {
      _drawHourDigit(canvas: canvas, i: i, digitOffset: digitOffset);
      canvas.rotate(_angle);
    }
    canvas.restore();
  }

  void _drawHourDigit({Canvas canvas, int i, int digitOffset}) {
    if ((i+digitOffset)%5!=0) { return; }
    int hourText = _hourText(i: i, digitOffset: digitOffset);
    canvas.save();
    canvas.translate(0.0, -_radius+_borderWidth+14);
    if (i == 7) { // largest digit for current hour
      int currentGrayScale = 51+102*trackerPosition.toInt(); // 51->153
      final textStyle = TextStyle(color: Color.fromRGBO(currentGrayScale, currentGrayScale, currentGrayScale, 1), 
          fontFamily: 'Poppins', 
          fontWeight: trackerPosition > 0.5 ? FontWeight.w200 : FontWeight.w400, 
          fontSize: 13.0+102.0*(1-trackerPosition));
      canvas.translate(10*(1-trackerPosition), 60*(1-trackerPosition)); 
      _textPainter.text= TextSpan(text: '$hourText', style: textStyle);
    } else if (i == 12) { // next up largest digit
      int currentGrayScale = 153-102*trackerPosition.toInt(); // 153->51
      final textStyle = TextStyle(color: Color.fromRGBO(currentGrayScale, currentGrayScale, currentGrayScale, 1), 
        fontFamily: 'Poppins', 
        fontWeight: trackerPosition > 0.5 ? FontWeight.w400 : FontWeight.w200,
        fontSize: 13+102.0*trackerPosition);
      canvas.translate(10*trackerPosition, 60*trackerPosition); 
      _textPainter.text= TextSpan(text: '$hourText', style: textStyle);
    } else {
      _textPainter.text= new TextSpan(text: '$hourText',
        style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1), 
          fontFamily: 'Poppins', fontWeight: FontWeight.w200, fontSize:13.0));
    }
    canvas.rotate(-_angle*i+_angle*5*trackerPosition);
    _textPainter.layout();
    var painterOffset = new Offset(-(_textPainter.width/2), -(_textPainter.height/2));
    _textPainter.paint(canvas, painterOffset);
    canvas.restore();
  }
}