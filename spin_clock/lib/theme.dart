import 'package:flutter/material.dart';

var colors = lightMode;
enum ClockTheme {
  background,
  shadow,
  currentGrayScale,
  hourGrayScale,
  face,
  border,
  dialLine,
  dialLineGrayScale,
  secondFace,
  secondBorder,
  colon,
  info,
}

final lightMode = {
  ClockTheme.background: Color(0xFFECECEC),
  ClockTheme.shadow: Colors.black.withAlpha(30),
  ClockTheme.currentGrayScale: Color.fromRGBO(51, 51, 51, 1),// 51,
  ClockTheme.hourGrayScale: Color.fromRGBO(153, 153, 153, 1),// 153,
  ClockTheme.face: Colors.white,
  ClockTheme.border: Color(0xFFFAFAFA),
  ClockTheme.dialLine: Color(0xFF999999),
  ClockTheme.dialLineGrayScale: Color.fromRGBO(100, 100, 100, 1),// 100,
  ClockTheme.secondFace: Color(0xFFFDFDFD),
  ClockTheme.secondBorder: Color(0xFFEEEBEB),
  ClockTheme.colon: Color(0xFF333333),
  ClockTheme.info: Color(0xFF333333),
};

final darkMode = {
  ClockTheme.background: Color(0xFF4C4C4C),
  ClockTheme.shadow: Colors.black.withAlpha(30),
  ClockTheme.currentGrayScale: Color.fromRGBO(255, 255, 255, 1),// 255,
  ClockTheme.hourGrayScale: Color.fromRGBO(216, 216, 216, 1),// 216,
  ClockTheme.face: Color(0xFF2A2A2A),
  ClockTheme.border: Color(0xFF2A2A2A),
  ClockTheme.dialLine: Color(0xFF999999),
  ClockTheme.dialLineGrayScale: Color.fromRGBO(255, 255, 255, 1),// 255,
  ClockTheme.secondFace: Color(0xFFFDFDFD),
  ClockTheme.secondBorder: Color(0xFFEEEBEB),
  ClockTheme.colon: Color(0xFFD6D6D6),
  ClockTheme.info: Color(0xFFECECEC),
};