// lib/features/timer/domain/repositories/pose_repository.dart

import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../entities/handstand_pose.dart';

abstract class PoseRepository {
Future<HandstandPose?> processCameraFrame(CameraImage image, CameraDescription camera);
}