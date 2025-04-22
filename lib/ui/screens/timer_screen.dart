import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pomodoro_provider.dart';
import '../../providers/settings_provider.dart';
import '../widgets/timer_display.dart';
import '../widgets/session_controls.dart';
import '../widgets/study_topics_list.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final pomodoroProvider = Provider.of<PomodoroProvider>(context);
    
    if (settingsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final settings = settingsProvider.settings;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.pushNamed(context, '/statistics');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Timer mode indicator
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: _getTimerModeColor(pomodoroProvider.timerMode),
            child: Text(
              _getTimerModeTitle(pomodoroProvider.timerMode),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Timer display
          Expanded(
            flex: 3,
            child: TimerDisplay(
              secondsRemaining: pomodoroProvider.secondsRemaining,
              timerMode: pomodoroProvider.timerMode,
            ),
          ),
          
          // Session controls
          Expanded(
            flex: 2,
            child: SessionControls(
              timerState: pomodoroProvider.timerState,
              onStart: () => pomodoroProvider.startTimer(settings),
              onPause: pomodoroProvider.pauseTimer,
              onReset: () => pomodoroProvider.resetTimer(settings),
              onSkip: () => pomodoroProvider.skipToNext (settings),
            ),
          ),
          
          // Topic selector
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Study Topic',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          
          // Topics list
          Expanded(
            flex: 3,
            child: StudyTopicsList(
              selectedTopicId: pomodoroProvider.currentTopicId,
              onTopicSelected: pomodoroProvider.selectTopic,
            ),
          ),
          
          // Session counter
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.grey.shade200,
            child: Text(
              'Completed sessions: ${pomodoroProvider.completedSessions}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
  
  String _getTimerModeTitle(TimerMode mode) {
    switch (mode) {
      case TimerMode.focus:
        return 'Focus Time';
      case TimerMode.shortBreak:
        return 'Short Break';
      case TimerMode.longBreak:
        return 'Long Break';
    }
  }
}
