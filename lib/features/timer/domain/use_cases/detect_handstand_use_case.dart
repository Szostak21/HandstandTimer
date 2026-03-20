import '../entities/handstand_pose.dart';

class DetectHandstandUseCase {
  bool call(HandstandPose pose) {
    final bool isUpsideDown = _checkIfUpsideDown(pose);
    
    return isUpsideDown;
  }

  bool _checkIfUpsideDown(HandstandPose pose) {
    if(pose.leftWrist.visibility < 0.5 || pose.rightWrist.visibility < 0.5 ||
       pose.leftShoulder.visibility < 0.5 || pose.rightShoulder.visibility < 0.5 ||
       pose.leftHip.visibility < 0.5 || pose.rightHip.visibility < 0.5 ||
       pose.leftAnkle.visibility < 0.5 || pose.rightAnkle.visibility < 0.5) {
      return false;
    }
    final double wristY = (pose.leftWrist.dy + pose.rightWrist.dy) / 2;
    final double shoulderY = (pose.leftShoulder.dy + pose.rightShoulder.dy) / 2;
    final double hipY = (pose.leftHip.dy + pose.rightHip.dy) / 2;
    final double ankleY = (pose.leftAnkle.dy + pose.rightAnkle.dy) / 2;

    if(wristY > shoulderY && shoulderY > hipY && hipY > ankleY) {
      return true;
    }
    return false;
  }
}