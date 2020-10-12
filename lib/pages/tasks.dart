import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_todolist/common/styles.dart';
import 'package:flutter_todolist/common/tools.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todolist/database/database.dart';
import 'package:flutter_todolist/widgets/checkbox.dart';
import 'add_task.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  TextEditingController _taskFieldController;
  DateTime _today;
  DateTime _dueDate;
  DateTime _startDate;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _taskFieldController = TextEditingController();
    _today = DateTime.now();
    _dueDate = null;
    _startDate = null;
    _timer = Timer.periodic(Duration(minutes: 1), _onTimeChange);
  }

  void _onTimeChange(Timer timer) {
    if (!mounted) return;

    if (mounted) {
      setState(() {
        _today = DateTime.now();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppDatabase _db = Provider.of<AppDatabase>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder<List<Task>>(
        stream: _db.taskDao.watchAllTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              return ListView.builder(
                  padding: EdgeInsets.all(0.0),
                  itemCount: snapshot.data.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                        key: Key(snapshot.data[index].id.toString()),
                        onDismissed: (direction) async {
                          await _db.taskDao.deleteTask(snapshot.data[index]);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Deleted"),
                            duration: Duration(seconds: 5),
                            action: SnackBarAction(
                              label: "Undo",
                              onPressed: () async {
                                await _db.taskDao.insertTask(
                                  snapshot.data[index].copyWith(),
                                );
                              },
                            ),
                          ));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: GestureDetector(
                            key: Key('card'),
                            child: Card(
                              elevation: 8.0,
                              shadowColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20.0, top: 20.0),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(
                                          decoration:
                                              snapshot.data[index].completed
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: snapshot.data[index].completed
                                              ? Colors.black54
                                              : Colors.black87,
                                        ),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 40,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Start Date',
                                                style: kDateTitleStyle,
                                              ),
                                              Text(Tools.formattedDate(snapshot
                                                  .data[index].startDate)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('End Date',
                                                  style: kDateTitleStyle),
                                              Text(Tools.formattedDate(snapshot
                                                  .data[index].dueDate)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Time Left',
                                                  style: kDateTitleStyle),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.23,
                                                child: Builder(
                                                  builder: (context) {
                                                    final DateTime _date =
                                                        snapshot.data[index]
                                                            .dueDate;

                                                    if (_date != null) {
                                                      final DateTime startDate =
                                                          snapshot.data[index]
                                                              .startDate;

                                                      final Duration _due =
                                                          _date.difference(
                                                              startDate);

                                                      if (_due.inDays > 0) {
                                                        return Text(
                                                            "${_due.inDays.abs()} day(s)");
                                                      } else if (_due.inDays ==
                                                          0) {
                                                        if (_due.inHours < 0) {
                                                          return Text(
                                                              "${_due.inHours.abs()} hours ago");
                                                        } else if (_due
                                                                .inHours >
                                                            0) {
                                                          return Text(
                                                              "${Tools.getTimeString(_due.inMinutes)}");
                                                        } else {
                                                          return Text(
                                                              "Due today");
                                                        }
                                                      } else if (_due.inDays <
                                                          0) {
                                                        return Text(
                                                            "${_due.inDays.abs()} days ago");
                                                      } else {
                                                        return Text(
                                                            "Not sure when it's due");
                                                      }
                                                    } else {
                                                      return SizedBox.shrink();
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFFE2DCC6),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15.0),
                                            bottomRight:
                                                Radius.circular(15.0))),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text('Status: ',
                                                  style: kStatusStyle),
                                              Text(
                                                snapshot.data[index].completed
                                                    ? 'Completed'
                                                    : 'Incomplete',
                                                style: kStatusFieldStyle,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Tick if completed'),
                                              SizedBox(width: 8.0),
                                              SquareCheckBox(
                                                checked: snapshot
                                                    .data[index].completed,
                                                onChange: (value) async {
                                                  await _db.taskDao.updateTask(
                                                    snapshot.data[index]
                                                        .copyWith(
                                                            completed: value),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              _editTask(context, _db, snapshot.data[index]);
                            },
                          ),
                        ));
                  });
            } else {
              return Center(
                child: Text("No tasks yet", style: kNoTaskStyle),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8.0,
        onPressed: () {
          Navigator.pushNamed(context, "/task/new",
              arguments: AddTaskPage(
                  context: context,
                  db: _db,
                  today: _today,
                  dueDate: _dueDate,
                  startDate: _startDate));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editTask(BuildContext context, AppDatabase db, Task task) {
    setState(() {
      _taskFieldController.text = task.name;
      _startDate = task.startDate;
      _dueDate = task.dueDate;
    });

    Navigator.pushNamed(context, "/task/new",
        arguments: AddTaskPage(
            context: context,
            db: db,
            today: _today,
            task: task,
            textController: _taskFieldController));
  }
}
