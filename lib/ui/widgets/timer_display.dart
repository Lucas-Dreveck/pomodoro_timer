import 'package:flutter/material.dart';
import '../../providers/pomodoro_provider.dart';

class TimerDisplay extends StatelessWidget {
  final int secondsRemaining;
  final TimerMode timerMode;
  
  const TimerDisplay({
    Key? key,
    required this.secondsRemaining,
    required this.timerMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = (secondsRemaining / 60).floor();
    final seconds = secondsRemaining % 60;
    
    return Center(
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: _getTimerModeColor(timerMode).withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: _getTimerModeColor(timerMode),
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getTimerModeColor(TimerMode mode) {
    switch (mode) {
      case TimerMode.focus:
        return Colors.red.shade700;
      case TimerMode.shortBreak:
        return Colors.green.shade600;
      case TimerMode.longBreak:
        return Colors.blue.shade700;
    }
  }
}