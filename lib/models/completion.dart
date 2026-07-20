class Completion {
  final int? id;
  final int habitId;
  final DateTime date;

  Completion({
    this.id,
    required this.habitId,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'date': date.toIso8601String(),
    };
  }

  factory Completion.fromMap(Map<String, dynamic> map) {
    return Completion(
      id: map['id'] as int?,
      habitId: map['habit_id'] as int,
      date: DateTime.parse(map['date'] as String),
    );
  }
}
