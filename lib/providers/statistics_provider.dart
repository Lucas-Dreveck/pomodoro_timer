import 'package:flutter/material.dart';
import '../data/models/pomodoro_session.dart';
import '../data/services/db_service.dart';

class StatisticsProvider with ChangeNotifier {
  final DBService _dbService = DBService();
  bool _isLoading = false;
  List<PomodoroSession> _sessions = [];
  Map<String, dynamic> _statistics = {
    'totalSessions': 0,
    'completedSessions': 0,
    'totalDuration': 0,
  };
  
  bool get isLoading => _isLoading;
  List<PomodoroSession> get sessions => _sessions;
  Map<String, dynamic> get statistics => _statistics;
  
  Future<void> loadStatistics() async {
    _isLoading = true;
    notifyListeners();
    
    _statistics = await _dbService.getStatistics();
    _sessions = await _dbService.getSessions();
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<List<PomodoroSession>> getSessionsByDateRange(DateTime start, DateTime end) async {
    return await _dbService.getSessionsByDateRange(start, end);
  }
  
  Future<List<PomodoroSession>> getSessionsByTopic(int topicId) async {
    return await _dbService.getSessionsByTopic(topicId);
  }
  
  // Additional helper methods for statistics visualization
  Map<String, int> getDailyTotalsByWeek() {
    final Map<String, int> dailyTotals = {};
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day - now.weekday + 1);
    
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayString = '${day.day}/${day.month}';
      dailyTotals[dayString] = 0;
    }
    
    for (final session in _sessions) {
      final sessionDate = session.startTime;
      if (sessionDate.isAfter(weekStart) && sessionDate.isBefore(now.add(const Duration(days: 1)))) {
        final dayString = '${sessionDate.day}/${sessionDate.month}';
        dailyTotals[dayString] = (dailyTotals[dayString] ?? 0) + session.duration;
      }
    }
    
    return dailyTotals;
  }
}