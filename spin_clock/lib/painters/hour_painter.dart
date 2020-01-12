import 'package:flutter/material.dart';
import 'dart:math';
import 'package:spin_clock/theme.dart';

class HourPainter extends CustomPainter {
  double _radius;
  double _angle;
  double _borderWidth;
  double _height;
  bool is24HourFormat = true;
  final Map<ClockTheme, Color> colors;
  final DateTime dateTime;
  final double trackerPosition;
  final TextPainter _textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  HourPainter(this.is24HourFormat, this.colors,
      {this.dateTime, this.trackerPosition});

  @override
  void paint(Canvas canvas, Size size) {
    _borderWidth = size.width * 0.02;
    _angle = 2 * pi / 60;
    _radius = size.width / 2;
    _height = size.height;
    canvas.save();
    canvas.translate(size.width * 0.03,
        size.height * 0.9); // left margin 0.04, bottom margin 0.06
    _drawHourDigits(canvas: canvas, digitOffset: 3);
    canvas.translate(size.width * 0.94,
        -size.height * 0.8); // right margin 0.04, top margin 0.06
    _drawMarker(canvas: canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(HourPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.is24HourFormat != is24HourFormat ||
        oldDelegate.trackerPosition != trackerPosition;
  }

  void _drawMarker({Canvas canvas}) {
    canvas.translate(-_radius * 1 / 15, _radius * 5 / 9);
    final style = TextStyle(
        color: colors[ClockTheme.currentGrayScale],
        fontFamily: 'PoppinsMedium',
        fontSize: _height / 8.25,
        fontWeight: FontWeight.w200);
    String marker = '';
    if (dateTime.hour == 23 && dateTime.minute == 59 && trackerPosition == 1) {
      marker = "AM";
    } else if (dateTime.hour == 11 &&
        dateTime.minute == 59 &&
        trackerPosition == 1) {
      marker = "PM";
    } else {
      marker = dateTime.hour >= 12 ? "PM" : "AM";
    }
    _textPainter.text = TextSpan(text: marker, style: style);
    _textPainter.layout();
    var painterOffset =
        new Offset(-(_textPainter.width / 2), -(_textPainter.height / 2));
    _textPainter.paint(canvas, painterOffset);
  }

  int _hourText({int i, int digitOffset}) {
    if (is24HourFormat) {
      int text = (i + digitOffset) ~/ 5 + dateTime.hour - 2;
      if (text <= 0) {
        return text + 12;
      } else if (text >= 24) {
        return text - 24;
      } else {
        return text;
      }
    }
    // text offset by digitOffset on the clock
    final hour = (dateTime.hour > 12) ? (dateTime.hour - 12) : dateTime.hour;
    int hourOffset = hour - 2;
    int text = (i + digitOffset) ~/ 5 + hourOffset;
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
    canvas.rotate(-_angle * 5 * trackerPosition);
    for (var i = 0; i < 60; i++) {
      _drawHourDigit(canvas: canvas, i: i, digitOffset: digitOffset);
      canvas.rotate(_angle);
    }
    canvas.restore();
  }

  void _drawHourDigit({Canvas canvas, int i, int digitOffset}) {
    if ((i + digitOffset) % 5 != 0) {
      return;
    }
    String hourText =
        '${_hourText(i: i, digitOffset: digitOffset).toString().padLeft(2, '0')}';
    debugPrint('$i $hourText');
    int fontSize = _height ~/ 3 - 13;
    canvas.save();
    canvas.translate(0.0, -_radius + _borderWidth + 14);
    int grayScale = colors[ClockTheme.currentGrayScale].red; // 51 240
    int hourGrayScale = colors[ClockTheme.hourGrayScale].red; // 153 216
    if (i == 7) {
      // largest digit for current hour
      int currentGrayScale = grayScale +
          ((hourGrayScale - grayScale) * trackerPosition)
              .toInt(); // 51->153, 240->180
      final textStyle = TextStyle(
          color: Color.fromRGBO(
              currentGrayScale, currentGrayScale, currentGrayScale, 1),
          fontFamily: 'PoppinsMedium',
          fontWeight: trackerPosition > 0.5 ? FontWeight.w200 : FontWeight.w400,
          fontSize: 13.0 + fontSize * (1 - trackerPosition));
      canvas.translate(_height / 33 * (1 - trackerPosition),
          _height / 5.5 * (1 - trackerPosition));
      _textPainter.text = TextSpan(text: hourText, style: textStyle);
    } else if (i == 12) {
      // next up largest digit
      int currentGrayScale = hourGrayScale +
          ((grayScale - hourGrayScale) * trackerPosition)
              .toInt(); // 153->51, 180->240
      final textStyle = TextStyle(
          color: Color.fromRGBO(
              currentGrayScale, currentGrayScale, currentGrayScale, 1),
          fontFamily: 'PoppinsMedium',
          fontWeight: trackerPosition > 0.5 ? FontWeight.w400 : FontWeight.w200,
          fontSize: 13 + (fontSize) * trackerPosition);
      canvas.translate(
          _height / 33 * trackerPosition, _height / 5.5 * trackerPosition);
      _textPainter.text = TextSpan(text: hourText, style: textStyle);
    } else {
      _textPainter.text = new TextSpan(
          text: hourText,
          style: TextStyle(
              color: colors[ClockTheme.hourGrayScale],
              fontFamily: 'PoppinsRegular',
              fontWeight: FontWeight.w200,
              fontSize: 13.0));
    }
    canvas.rotate(-_angle * i + _angle * 5 * trackerPosition);
    _textPainter.layout();
    var painterOffset =
        new Offset(-(_textPainter.width / 2), -(_textPainter.height / 2));
    _textPainter.paint(canvas, painterOffset);
    canvas.restore();
  }
}
