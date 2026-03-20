// lib/features/timer/data/repositories/pose_repository_impl.dart

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../data_sources/pose_detector_source.dart';
import '../../domain/repositories/pose_repository.dart';

class PoseRepositoryImpl implements PoseRepository {
  final PoseDetectorSource _poseDetectorSource;

  PoseRepositoryImpl(this._poseDetectorSource);

  @override
  Future<List<Pose>> processCameraFrame(CameraImage image, CameraDescription camera) async {
    final inputImage = _convertCameraImageToInputImage(image, camera);
    
    if (inputImage == null) return []; 
    
    return await _poseDetectorSource.processImage(inputImage);
  }

  InputImage? _convertCameraImageToInputImage(CameraImage image, CameraDescription camera) {
    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null || 
        (Platform.isAndroid && format != InputImageFormat.nv21 && format != InputImageFormat.yuv_420_888) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    if (image.planes.isEmpty) return null;
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation, 
      format: format,
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }
}