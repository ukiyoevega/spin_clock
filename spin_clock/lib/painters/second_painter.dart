import 'package:flutter/material.dart';
import 'dart:math';
import 'package:spin_clock/theme.dart';

class SecondPainter extends CustomPainter {
  double _radius;
  double _angle;
  final Map<ClockTheme, Color> colors;
  final DateTime dateTime;
  final double trackerPosition;
  final TextPainter _textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  final _secondTextStyle = TextStyle(
      fontFamily: 'PoppinsRegular', fontWeight: FontWeight.w200, fontSize: 8.0);

  SecondPainter(this.colors, {this.dateTime, this.trackerPosition});

  @override
  void paint(Canvas canvas, Size size) {
    _angle = 2 * pi / 18;
    _radius = 0.177 * size.width;
    canvas.translate(size.width * 0.98, 0);
    _drawSecondDigits(canvas: canvas);
  }

  @override
  bool shouldRepaint(SecondPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.trackerPosition != trackerPosition;
  }

  int _secondText({int i}) {
    //
    int secondOffset = dateTime.second - 11;
    var x = secondOffset + i;
    if (x < 0) {
      return x + 60;
    } else if (x >= 60) {
      return x - 60;
    } else {
      return x;
    }
  }

  void _drawSecondDigits({Canvas canvas}) {
    canvas.save();
    canvas.rotate(-_angle * trackerPosition);
    int gray = colors[ClockTheme.currentGrayScale].red;
    bool isLightMode = colors == lightMode;
    for (var i = 0; i < 18; i++) {
      _drawSecondDigit(isLightMode, canvas: canvas, i: i, middleGray: gray);
      canvas.rotate(_angle);
    }
    canvas.restore();
  }

  void _drawSecondDigit(bool isLightMode,
      {Canvas canvas, int i, int middleGray}) {
    var secondText = _secondText(i: i);
    canvas.save();
    canvas.translate(0.0, -_radius + 14);
    // i  =  9 10 11 12 13
    // dif = 2  1  0  1  2
    final difference = (11 - i).abs();
    final grayScale = isLightMode
        ? middleGray + 20 * difference
        : middleGray - 20 * difference;
    if (i == 11) {
      // largest digit for current second
      int currentGrayScale = isLightMode
          ? grayScale + 20 * trackerPosition.toInt()
          : grayScale - 20 * trackerPosition.toInt(); // 51->71, 255->235
      final textStyle = TextStyle(
          color: Color.fromRGBO(
              currentGrayScale, currentGrayScale, currentGrayScale, 1),
          fontFamily: 'PoppinsMedium',
          fontWeight: trackerPosition > 0.5 ? FontWeight.w200 : FontWeight.w400,
          fontSize: 8 + 15.0 * (1 - trackerPosition));
      canvas.translate(0, 9 * (1 - trackerPosition));
      _textPainter.text = TextSpan(
          text: '${secondText.toString().padLeft(2, '0')}', style: textStyle);
    } else if (i == 12) {
      // next up largest digit
      int currentGrayScale = isLightMode
          ? grayScale - 20 * trackerPosition.toInt()
          : grayScale + 20 * trackerPosition.toInt(); // 71->51, 235->255
      final textStyle = TextStyle(
          color: Color.fromRGBO(
              currentGrayScale, currentGrayScale, currentGrayScale, 1),
          fontFamily: 'PoppinsMedium',
          fontWeight: trackerPosition > 0.5 ? FontWeight.w400 : FontWeight.w200,
          fontSize: 8 + 15.0 * trackerPosition);
      canvas.translate(0, 9 * trackerPosition);
      _textPainter.text = TextSpan(
          text: '${secondText.toString().padLeft(2, '0')}', style: textStyle);
    } else {
      final color = Color.fromRGBO(grayScale, grayScale, grayScale, 1);
      _textPainter.text = new TextSpan(
          text: '${secondText.toString().padLeft(2, '0')}',
          style: _secondTextStyle.copyWith(color: color));
    }
    canvas.rotate(-_angle * i + _angle * trackerPosition);
    _textPainter.layout();
    var painterOffset =
        new Offset(-(_textPainter.width / 2), -(_textPainter.height / 2));
    _textPainter.paint(canvas, painterOffset);
    canvas.restore();
  }
}
