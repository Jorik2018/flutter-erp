import 'package:flutter_erp/apps/flutter_todo/models/priority.dart';

class Task {
  DateTime? date;

  int? status; // 0 - Incomplete, 1 - Complete

  String? id;
  final String title;
  final String? content;
  final Priority? priority;
  final bool isDone;
  final String? userId;

  Task({
    required this.title,
    this.date,
    this.id,
    this.content,
    this.priority = Priority.Low,
    this.isDone = false,
    this.userId,
    this.status,
  });

  Task.withId({
    this.id,
    required this.title,
    required this.date,
    this.content,
    this.priority = Priority.Low,
    this.isDone = false,
    required this.userId,
    this.status,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) {
      map['id'] = id;
    }

    map['title'] = title;
    map['date'] = date?.toIso8601String();
    map['content'] = content;
    map['priority'] = priority?.name;
    map['isDone'] = isDone;
    map['userId'] = userId;
    map['status'] = status;

    return map;
  }

  Task copyWith({
    DateTime? date,
    int? status,
    String? id,
    String? title,
    String? content,
    Priority? priority,
    bool? isDone,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      userId: userId ?? this.userId,
      status: status ?? this.status,
    );
  }

  static Priority? priorityFromMap(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Priority) {
      return value;
    }

    if (value is String) {
      for (final priority in Priority.values) {
        if (priority.name == value || priority.toString() == value) {
          return priority;
        }
      }
    }

    return null;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    print(map);

    return Task.withId(
      id: map['id']?.toString(),
      title: map['title'],
      date: map['date'] != null
          ? DateTime.tryParse(map['date'].toString())
          : null,
      content: map['content'] ?? '',
      priority: priorityFromMap(map['priority']),
      isDone: map['isDone'] == 1 || map['isDone'] == true,
      userId: map['userId']?.toString(),
      status: map['status'],
    );
  }
}
