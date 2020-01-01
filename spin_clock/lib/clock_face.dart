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
  var _condition, _temperatureRange = '';
  WeatherCondition _weather;
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
      _condition = widget.model.weatherString;
      _temperatureRange = '${widget.model.low} - ${widget.model.highString}';
      _weather = widget.model.weatherCondition;
    });
  }

  TextSpan conditionText(TextStyle style, Color color, Color hightLightColor) {
    TextSpan _weatherText = TextSpan(text: _condition, style: TextStyle(color: hightLightColor, 
      fontFamily: 'PoppinsRegular', fontWeight: FontWeight.w100, fontSize:14.0));
    TextSpan _textWithWeather(String text) {
      return TextSpan(style: style, text: text, children: [_weatherText]);
    }
    switch (_weather) {
      case WeatherCondition.thunderstorm:
      return _textWithWeather('Uh-oh, ');
      case WeatherCondition.sunny:
      return _textWithWeather('Yea, It\'s ');
      case WeatherCondition.snowy:
      return _textWithWeather('Aha, ');
      case WeatherCondition.windy:
      case WeatherCondition.foggy:
      return _textWithWeather('It\'s ');
      case WeatherCondition.cloudy:
      return _textWithWeather('It looks ');
      case WeatherCondition.rainy:
      return TextSpan(style: style, text: '', children: [_weatherText, TextSpan(text: ', stay dry')]);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness != Brightness.light;
    var colors = isDarkMode ? darkMode : lightMode;
    final style = TextStyle(color: colors[ClockTheme.info], fontFamily: 'PoppinsRegular', fontWeight: FontWeight.w200, fontSize:14.0);
    final weatherInfo = Padding(padding: EdgeInsets.only(left: 16), child: 
    DefaultTextStyle(style: style,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good morning'),
            RichText(text: conditionText(style, colors[ClockTheme.info], colors[ClockTheme.infoHightlight])),
            Text('$_temperatureRange Today.'),
          ],
        ),
      )
    );
    final size = MediaQuery.of(context).size;
    bool isFoggyOrWindy = widget.model.weatherCondition == WeatherCondition.foggy || widget.model.weatherCondition == WeatherCondition.windy;
    bool needDark = isFoggyOrWindy && isDarkMode;
    final weatherPack = Positioned(bottom: 10, 
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, 
        children: [Image.asset('images/${_condition + (needDark ? '_dark' : '')}.png', width: size.width*0.125), weatherInfo]));
    Stack stack = Stack(
        children: <Widget>[
          RepaintBoundary(child: CustomPaint(size: size, painter: ClockFacesPainter(colors))),
          DialPaint(colors, DialType.hour, animationDuration: Duration(milliseconds: 600)),
          DialPaint(colors, DialType.minute, animationDuration: Duration(milliseconds: 600)),
          DialPaint(colors, DialType.second, animationDuration: Duration(milliseconds: 300)),
          weatherPack,
        ]);
    return Container(
          color: colors[ClockTheme.background],
          child: ClipRect(child: stack)
          );
  }
}