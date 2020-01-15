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
  var _weather, _temperatureRange = '';
  WeatherCondition _weatherCondition;
  bool _is24HourFormat;
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
      _weather = widget.model.weatherString;
      _temperatureRange = '${widget.model.low} - ${widget.model.highString}';
      _weatherCondition = widget.model.weatherCondition;
      _is24HourFormat = widget.model.is24HourFormat;
    });
  }

  TextSpan conditionText(
      TextStyle style, Color color, Map<ClockTheme, Color> colors) {
    TextSpan _weatherText(Color color) {
      return TextSpan(
          text: _weather,
          style: TextStyle(
              color: color,
              fontFamily: 'PoppinsRegular',
              fontWeight: FontWeight.w100,
              fontSize: 14.0));
    }

    TextSpan _weatherInfo(Color highlightColor, [String text = '']) {
      return TextSpan(
          style: style, text: text, children: [_weatherText(highlightColor)]);
    }

    switch (_weatherCondition) {
      case WeatherCondition.thunderstorm:
        return TextSpan(style: style, text: '', children: [
          _weatherText(colors[ClockTheme.thunderstorm]),
          TextSpan(text: ', stay dry')
        ]);
      case WeatherCondition.sunny:
        return _weatherInfo(colors[ClockTheme.sunny], 'Yea, It\'s ');
      case WeatherCondition.snowy:
        return _weatherInfo(colors[ClockTheme.snowy], 'Aha, ');
      case WeatherCondition.windy:
      case WeatherCondition.foggy:
        return _weatherInfo(colors[ClockTheme.infoHightlight], 'It\'s ');
      case WeatherCondition.cloudy:
        return _weatherInfo(colors[ClockTheme.infoHightlight], 'It looks ');
      case WeatherCondition.rainy:
        return TextSpan(style: style, text: '', children: [
          _weatherText(colors[ClockTheme.rainy]),
          TextSpan(text: ', stay dry')
        ]);
    }
    return _weatherInfo(colors[ClockTheme.infoHightlight]);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness != Brightness.light;
    var colors = isDarkMode ? darkMode : lightMode;
    final style = TextStyle(
        color: colors[ClockTheme.info],
        fontFamily: 'PoppinsRegular',
        fontWeight: FontWeight.w200,
        fontSize: 14.0);
    final weatherAndTemperature = Padding(
        padding: EdgeInsets.only(left: 16),
        child: DefaultTextStyle(
          style: style,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: conditionText(style, colors[ClockTheme.info], colors)),
              SizedBox(height: 3),
              Text('$_temperatureRange Today'),
            ],
          ),
        ));
    final size = MediaQuery.of(context).size;
    bool isFoggyOrWindy =
        widget.model.weatherCondition == WeatherCondition.foggy ||
            widget.model.weatherCondition == WeatherCondition.windy;
    bool needDark = isFoggyOrWindy && isDarkMode;
    final weatherPack = Positioned(
        bottom: 10,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Image.asset(
                  'images/${_weather + (needDark ? '_dark' : '')}.png',
                  width: size.width * 0.125)),
          weatherAndTemperature
        ]));
    Stack stack = Stack(children: <Widget>[
      RepaintBoundary(
          child: CustomPaint(size: size, painter: ClockFacesPainter(colors))),
      DialPaint(
          colors, DialType.hour, Duration(milliseconds: 600), _is24HourFormat),
      DialPaint(colors, DialType.minute, Duration(milliseconds: 600),
          _is24HourFormat),
      DialPaint(colors, DialType.second, Duration(milliseconds: 300)),
      weatherPack,
    ]);
    return Container(
        color: colors[ClockTheme.background], child: ClipRect(child: stack));
  }
}
