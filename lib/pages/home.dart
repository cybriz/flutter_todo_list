import 'package:flutter/material.dart';
import 'package:flutter_todolist/common/styles.dart';
import 'package:flutter_todolist/pages/tasks.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Text(
              "${"To-Do List"}",
              style: kAppBarStyle,
            ),
          ),
        ),
        body: TasksPage());
  }
}
