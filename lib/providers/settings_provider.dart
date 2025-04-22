import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'   ;
import '../data/models/pomodoro_settings.dart';

class SettingsProvider with ChangeNotifier {
  PomodoroSettings _settings = PomodoroSettings();
  bool _isLoading = true;

  PomodoroSettings get settings => _settings;
  bool get isLoading => _isLoading;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? settingsJson = prefs.getString('pomodoro_settings');
    
    if (settingsJson != null) {
      final Map<String, dynamic> settingsMap = jsonDecode(settingsJson);
      _settings = PomodoroSettings.fromMap(settingsMap);
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateSettings(PomodoroSettings newSettings) async {
    _settings = newSettings;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pomodoro_settings', jsonEncode(newSettings.toMap()));
    
    notifyListeners();
  }
}
