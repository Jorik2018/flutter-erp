import 'todo.dart';
import 'priority.dart';

extension TodoCopyWith on Todo {
  Todo copyWith({
    String? id,
    String? title,
    String? content,
    Priority? priority,
    bool? isDone,
    String? userId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      userId: userId ?? this.userId,
    );
  }
}