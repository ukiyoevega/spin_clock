import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'clock_face.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(
        (ClockModel model) {
          var container = Container(
          color: Color(0xFFECECEC),
          child: ClipRect(child: ClockFace(model: model))
          );
          return container;
      }
    );
  }
}