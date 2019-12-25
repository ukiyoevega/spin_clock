import 'hour_painter.dart';
import 'minute_painter.dart';
import 'second_painter.dart';
import 'clock_faces_painter.dart';
import 'theme.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

var colors = lightMode;
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
  DateTime _minute;
  DateTime _hour;
  Timer _secondTimer;
  DateTime _second;
  final _animationDuration = Duration(milliseconds: 800);

  AnimationController _minuteAnimationController; 
  AnimationController _hourAnimationController; 
  AnimationController _secondAnimationController; 
  Animation _curvedAnimation;
  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateModel();
    _minuteAnimationController = new AnimationController(vsync: this, duration: _animationDuration);
    _curvedAnimation = CurvedAnimation(parent: _minuteAnimationController, curve: Curves.easeInOut);
    _hourAnimationController = new AnimationController(vsync: this, duration: _animationDuration);
    _secondAnimationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _secondAnimationController.addListener(() {
      setState(() {});
    });
    _updateTime();
    // add minute animation listener
    _minuteAnimationController.addStatusListener((status) {
      if (status != AnimationStatus.completed) { return; }
      final now = DateTime.now();
      final duration = Duration(minutes: 1) 
      - Duration(seconds: now.second) 
      - Duration(milliseconds: now.millisecond) - _animationDuration;
      new Timer(duration, () {
        _minuteAnimationController.forward(from: 0.0);
      });
    });
    _minuteAnimationController.addListener(() {
      setState(() {});
    });
    // add hour animation listener
    _hourAnimationController.addStatusListener((status) {
      if (status != AnimationStatus.completed) { return; }
      final now = DateTime.now();
      final duration = Duration(hours: 1)
      - Duration(minutes: now.minute) 
      - Duration(seconds: now.second) 
      - Duration(milliseconds: now.millisecond) - _animationDuration;
      new Timer(duration, () {
        _hourAnimationController.forward(from: 0.0);
      });
    });
    _hourAnimationController.addListener(() {
      setState(() {});
    });
    // trigger initial minute animation
    _minute = DateTime.now();
    Timer(Duration(minutes: 1) 
        - Duration(seconds: _minute.second) 
        - Duration(milliseconds: _minute.millisecond) - _animationDuration,
      () { 
        _minuteAnimationController.forward();
        _minuteAnimationController.addStatusListener((status) {
          if (status == AnimationStatus.forward) {
            setState(() {
              _minute = DateTime.now();
            });
          }
        });
      }
    );
    // trigger initial hour animation
    _hour = DateTime.now();
    Timer(Duration(hours: 1)
        - Duration(minutes: _hour.minute) 
        - Duration(seconds: _hour.second) 
        - Duration(milliseconds: _hour.millisecond) - _animationDuration,
      () { 
        _hourAnimationController.forward();
        _hourAnimationController.addStatusListener((status) {
          if (status == AnimationStatus.forward) {
            setState(() {
              _hour = DateTime.now();
            });
          }
        });
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
    _minuteAnimationController.dispose();
    _hourAnimationController.dispose();
    _secondAnimationController.dispose();
    _secondTimer.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateTime() {
    _secondAnimationController.forward(from: 0.0);
    setState(() {
      _second = DateTime.now();
      _secondTimer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _second.millisecond),
        _updateTime,
      );
    });
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
    });
  }

  @override
  Widget build(BuildContext context) {
    colors = Theme.of(context).brightness == Brightness.light
        ? lightMode
        : darkMode;
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: colors[ClockTheme.info], fontFamily: 'Poppins', fontWeight: FontWeight.w200, fontSize:12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_temperature),
          Text(_temperatureRange),
          Text(_condition),
        ],
      ),
    );
    final size = MediaQuery.of(context).size;
    Stack stack = Stack(
        children: <Widget>[
          CustomPaint(size: size, painter: ClockFacesPainter()),
          CustomPaint(size: size, painter: MinutePainter(dateTime: _minute, trackerPosition: _curvedAnimation.value)),
          CustomPaint(size: size, painter: HourPainter(dateTime: _hour, trackerPosition: _hourAnimationController.value)),
          CustomPaint(size: size, painter: SecondPainter(dateTime: _second, trackerPosition: _secondAnimationController.value)),
          Positioned(left: 20, bottom: 20, child: weatherInfo)
        ]);
    return Container(
          color: colors[ClockTheme.background],
          child: ClipRect(child: stack)
          );
  }
}