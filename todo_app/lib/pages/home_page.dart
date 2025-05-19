import 'package:flutter/material.dart';
import 'package:todo_app/components/list_tile.dart';
import 'package:todo_app/models/todo_list.dart';
import 'package:todo_app/pages/tasks_page.dart';
import '../database/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ToDoDatabase db = ToDoDatabase();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    db.loadData();
  }

  void createNewList() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.yellow[300],
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Enter list name",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  db.lists.add(ToDoList(name: _controller.text, tasks: []));
                  _controller.clear();
                });
                db.saveData();
                Navigator.pop(context);
              },
              child: const Text("Create List"),
            ),
          ],
        );
      },
    );
  }

  void _deleteList(int index) {
    setState(() {
      db.lists.removeAt(index);
      db.saveData(); // Save updated data to the database
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: db.lists.length,
        itemBuilder: (context, index) {
          final list = db.lists[index];
          return ListTileWidget(
            title: list.name,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TasksPage(listIndex: index),
                ),
              ).then((_) => setState(() {}));
            },
            onDelete: (context) => _deleteList(index),
          );
        },
      ),
    );
  }
}
