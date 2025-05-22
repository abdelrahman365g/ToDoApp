import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/components/list_tile.dart';
import 'package:todo_app/models/todo_list.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/pages/tasks_page.dart';
import 'package:todo_app/components/dialog_box.dart';
import '../database/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ToDoDatabase db = ToDoDatabase();
  final _controller = TextEditingController();
  List<Task> reminderTasks = [];

  @override
  void initState() {
    super.initState();
    db.loadData();
    _loadReminders();
  }

  void _loadReminders() {
    final now = DateTime.now();
    final nextDay = now.add(const Duration(hours: 24));

    setState(() {
      reminderTasks =
          db.lists
              .expand((list) => list.tasks)
              .where(
                (task) =>
                    !task.isDone &&
                    task.dueDate != null &&
                    task.dueDate!.isAfter(now) &&
                    task.dueDate!.isBefore(nextDay),
              )
              .toList();
    });
  }

  void createNewList() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: () {
            setState(() {
              db.lists.add(ToDoList(name: _controller.text, tasks: []));
              _controller.clear();
            });
            db.saveData();
            Navigator.pop(context);
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  void _deleteList(int index) {
    setState(() {
      db.lists.removeAt(index);
      db.saveData();
      _loadReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reminderSection =
        reminderTasks.isNotEmpty
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    "⏰ Reminders (due in 24h)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ...reminderTasks.map(
                  (task) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text(
                        "Due: ${DateFormat('MMM d, yyyy').format(task.dueDate!)}",
                      ),
                    ),
                  ),
                ),
                const Divider(),
              ],
            )
            : const SizedBox.shrink();

    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        title: const Text('My Lists'),
        backgroundColor: Colors.yellow,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewList,
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          db.loadData();
          _loadReminders();
        },
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            reminderSection,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "📋 My Lists",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...db.lists.asMap().entries.map((entry) {
              final index = entry.key;
              final list = entry.value;
              return ListTileWidget(
                title: list.name,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TasksPage(listIndex: index),
                    ),
                  ).then(
                    (_) => setState(() {
                      _loadReminders();
                    }),
                  );
                },
                onDelete: (context) => _deleteList(index),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
