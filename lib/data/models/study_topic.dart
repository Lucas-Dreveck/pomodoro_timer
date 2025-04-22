class StudyTopic {
  final int? id;
  final String name;
  final int color;

  StudyTopic({
    this.id,
    required this.name,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }

  factory StudyTopic.fromMap(Map<String, dynamic> map) {
    return StudyTopic(
      id: map['id'],
      name: map['name'],
      color: map['color'],
    );
  }
}