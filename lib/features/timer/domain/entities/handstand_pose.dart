import 'dart:ui';

class HandstandPoint {
  final double dx;
  final double dy;
  final double visibility;

  HandstandPoint(this.dx, this.dy, this.visibility);
}

class HandstandPose {
  final HandstandPoint leftWrist;
  final HandstandPoint rightWrist;
  final HandstandPoint leftShoulder;
  final HandstandPoint rightShoulder;
  final HandstandPoint leftHip;
  final HandstandPoint rightHip;
  final HandstandPoint leftAnkle;
  final HandstandPoint rightAnkle;

  HandstandPose({
    required this.leftWrist,
    required this.rightWrist,
    required this.leftShoulder,
    required this.rightShoulder,
    required this.leftHip,
    required this.rightHip,
    required this.leftAnkle,
    required this.rightAnkle,
  });
}