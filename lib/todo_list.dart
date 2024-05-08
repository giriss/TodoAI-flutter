import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo_ai/natural_language_prompt.dart';
import 'package:todo_ai/todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() {
    return _TodoListState();
  }
}

class _TodoListState extends State<TodoList> {
  final _controller = TextEditingController();

  bool _isLoading = false;
  List<Map<String, Object>> _todos = _defaultTodos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo AI"),
      ),
      body: Column(
        children: [
          NaturalLanguagePrompt(
            onSubmitted: _onSubmitted,
            controller: _controller,
            disabled: _isLoading,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              physics: const ScrollPhysics(),
              shrinkWrap: false,
              itemBuilder: (context, index) {
                final todo = _todos[index];

                return Todo(
                  title: todo["title"] as String,
                  description: todo["description"] as String?,
                  completed: todo["completed"] as bool,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmitted(String message) async {
    if (message == "") return;

    setState(() {
      _isLoading = true;
    });

    final httpClient = HttpClient();
    final uri = Uri.parse('https://todoai.gopaul.me/ask');
    final request = await httpClient.postUrl(uri);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

    final body = {
      "message": message,
      "todos": _todos,
    };

    request.add(utf8.encode(json.encode(body)));
    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await response.transform(utf8.decoder).join();
      final responseJson =
          List<Map<String, dynamic>>.from(json.decode(responseBody));
      for (final action in responseJson) {
        final function = Map<String, String>.from(action["function"]);
        final name = function["name"]!;
        final arguments =
            Map<String, Object>.from(json.decode(function["arguments"]!));

        if (name == "mark_as_done") {
          setState(() {
            _todos = _todos
                .map((todo) => arguments["id"] == todo["id"]
                    ? {...todo, "completed": true}
                    : todo)
                .toList();
          });
        } else if (name == "add") {
          setState(() {
            _todos = [
              {
                "id": (_todos[0]["id"] as int) + 1,
                "title": arguments["title"]!,
                "description": arguments["description"]!,
                "completed": false,
              },
              ..._todos
            ];
          });
        }
      }
      _controller.clear();
      setState(() {
        _isLoading = false;
      });
    }
  }
}

const _defaultTodos = [
  {
    "id": 4,
    "title": "Feed the dogs",
    "description": "Remember to feed the dogs before 6pm",
    "completed": false,
  },
  {
    "id": 3,
    "title": "Grocery shopping",
    "description": "Buy milk, eggs, bread, and fresh vegetables",
    "completed": false,
  },
  {
    "id": 2,
    "title": "Jogging",
    "description": "Go for a 30-minute jog in the park",
    "completed": false,
  },
  {
    "id": 1,
    "title": "Practice singing",
    "description": "Practice new song for upcoming TikTok upload",
    "completed": false,
  },
  {
    "id": 0,
    "title": "Study Python",
    "description": "Complete one Python tutorial on loops and functions",
    "completed": false,
  },
];
