import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/pose_repository.dart';
import '../../domain/use_cases/detect_handstand_use_case.dart';

import '../../data/data_sources/camera_source.dart';
import '../../data/data_sources/pose_detector_source.dart';
import '../../domain/entities/handstand_pose.dart';
import '../../domain/repositories/pose_repository_impl.dart';

final detectHandstandUseCaseProvider = Provider((ref) => DetectHandstandUseCase());

final poseRepositoryProvider = Provider<PoseRepository>((ref) {
  final detectorSource = PoseDetectorSource();
  return PoseRepositoryImpl(detectorSource);
});

final cameraSourceProvider = Provider<CameraSource>((ref) {
  final source = CameraSource();
  ref.onDispose(() => source.dispose());
  return source;
});


final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  final repo = ref.watch(poseRepositoryProvider);
  final useCase = ref.watch(detectHandstandUseCaseProvider);
  return TimerNotifier(repo, useCase);
});


final cameraControllerProvider = FutureProvider.autoDispose<CameraController>((ref) async {
  final cameraSource = ref.watch(cameraSourceProvider);
  
  await cameraSource.initializeCamera();
  final controller = cameraSource.controller!;
  
  controller.startImageStream((image) {
    ref.read(timerProvider.notifier).processFrame(image, controller.description);
  });
  
  ref.onDispose(() {
    controller.stopImageStream();
  });
  
  return controller;
});


class TimerState {
  final bool isHandstanding;
  final Duration duration;

  TimerState({required this.isHandstanding, required this.duration});

  TimerState copyWith({bool? isHandstanding, Duration? duration}) {
    return TimerState(
      isHandstanding: isHandstanding ?? this.isHandstanding,
      duration: duration ?? this.duration,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  final PoseRepository _repository;
  final DetectHandstandUseCase _detectUseCase;
  
  Timer? _ticker;
  bool _isProcessing = false; 

  TimerNotifier(this._repository, this._detectUseCase) 
      : super(TimerState(isHandstanding: false, duration: Duration.zero));

  void processFrame(CameraImage image, CameraDescription camera) async {
    if (_isProcessing) return;
    
    _isProcessing = true;

    try {
      final pose = await _repository.processCameraFrame(image, camera);

      if (pose != null) {
        final isHandstandingNow = _detectUseCase(pose);
        _handleHandstandLogic(isHandstandingNow);
      }
    } catch (e) {
      print("Error detecting: $e");
    } finally {
      _isProcessing = false;
    }
  }

  void _handleHandstandLogic(bool isHandstandingNow) {
    if (isHandstandingNow && !state.isHandstanding) {
      _startTimer();
      state = state.copyWith(isHandstanding: true);
    } else if (!isHandstandingNow && state.isHandstanding) {
      _stopTimer();
      state = state.copyWith(isHandstanding: false);
    }
  }

  void _startTimer() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      state = state.copyWith(duration: state.duration + const Duration(milliseconds: 100));
    });
  }

  void _stopTimer() {
    _ticker?.cancel();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}