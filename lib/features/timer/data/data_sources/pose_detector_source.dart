// lib/features/timer/data/data_sources/pose_detector_source.dart

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectorSource {
  late final PoseDetector _poseDetector;

  PoseDetectorSource() {
    final options = PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
    );
    _poseDetector = PoseDetector(options: options);
  }

  Future<List<Pose>> processImage(InputImage inputImage) async {
    try {
      final poses = await _poseDetector.processImage(inputImage);
      return poses;
    } catch (e) {
      print("Error during detecting a pose: $e");
      return [];
    }
  }

  void dispose() {
    _poseDetector.close();
  }
}