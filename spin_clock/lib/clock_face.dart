import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'dial_paint.dart';
import 'painters/clock_faces_painter.dart';
import 'theme.dart';

class ClockFace extends StatefulWidget {
  final ClockModel model;
  const ClockFace({Key key, this.model}) : super(key: key);
  
  @override
  State createState() => _ClockFaceState();
}

class _ClockFaceState extends State<ClockFace> with TickerProviderStateMixin {
  var _temperature, _condition, _temperatureRange = '';
  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateModel();
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
    widget.model.removeListener(_updateModel);
    super.dispose();
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
    var colors = Theme.of(context).brightness == Brightness.light
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
          RepaintBoundary(child: CustomPaint(size: size, painter: ClockFacesPainter(colors))),
          DialPaint(colors, DialType.hour, animationDuration: Duration(milliseconds: 600)),
          DialPaint(colors, DialType.minute, animationDuration: Duration(milliseconds: 600)),
          DialPaint(colors, DialType.second, animationDuration: Duration(milliseconds: 300)),
          Positioned(left: 20, bottom: 20, child: weatherInfo)
        ]);
    return Container(
          color: colors[ClockTheme.background],
          child: ClipRect(child: stack)
          );
  }
}