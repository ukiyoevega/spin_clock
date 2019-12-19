import 'package:flutter/material.dart';
import 'clock_face_painter.dart';

class ClockFace extends StatefulWidget {
  final Offset offset;
  final double durationSlowMode;
  const ClockFace({Key key, this.offset, this.durationSlowMode}) : super(key: key);
  
  @override
  State createState() => _ClockFaceState();
}

class _ClockFaceState extends State<ClockFace> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Container container = Container(child: 
      CustomPaint(painter: ClockFacePainter())
    );
    return container;
  }
}