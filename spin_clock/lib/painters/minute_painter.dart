import 'package:flutter/material.dart';
import 'dart:math';
import 'package:spin_clock/theme.dart';

class MinutePainter extends CustomPainter {
  final double trackerPosition;
  double _radius;
  double _angle;
  double _height;
  double _borderWidth;
  final Map<ClockTheme, Color> colors;
  final DateTime dateTime;
  final TextPainter _textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  final _minuteTextStyle = TextStyle(
      fontFamily: 'PoppinsRegular',
      fontWeight: FontWeight.w200,
      fontSize: 10.0);

  MinutePainter(this.colors, {this.dateTime, this.trackerPosition});

  @override
  void paint(Canvas canvas, Size size) {
    _borderWidth = size.width * 0.02;
    _angle = 2 * pi / 60;
    _radius = size.width / 2;
    _height = size.height;
    canvas.save();

    canvas.translate(size.width * 0.03,
        size.height * 0.9); // left margin 0.04, bottom margin 0.06
    canvas.translate(size.width * 0.94,
        -size.height * 0.8); // right margin 0.04, top margin 0.06
    _drawMinuteDigits(canvas: canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(MinutePainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.trackerPosition != trackerPosition;
  }

  int _minuteText({int i}) {
    int minuteOffset = dateTime.minute - 38;
    int text = minuteOffset + i;
    if (text < 0) {
      return text + 60;
    } else if (text >= 60) {
      return text - 60;
    } else {
      return text;
    }
  }

  void _drawMinuteDigits({Canvas canvas}) {
    canvas.save();
    canvas.rotate(-_angle * trackerPosition);
    int gray = colors[ClockTheme.currentGrayScale].red;
    bool islightMode = colors == lightMode;
    for (var i = 0; i < 60; i++) {
      _drawMinuteDigit(islightMode, canvas: canvas, i: i, middleGray: gray);
      canvas.rotate(_angle);
    }
    canvas.restore();
  }

  void _drawMinuteDigit(bool isLightMode,
      {Canvas canvas, int i, int middleGray}) {
    var minuteText = _minuteText(i: i);
    int fontSize = _height ~/ 3 - 10;
    canvas.save();
    canvas.translate(0.0, -_radius + _borderWidth + 14);
    // i  = 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45
    // dif = 8  7  6  5  4  3  2  1  0  1  2  3  4  5  6  7
    final difference = (38 - i).abs();
    final grayScale = isLightMode
        ? middleGray + 15 * difference
        : middleGray - 15 * difference;
    if (i == 38) {
      // largest digit for current minute
      int currentGrayScale = isLightMode
          ? grayScale + 20 * trackerPosition.toInt()
          : grayScale - 20 * trackerPosition.toInt(); // 51->71, 255->235
      final textStyle = TextStyle(
          color: Color.fromRGBO(
              currentGrayScale, currentGrayScale, currentGrayScale, 1),
          fontFamily: 'PoppinsMedium',
          fontWeight: trackerPosition > 0.5 ? FontWeight.w200 : FontWeight.w400,
          fontSize: 10.0 + fontSize * (1 - trackerPosition));
      canvas.translate(-_height / 22 * (1 - trackerPosition),
          _height / 4 * (1 - trackerPosition));
      _textPainter.text = TextSpan(
          text: '${minuteText.toString().padLeft(2, '0')}', style: textStyle);
    } else if (i == 39) {
      // next up largest digit
      int currentGrayScale = isLightMode
          ? grayScale - 20 * trackerPosition.toInt()
          : grayScale + 20 * trackerPosition.toInt(); // 71->51, 235->255
      final textStyle = TextStyle(
          color: Color.fromRGBO(
              currentGrayScale, currentGrayScale, currentGrayScale, 1),
          fontFamily: 'PoppinsMedium',
          fontWeight: trackerPosition > 0.5 ? FontWeight.w400 : FontWeight.w200,
          fontSize: 10 + fontSize * trackerPosition);
      canvas.translate(
          -_height / 22 * trackerPosition, _height / 4 * trackerPosition);
      _textPainter.text = TextSpan(
          text: '${minuteText.toString().padLeft(2, '0')}', style: textStyle);
    } else {
      final color = Color.fromRGBO(grayScale, grayScale, grayScale, 1);
      _textPainter.text = new TextSpan(
          text: '${minuteText.toString().padLeft(2, '0')}',
          style: _minuteTextStyle.copyWith(color: color));
    }
    canvas.rotate(-_angle * i + _angle * trackerPosition);
    _textPainter.layout();
    var painterOffset =
        new Offset(-(_textPainter.width / 2), -(_textPainter.height / 2));
    _textPainter.paint(canvas, painterOffset);
    canvas.restore();
  }
}
