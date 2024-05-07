import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() {
    return _TodoListState();
  }
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo AI"),
      ),
      body: Column(
        children: [
          const TextField(
            minLines: 2,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "What do you need to do? Or what have you done?",
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: false,
              itemBuilder: (context, index) => Text("index: $index"),
              itemCount: 50,
            ),
          ),
        ],
      ),
    );
  }
}
