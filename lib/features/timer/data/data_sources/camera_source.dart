// lib/features/timer/data/data_sources/camera_source.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraSource {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];

  CameraController? get controller => _controller;

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;

    final camera = _cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => _cameras.first,
    );

    _controller = CameraController(
      camera, 
      ResolutionPreset.medium, 
      enableAudio: false, 
      imageFormatGroup: Platform.isAndroid 
          ? ImageFormatGroup.yuv420 
          : ImageFormatGroup.bgra8888, 
    );

    await _controller!.initialize();
  }

  void startImageStream(Function(CameraImage) onImageAvailable) {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.startImageStream(onImageAvailable);
    }
  }

  Future<void> stopImageStream() async {
    if (_controller != null && _controller!.value.isStreamingImages) {
      await _controller!.stopImageStream();
    }
  }

  void dispose() {
    _controller?.dispose();
  }
}