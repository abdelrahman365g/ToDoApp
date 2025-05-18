import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/components/dialog_box.dart';
import 'package:todo_app/components/todo_tile.dart';
import 'package:todo_app/database/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _thebox = Hive.box('thebox');
  ToDoDatabase db = ToDoDatabase();
  final _controller = TextEditingController();

  @override
  void initState() {
    if (_thebox.get("TODOLIST") == null) {
      db.createIntialTasks();
    } else {
      db.loadData();
    }

    super.initState();
  }

  void changeCheckBox(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateData();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.pop(context);
    db.updateData();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TO DO'), elevation: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder:
              (context, index) => ToDoTile(
                title: db.toDoList[index][0],
                isDone: db.toDoList[index][1],
                onChanged: (value) {
                  changeCheckBox(value, index);
                },
                deleteTask: (context) => deleteTask(index),
              ),
        ),
      ),
    );
  }
}
