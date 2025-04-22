import 'package:flutter/material.dart';
import 'dart:async';
import '../data/models/pomodoro_settings.dart';
import '../data/models/pomodoro_session.dart';
import '../data/services/db_service.dart';

enum TimerState { initial, running, paused, finished }
enum TimerMode { focus, shortBreak, longBreak }

class PomodoroProvider with ChangeNotifier {
  final DBService _dbService = DBService();
  
  Timer? _timer;
  int _secondsRemaining = 0;
  int _completedSessions = 0;
  TimerState _timerState = TimerState.initial;
  TimerMode _timerMode = TimerMode.focus;
  DateTime? _startTime;
  int? _currentTopicId;
  
  int get secondsRemaining => _secondsRemaining;
  int get completedSessions => _completedSessions;
  TimerState get timerState => _timerState;
  TimerMode get timerMode => _timerMode;
  int? get currentTopicId => _currentTopicId;
  
  void setSettings(PomodoroSettings settings) {
    if (_timerState == TimerState.initial) {
      _updateTimerDuration(settings);
    }
  }
  
  void _updateTimerDuration(PomodoroSettings settings) {
    switch (_timerMode) {
      case TimerMode.focus:
        _secondsRemaining = settings.focusDuration * 60;
        break;
      case TimerMode.shortBreak:
        _secondsRemaining = settings.shortBreakDuration * 60;
        break;
      case TimerMode.longBreak:
        _secondsRemaining = settings.longBreakDuration * 60;
        break;
    }
    notifyListeners();
  }
  
  void startTimer(PomodoroSettings settings) {
    if (_timerState == TimerState.initial || _timerState == TimerState.finished) {
      _updateTimerDuration(settings);
    }
    
    _timerState = TimerState.running;
    _startTime = DateTime.now();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _handleTimerCompletion(settings);
      }
    });
    
    notifyListeners();
  }
  
  void pauseTimer() {
    _timer?.cancel();
    _timerState = TimerState.paused;
    notifyListeners();
  }
  
  void resetTimer(PomodoroSettings settings) {
    _timer?.cancel();
    _timerState = TimerState.initial;
    _updateTimerDuration(settings);
    notifyListeners();
  }
  
  void skipToNext(PomodoroSettings settings) {
    _timer?.cancel();
    
    if (_timerMode == TimerMode.focus) {
      _completedSessions++;
      
      if (_completedSessions % settings.sessionsBeforeLongBreak == 0) {
        _timerMode = TimerMode.longBreak;
      } else {
        _timerMode = TimerMode.shortBreak;
      }
    } else {
      _timerMode = TimerMode.focus;
    }
    
    _timerState = TimerState.initial;
    _updateTimerDuration(settings);
    notifyListeners();
  }
  
  void selectTopic(int? topicId) {
    _currentTopicId = topicId;
    notifyListeners();
  }
  
  void _handleTimerCompletion(PomodoroSettings settings) {
    _timer?.cancel();
    _timerState = TimerState.finished;
    
    // Save session to DB if it was a focus session
    if (_timerMode == TimerMode.focus) {
      final endTime = DateTime.now();
      final duration = settings.focusDuration;
      
      final session = PomodoroSession(
        topicId: _currentTopicId,
        startTime: _startTime!,
        endTime: endTime,
        duration: duration,
        isCompleted: true,
      );
      
      _dbService.insertSession(session);
      _completedSessions++;
    }
    
    // Auto transition to next state if enabled
    final bool autoStart = _timerMode == TimerMode.focus 
        ? settings.autoStartBreaks 
        : settings.autoStartPomodoros;
    
    if (autoStart) {
      skipToNext(settings);
      startTimer(settings);
    } else {
      skipToNext(settings);
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}