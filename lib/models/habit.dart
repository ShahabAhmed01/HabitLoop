class Habit {
  final int? id;
  final String name;
  final String? icon;
  final int color;
  final String frequency;
  final DateTime createdAt;

  Habit({
    this.id,
    required this.name,
    this.icon,
    this.color = 0xFF6750A4,
    this.frequency = 'daily',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'frequency': frequency,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int?,
      name: map['name'] as String,
      icon: map['icon'] as String?,
      color: map['color'] as int,
      frequency: map['frequency'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Habit copyWith({
    int? id,
    String? name,
    String? icon,
    int? color,
    String? frequency,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      frequency: frequency ?? this.frequency,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
