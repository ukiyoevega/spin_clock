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
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  double durationSlowMode;
  AnimationController digitAnimationController; 
  Animation digitAnimation;

  @override
  void initState() {
    super.initState();
    _updateTime();
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
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = durationSlowMode; // figure out
    Container container = Container(child: 
      CustomPaint(painter: ClockFacePainter(dateTime: _dateTime, trackerPosition: digitAnimation.value))
    );
    return container;
  }
}