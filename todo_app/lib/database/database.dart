import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  final _thebox = Hive.box('thebox');

  List toDoList = [];

  void createIntialTasks() {
    toDoList = [
      ['Buy Milk', false],
      ['Buy Eggs', false],
      ['Buy Bread', false],
    ];
  }

  void loadData() {
    toDoList = _thebox.get("TODOLIST");
  }

  void updateData() {
    _thebox.put("TODOLIST", toDoList);
  }
}
