// lib/features/timer/domain/repositories/pose_repository.dart

import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class PoseRepository {
  Future<List<Pose>> processCameraFrame(CameraImage image, CameraDescription camera);
}