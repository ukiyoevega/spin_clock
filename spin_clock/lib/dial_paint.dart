import 'package:flutter/material.dart';
import 'package:spin_clock/hour_painter.dart';
import 'package:spin_clock/second_painter.dart';
import 'package:spin_clock/minute_painter.dart';
import 'dart:async';

enum DialType {
  second, minute, hour
}

class DialPaint extends StatefulWidget {  
  final DialType type;
  final Duration animationDuration;
  DialPaint({this.type, this.animationDuration});
  @override
  State createState() => _DialPaintState();
}

class _DialPaintState extends State<DialPaint> with TickerProviderStateMixin {
  DateTime _dateTime;
  AnimationController _animationController;
  CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(vsync: this, duration: widget.animationDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          new Timer(_remainedTime(DateTime.now()), () {
            _animationController.forward(from: 0.0);
          });
        }
        if (status == AnimationStatus.forward) {
          setState(() {
            _dateTime = DateTime.now();
          });
        }
      });
    _curvedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
      ..addListener(() {
        setState(() {}); 
      });
    // trigger initial animation
    _dateTime = DateTime.now();
    Timer(_remainedTime(_dateTime), () { 
        _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    CustomPainter painter;
    switch (widget.type) {
      case DialType.second:
      painter = SecondPainter(dateTime: _dateTime, trackerPosition: _curvedAnimation.value);
      break;
      case DialType.minute: 
      painter = MinutePainter(dateTime: _dateTime, trackerPosition: _curvedAnimation.value);
      break;
      case DialType.hour: 
      painter = HourPainter(dateTime: _dateTime, trackerPosition: _curvedAnimation.value);
      break;
    }
    return RepaintBoundary(child: CustomPaint(size: size, painter: painter));
  }

  Duration _remainedTime(DateTime time) {
    Duration duration = Duration(milliseconds: 0);
    switch (widget.type) {
      case DialType.second: 
      // minus animation duration might swipe to next second
      // 00:50:01:600 + 300 -> 900
      // 00:50:01:900 + 300 -> 02:200
      if (time.millisecond + widget.animationDuration.inMilliseconds < 1000) {
        return Duration(seconds: 1) - Duration(milliseconds: time.millisecond) - Duration(microseconds: time.microsecond) - widget.animationDuration;
      } else {
        return duration;
      }
      break;
      case DialType.minute: 
      duration = Duration(minutes: 1);
      break;
      case DialType.hour: 
      duration = Duration(hours: 1) - Duration(minutes: time.minute);
      break;
    }
    return duration 
      - Duration(seconds: time.second) 
      - Duration(milliseconds: time.millisecond) 
      - widget.animationDuration;
  }
}