import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_edit_page.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final Function(Task) onTaskUpdate;

  const TaskDetailsPage({
    super.key,
    required this.task,
    required this.onTaskUpdate,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task; // Initialize the local task state
  }

  void _updateTask(Task updatedTask) {
    setState(() {
      _task = updatedTask; // Update the local task state
    });
    widget.onTaskUpdate(updatedTask); // Notify the parent about the update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          TaskEditPage(task: _task, onTaskUpdate: _updateTask),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              _task.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              _task.description.isEmpty ? 'No description' : _task.description,
              style: TextStyle(
                fontSize: 16,
                color: _task.description.isEmpty ? Colors.grey : Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Due Date',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text(
                    _task.dueDate == null
                        ? 'No due date'
                        : '${_task.dueDate!.day}/${_task.dueDate!.month}/${_task.dueDate!.year}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
