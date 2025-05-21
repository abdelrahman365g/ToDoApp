import 'package:flutter/material.dart';
import '../database/database.dart';
import '../components/todo_tile.dart';
import '../models/task.dart';
import 'add_task_page.dart';

class TasksPage extends StatefulWidget {
  final int listIndex;

  const TasksPage({super.key, required this.listIndex});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    super.initState();
    db.loadData();
  }

  void _addTask(Task newTask) {
    setState(() {
      db.lists[widget.listIndex].tasks.add(newTask);
      db.saveData();
    });
  }

  void _toggleTaskCompletion(int taskIndex, bool isDone) {
    setState(() {
      db.lists[widget.listIndex].tasks[taskIndex].isDone = isDone;
      db.saveData();
    });
  }

  void _deleteTask(int taskIndex) {
    setState(() {
      db.lists[widget.listIndex].tasks.removeAt(taskIndex);
      db.saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentList = db.lists[widget.listIndex];

    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        title: Text(currentList.name),
        backgroundColor: Colors.yellow,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddTaskPage(
                    listIndex: widget.listIndex,
                    onTaskAdd: _addTask,
                  ),
            ),
          );
        },
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: currentList.tasks.length,
        itemBuilder: (context, index) {
          final task = currentList.tasks[index];
          return ToDoTile(
            title: task.title,
            description: task.description,
            dueDate: task.dueDate,
            isDone: task.isDone,
            task: task,
            onChanged: (value) => _toggleTaskCompletion(index, value!),
            deleteTask: (context) => _deleteTask(index),
          );
        },
      ),
    );
  }
}
