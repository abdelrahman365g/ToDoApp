class Task {
  String title;
  String description;
  DateTime? dueDate;
  bool isDone;

  Task({
    required this.title,
    this.description = '',
    this.dueDate,
    required this.isDone,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'isDone': isDone,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      isDone: json['isDone'] ?? false,
    );
  }
}
