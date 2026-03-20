import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; 
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'dart:typed_data';


import '../../data/data_sources/pose_detector_source.dart';
import '../entities/handstand_pose.dart';
import './pose_repository.dart';

class PoseRepositoryImpl implements PoseRepository {
  final PoseDetectorSource _poseDetectorSource;

  PoseRepositoryImpl(this._poseDetectorSource);

  @override
    Future<HandstandPose?> processCameraFrame(
        CameraImage image, CameraDescription camera) async {

    debugPrint('Format raw: ${image.format.raw}');
    debugPrint('Planes: ${image.planes.length}');
    debugPrint('Size: ${image.width}x${image.height}');

    final inputImage = _convertCameraImageToInputImage(image, camera);
    if (inputImage == null) return null;

    final poses = await _poseDetectorSource.processImage(inputImage);
    if (poses.isEmpty) return null;

    return _mapToEntity(poses.first);
    }

    InputImage? _convertCameraImageToInputImage(CameraImage image, CameraDescription camera) {
  try {
    final rotation = _getRotation(camera.sensorOrientation);
    if (rotation == null) return null;

    // iOS ??? sprawdzic czy dziala szosti
    if (Platform.isIOS) {
      final bytes = image.planes.first.bytes;
      final metadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.bgra8888,
        bytesPerRow: image.planes.first.bytesPerRow,
      );
      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    }

    // Android 
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;

    final nv21 = Uint8List(width * height + 2 * (width ~/ 2) * (height ~/ 2));

    final yPlane = image.planes[0].bytes;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        nv21[y * width + x] = yPlane[y * image.planes[0].bytesPerRow + x];
      }
    }

    final uPlane = image.planes[1].bytes;
    final vPlane = image.planes[2].bytes;
    int offset = width * height;
    for (int y = 0; y < height ~/ 2; y++) {
      for (int x = 0; x < width ~/ 2; x++) {
        final int uvIndex = y * uvRowStride + x * uvPixelStride;
        nv21[offset++] = vPlane[uvIndex];
        nv21[offset++] = uPlane[uvIndex];
      }
    }

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: InputImageFormat.nv21,
      bytesPerRow: width,
    );

    return InputImage.fromBytes(bytes: nv21, metadata: metadata);
  } catch (e) {
    debugPrint('Conversion error: $e');
    return null;
  }
}

  InputImageRotation? _getRotation(int rotation) {
    switch (rotation) {
      case 0: return InputImageRotation.rotation0deg;
      case 90: return InputImageRotation.rotation90deg;
      case 180: return InputImageRotation.rotation180deg;
      case 270: return InputImageRotation.rotation270deg;
    }
    return null;
  }
  
  HandstandPose _mapToEntity(Pose pose) {
    HandstandPoint mapPoint(PoseLandmarkType type) {
      final p = pose.landmarks[type]!;
      return HandstandPoint(p.x, p.y, p.likelihood); 
    }

    return HandstandPose(
      leftWrist: mapPoint(PoseLandmarkType.leftWrist),
      rightWrist: mapPoint(PoseLandmarkType.rightWrist),
      leftShoulder: mapPoint(PoseLandmarkType.leftShoulder),
      rightShoulder: mapPoint(PoseLandmarkType.rightShoulder),
      leftHip: mapPoint(PoseLandmarkType.leftHip),
      rightHip: mapPoint(PoseLandmarkType.rightHip),
      leftAnkle: mapPoint(PoseLandmarkType.leftAnkle),
      rightAnkle: mapPoint(PoseLandmarkType.rightAnkle),
    );
  }
}