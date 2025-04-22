import 'package:flutter/material.dart';
import '../../providers/pomodoro_provider.dart';

class SessionControls extends StatelessWidget {
  final TimerState timerState;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onSkip;
  
  const SessionControls({
    Key? key,
    required this.timerState,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.refresh),
          iconSize: 36,
          onPressed: timerState != TimerState.initial ? onReset : null,
          color: Colors.grey,
        ),
        const SizedBox(width: 24),
        _buildMainActionButton(),
        const SizedBox(width: 24),
        IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: 36,
          onPressed: onSkip,
          color: Colors.grey,
        ),
      ],
    );
  }
  
  Widget _buildMainActionButton() {
    switch (timerState) {
      case TimerState.initial:
      case TimerState.finished:
        return FloatingActionButton(
          heroTag: 'play_button',
          onPressed: onStart,
          backgroundColor: Colors.green,
          child: const Icon(Icons.play_arrow, size: 36),
        );
      case TimerState.running:
        return FloatingActionButton(
          heroTag: 'pause_button',
          onPressed: onPause,
          backgroundColor: Colors.orange,
          child: const Icon(Icons.pause, size: 36),
        );
      case TimerState.paused:
        return FloatingActionButton(
          heroTag: 'resume_button',
          onPressed: onStart,
          backgroundColor: Colors.green,
          child: const Icon(Icons.play_arrow, size: 36),
        );
    }
  }
}
