import 'package:flutter/material.dart';
import 'dart:async';
import 'clock_face_painter.dart';
import 'package:flutter/scheduler.dart';

class ClockFace extends StatefulWidget {
  final Offset offset;
  final double durationSlowMode;
  const ClockFace({Key key, this.offset, this.durationSlowMode}) : super(key: key);
  
  @override
  State createState() => _ClockFaceState();
}

class _ClockFaceState extends State<ClockFace> with TickerProviderStateMixin {
  double durationSlowMode;
  AnimationController digitAnimationController; 
  Animation digitAnimation;

  @override
  void initState() {
    super.initState();
    durationSlowMode = widget.durationSlowMode;
    digitAnimationController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 10000));
    digitAnimation = new Tween(begin: 0.0, end: 1.0).animate(digitAnimationController);
    digitAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        digitAnimationController.repeat();
      }
    });
    digitAnimation.addListener(() {
      setState(() {});
    });

    new Timer(new Duration(milliseconds: 1000), () {
      digitAnimationController.forward();
    });
  }

  @override
  void dispose() {
    digitAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = durationSlowMode; // figure out
    Container container = Container(child: 
      CustomPaint(painter: ClockFacePainter(trackerPosition: digitAnimation.value))
    );
    return container;
  }
}