import 'task.dart';
import 'priority.dart';

extension TaskCopyWith on Task {
  Task copyWith({
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
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      userId: userId ?? this.userId,
    );
  }
}
