import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Master(),
    );
  }
}

class Master extends StatefulWidget {
  const Master({Key? key}) : super(key: key);

  @override
  State<Master> createState() => _MasterState();
}

class _MasterState extends State<Master> {
  late List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _getTasks();
  }

  void _getTasks() async {
    try {
      final response =
          await Dio().get('https://jsonplaceholder.typicode.com/todos');

      const List<Task> items = [];

      if (response.statusCode == 200) {
        for (var json in response.data['data']) {
          var item = Task.fromJson(json);
          items.add(item);
        }
      }

      setState(() {
        _tasks = items;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _tasksList() {
      return ListView.separated(
        padding: const EdgeInsets.all(0),
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return TaskPreview(task: _tasks[index]);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("API Fetch"),
      ),
      body: _tasksList(),
    );
  }
}

class TaskPreview extends StatelessWidget {
  const TaskPreview({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(task.title!),
      ],
    );
  }
}

class Task {
  int? userId;
  int? id;
  String? title;
  bool? completed;

  Task({this.userId, this.id, this.title, this.completed});

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        completed = json['completed'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'completed': completed,
        'title': title,
      };
}
