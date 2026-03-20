import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import '../state/timer_controller.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String deciseconds = (duration.inMilliseconds.remainder(1000) ~/ 100).toString();
    return "$minutes:$seconds.$deciseconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final cameraState = ref.watch(cameraControllerProvider);
    
    final timerState = ref.watch(timerProvider);

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 240,
                height: 320,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: timerState.isHandstanding 
                        ? Colors.green 
                        : colorScheme.primary.withAlpha(60),
                    width: timerState.isHandstanding ? 4 : 2, 
                  ),
                ),
                child: cameraState.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Błąd:\n$error')),
                  data: (controller) => ClipRRect(
                    borderRadius: BorderRadius.circular(22), 
                    child: CameraPreview(controller),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              
              Text(
                _formatDuration(timerState.duration),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: timerState.isHandstanding ? Colors.green : colorScheme.primary,
                  letterSpacing: 4,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                timerState.isHandstanding 
                    ? 'Great form! Hold it!' 
                    : 'Get into a handstand to start',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: timerState.isHandstanding 
                      ? Colors.green 
                      : colorScheme.onSurface.withAlpha(120),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}