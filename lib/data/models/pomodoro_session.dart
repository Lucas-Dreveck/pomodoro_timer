class PomodoroSession {
  final int? id;
  final int? topicId;
  final DateTime startTime;
  final DateTime endTime;
  final int duration; // in minutes
  final bool isCompleted;

  PomodoroSession({
    this.id,
    this.topicId,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic_id': topicId,
      'start_time': startTime.millisecondsSinceEpoch,
      'end_time': endTime.millisecondsSinceEpoch,
      'duration': duration,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory PomodoroSession.fromMap(Map<String, dynamic> map) {
    return PomodoroSession(
      id: map['id'],
      topicId: map['topic_id'],
      startTime: DateTime.fromMillisecondsSinceEpoch(map['start_time']),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['end_time']),
      duration: map['duration'],
      isCompleted: map['is_completed'] == 1,
    );
  }

  
}