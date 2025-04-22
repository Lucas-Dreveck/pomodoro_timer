class PomodoroSettings {
  final int focusDuration; // in minutes
  final int shortBreakDuration; // in minutes
  final int longBreakDuration; // in minutes
  final int sessionsBeforeLongBreak;
  final bool autoStartBreaks;
  final bool autoStartPomodoros;
  final bool showNotifications;

  PomodoroSettings({
    this.focusDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.sessionsBeforeLongBreak = 4,
    this.autoStartBreaks = false,
    this.autoStartPomodoros = false,
    this.showNotifications = true,
  });

  PomodoroSettings copyWith({
    int? focusDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? sessionsBeforeLongBreak,
    bool? autoStartBreaks,
    bool? autoStartPomodoros,
    bool? showNotifications,
  }) {
    return PomodoroSettings(
      focusDuration: focusDuration ?? this.focusDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      sessionsBeforeLongBreak: sessionsBeforeLongBreak ?? this.sessionsBeforeLongBreak,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartPomodoros: autoStartPomodoros ?? this.autoStartPomodoros,
      showNotifications: showNotifications ?? this.showNotifications,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'focusDuration': focusDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'sessionsBeforeLongBreak': sessionsBeforeLongBreak,
      'autoStartBreaks': autoStartBreaks,
      'autoStartPomodoros': autoStartPomodoros,
      'showNotifications': showNotifications,
    };
  }

  factory PomodoroSettings.fromMap(Map<String, dynamic> map) {
    return PomodoroSettings(
      focusDuration: map['focusDuration'] ?? 25,
      shortBreakDuration: map['shortBreakDuration'] ?? 5,
      longBreakDuration: map['longBreakDuration'] ?? 15,
      sessionsBeforeLongBreak: map['sessionsBeforeLongBreak'] ?? 4,
      autoStartBreaks: map['autoStartBreaks'] ?? false,
      autoStartPomodoros: map['autoStartPomodoros'] ?? false,
      showNotifications: map['showNotifications'] ?? true,
    );
  }
}