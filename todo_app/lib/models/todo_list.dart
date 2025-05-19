import 'task.dart';

class ToDoList {
  String name;
  List<Task> tasks;

  ToDoList({required this.name, required this.tasks});

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'tasks': tasks.map((task) => task.toJson()).toList()};
  }

  // Construct from JSON
  factory ToDoList.fromJson(Map<String, dynamic> json) {
    return ToDoList(
      name: json['name'] ?? '',
      tasks:
          (json['tasks'] as List<dynamic>)
              .map(
                (taskJson) =>
                    Task.fromJson(Map<String, dynamic>.from(taskJson)),
              )
              .toList(),
    );
  }
}
