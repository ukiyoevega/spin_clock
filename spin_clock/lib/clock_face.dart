import 'package:flutter/material.dart';
import 'dart:async';
import 'dial_painter.dart';
import 'clock_faces_painter.dart';
import 'package:flutter_clock_helper/model.dart';

class ClockFace extends StatefulWidget {
  final ClockModel model;
  const ClockFace({Key key, this.model}) : super(key: key);
  
  @override
  State createState() => _ClockFaceState();
}

class _ClockFaceState extends State<ClockFace> with TickerProviderStateMixin {
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  final _animationDuration = Duration(milliseconds: 800);

  Timer _timer;
  AnimationController digitAnimationController; 

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateModel();
    digitAnimationController = new AnimationController(vsync: this, duration: _animationDuration);
    digitAnimationController.addStatusListener((status) {
      if (status != AnimationStatus.completed) { return; }
      final now = DateTime.now();
      final duration = Duration(minutes: 1) 
      - Duration(seconds: now.second) 
      - Duration(milliseconds: now.millisecond) - _animationDuration;
      new Timer(duration, () {
        digitAnimationController.forward(from: 0.0);
      });
    });
    digitAnimationController.addListener(() {
      setState(() {});
    });
    // trigger initial animation
    DateTime _dateTime = DateTime.now();
    Timer(Duration(minutes: 1) 
        - Duration(seconds: _dateTime.second) 
        - Duration(milliseconds: _dateTime.millisecond) - _animationDuration,
      () { 
        digitAnimationController.forward();
      }
    );
  }

  @override
  void didUpdateWidget(ClockFace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    digitAnimationController.dispose();
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: Color(0xFF333333), fontFamily: 'Poppins', fontWeight: FontWeight.w200, fontSize:12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_temperature),
          Text('$_temperatureRange, $_condition'),
          Text(_location),
        ],
      ),
    );
    Stack stack = Stack(
        children: <Widget>[
          CustomPaint(size: MediaQuery.of(context).size, painter: ClockFacesPainter()),
          CustomPaint(size: MediaQuery.of(context).size, painter: DialPainter(trackerPosition: digitAnimationController.value)),
          Positioned(left: 20, bottom: 20, child: weatherInfo),
        ]);
    return stack;
  }
}