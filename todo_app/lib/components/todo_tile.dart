import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String title;
  final bool isDone;
  final Function(bool?)? onChanged;
  final Function(BuildContext) deleteTask;

  const ToDoTile({
    super.key,
    required this.title,
    required this.isDone,
    this.onChanged,
    required this.deleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteTask,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Checkbox(
                value: isDone,
                onChanged: onChanged,
                activeColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
