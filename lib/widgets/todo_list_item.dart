import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.todo,
    required this.onDelete,
  });

  final Todo todo;
  final Function(Todo) onDelete;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Slidable(
        actionExtentRatio: 0.25,
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: 'Excluir',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              onDelete(todo);
            },
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                style: const TextStyle(fontSize: 12),
                DateFormat('dd/MM/yyyy - HH:mm').format(todo.date),
              ),
              Text(
                todo.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
