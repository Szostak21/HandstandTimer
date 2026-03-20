import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/camera_source.dart';

final cameraSourceProvider = Provider<CameraSource>((ref) {
  final source = CameraSource();
  ref.onDispose(() => source.dispose());
  return source;
});

final cameraControllerProvider = FutureProvider.autoDispose<CameraController>((ref) async {
  final cameraSource = ref.watch(cameraSourceProvider);
  
  await cameraSource.initializeCamera();
  
  if (cameraSource.controller == null) {
    throw Exception('Nie udało się uruchomić aparatu');
  }
  
  return cameraSource.controller!;
});