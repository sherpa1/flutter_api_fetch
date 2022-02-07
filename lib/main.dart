import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';

//TODO : project structure refactoring : separate each instance into independant file

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

Future<List<Task>> fetchTasks() async {
  String apiEndPoint = "https://jsonplaceholder.typicode.com";

  late Dio dio;
  late Response response;

  BaseOptions options = BaseOptions(
    baseUrl: apiEndPoint,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  dio = Dio(options);

  final List<Task> tasks = [];

  try {
    response = await dio.request("/todos");

    if (response.statusCode == 200) {
      for (var record in response.data) {
        var task = Task.fromJson(record);

        tasks.add(task);
      }
    } else {
      // ignore: avoid_print
      print("error");
    }
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }

  return tasks;
}

List<Task> parseTasks(String response) {
  final parsed = jsonDecode(response).cast<Map<String, dynamic>>();

  return parsed.map<Task>((json) => Task.fromJson(json)).toList();
}

class TasksMaster extends StatelessWidget {
  const TasksMaster({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Fetch"),
      ),
      body: FutureBuilder<List<Task>>(
        future: fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return TasksList(tasks: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class TasksList extends StatelessWidget {
  const TasksList({Key? key, required this.tasks}) : super(key: key);

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return TaskPreview(task: tasks[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
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
