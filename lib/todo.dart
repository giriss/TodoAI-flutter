import 'package:flutter/material.dart';

class Todo extends StatelessWidget {
  final String title;
  final String? description;
  final bool completed;
  final VoidCallback? onToggle;

  const Todo({
    super.key,
    required this.title,
    this.description,
    required this.completed,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(
          completed ? Icons.check_circle : Icons.circle_outlined,
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: description == null
            ? null
            : Text(
                description!,
                style: TextStyle(
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
        onTap: onToggle,
      );
}
