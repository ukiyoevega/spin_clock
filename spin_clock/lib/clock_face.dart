import 'package:flutter/material.dart';
import 'dart:async';
import 'clock_face_painter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_clock_helper/model.dart';

class ClockFace extends StatefulWidget {
  final Offset offset;
  final double durationSlowMode;
  final ClockModel model;
  const ClockFace({Key key, this.model, this.offset, this.durationSlowMode}) : super(key: key);
  
  @override
  State createState() => _ClockFaceState();
}

class _ClockFaceState extends State<ClockFace> with TickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  Timer _timer;
  double durationSlowMode;
  AnimationController digitAnimationController; 
  Animation digitAnimation;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
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
          CustomPaint(size: MediaQuery.of(context).size, painter: ClockFacePainter(dateTime: _dateTime, trackerPosition: digitAnimation.value)),
          Positioned(left: 0, bottom: 0, child: Padding(padding: const EdgeInsets.all(8),child: weatherInfo)),
        ]);
    return stack;
  }
}