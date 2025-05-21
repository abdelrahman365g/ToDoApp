import 'package:hive/hive.dart';
import '../models/todo_list.dart';

class ToDoDatabase {
  final _box = Hive.box('todoBox');

  List<ToDoList> lists = [];

  void loadData() {
    final storedData = _box.get('todoLists', defaultValue: []);
    if (storedData is List) {
      lists =
          storedData
              .map(
                (listJson) =>
                    ToDoList.fromJson(Map<String, dynamic>.from(listJson)),
              )
              .toList();
    }
  }

  void saveData() {
    final jsonData = lists.map((list) => list.toJson()).toList();
    _box.put('todoLists', jsonData);
  }
}
