import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';

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
        dividerColor: Colors.blue,
      ),
      home: const TasksMaster(),
    );
  }
}

class TasksMaster extends StatefulWidget {
  const TasksMaster({Key? key}) : super(key: key);

  @override
  State<TasksMaster> createState() => _TasksMasterState();
}

class _TasksMasterState extends State<TasksMaster> {
  late final List<Task> _tasks = [];

  String apiEndPoint = "https://jsonplaceholder.typicode.com";

  late Dio dio;
  late Response response;

  _TasksMasterState() {
    BaseOptions options = BaseOptions(
      baseUrl: apiEndPoint,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    dio = Dio(options);
  }

  @override
  void initState() {
    super.initState();
    _readAll();
  }

  Future<void> _readAll() async {
    try {
      response = await dio.request("/todos");

      if (response.statusCode == 200) {
        for (var record in response.data) {
          var task = Task.fromJson(record);

          setState(() {
            _tasks.add(task);
          });
        }
      } else {
        // ignore: avoid_print
        print("error");
      }
    } catch (e) {
      // ignore: avoid_print
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
      children: [Text(task.title!), const Text("demo")],
    );
  }
}

class Task {
  int? userId;
  int? id;
  String? title;
  bool? completed;

  Task({this.userId, this.id, this.title, this.completed});

  //parse json data given from API to Dart Object
  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        completed = json['completed'],
        userId = json['userId'];

//prepare json data from Dart object to send to API
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'completed': completed,
        'title': title,
      };
}
