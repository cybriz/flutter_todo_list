import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todolist/validator/end_date_field_validator.dart';
import 'package:flutter_todolist/validator/start_date_field_validator.dart';
import 'package:flutter_todolist/validator/text_field_validator.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import '../database/database.dart';
import 'package:intl/intl.dart';

TextEditingController _textFieldController;
TextEditingController _dueDateFieldController;
TextEditingController _startDateFieldController;

class AddTaskPage extends StatefulWidget {
  final BuildContext context;
  final AppDatabase db;
  DateTime today;
  DateTime dueDate;
  DateTime startDate;
  Task task;
  TextEditingController textController;

  AddTaskPage(
      {@required this.context,
      @required this.db,
      this.today,
      this.dueDate,
      this.startDate,
      this.task,
      this.textController});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime startDate;

  String getDateAndTime(DateTime value) {
    return '${DateFormat.d().format(value)} ${DateFormat.MMM().format(value)} ${DateFormat.y().format(value)}, ${DateFormat.Hm().format(value)}';
  }

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _textFieldController = TextEditingController();
    _dueDateFieldController = TextEditingController();
    _startDateFieldController = TextEditingController();

    if (widget.task != null) {
      _textFieldController.text =
          _startDateFieldController.text = widget.task.name;

      _startDateFieldController.text =
          getDateAndTime(widget.task.startDate).toString();

      _dueDateFieldController.text =
          getDateAndTime(widget.task.dueDate).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Text(
              widget.task == null ? "Add new To-Do List" : "Edit To-Do List",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // TO DO TITLE
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'To-Do Title',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Container(
                  height: 120,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4.0)),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: TextFormField(
                          key: Key('text'),
                          controller: _textFieldController,
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          validator: TextFieldValidator.validate,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                          maxLines: 5,
                          decoration: InputDecoration.collapsed(
                              hintText: "Please key in your To-Do title here",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffA1A1A1),
                              )),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              validateAndSave();
                            }
                          },
                        ),
                      )),
                ),
                //START DATE
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Start Date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                ),
                InkWell(
                  key: Key('startDate'),
                  onTap: () async {
                    final DateTime due = await showDatePicker(
                      context: context,
                      firstDate: DateTime(
                        widget.today.year,
                        widget.today.month,
                        widget.today.day,
                      ),
                      lastDate: DateTime(widget.today.year + 2, 12, 31),
                      initialDate: widget.task?.startDate ?? widget.today,
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: ThemeData.light(),
                          child: child,
                        );
                      },
                    );

                    if (due != null) {
                      final TimeOfDay time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: TimeOfDay.now().hour + 1,
                          minute: 00,
                        ),
                      );

                      if (time != null) {
                        setState(() {
                          widget.startDate = DateTime(due.year, due.month,
                              due.day, time.hour, time.minute);
                          _startDateFieldController.text =
                              getDateAndTime(widget.startDate).toString();
                          validateAndSave();
                        });
                      } else {
                        setState(() {
                          widget.startDate =
                              DateTime(due.year, due.month, due.day);
                          _startDateFieldController.text =
                              getDateAndTime(widget.startDate).toString();
                          validateAndSave();
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0)),
                        color: Colors.white,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: IgnorePointer(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      controller: _startDateFieldController,
                                      validator:
                                          StartDateFieldValidator.validate,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                      decoration: InputDecoration(
                                          hintText: "Select a date",
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xffA1A1A1),
                                          )),
                                    ),
                                  ),
                                ),
                                Container(
                                    width: 30,
                                    child: Icon(Icons.arrow_drop_down)),
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
                // END DATE
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Estimate End Date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                ),
                InkWell(
                  key: Key('endDate'),
                  onTap: () async {
                    final DateTime due = await showDatePicker(
                      context: context,
                      firstDate: DateTime(
                        widget.today.year,
                        widget.today.month,
                        widget.today.day,
                      ),
                      lastDate: DateTime(widget.today.year + 2, 12, 31),
                      initialDate: widget.task?.dueDate ?? widget.today,
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: ThemeData.light(),
                          child: child,
                        );
                      },
                    );

                    if (due != null) {
                      final TimeOfDay time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: TimeOfDay.now().hour + 1,
                          minute: 00,
                        ),
                      );

                      if (time != null) {
                        setState(() {
                          widget.dueDate = DateTime(due.year, due.month,
                              due.day, time.hour, time.minute);
                          _dueDateFieldController.text =
                              getDateAndTime(widget.dueDate).toString();
                          validateAndSave();
                        });
                      } else {
                        setState(() {
                          DateTime setDueDate =
                              widget.task?.dueDate ?? widget.dueDate;

                          setDueDate = DateTime(due.year, due.month, due.day);
                          _dueDateFieldController.text =
                              getDateAndTime(setDueDate).toString();
                          validateAndSave();
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0)),
                        color: Colors.white,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: IgnorePointer(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      controller: _dueDateFieldController,
                                      validator: EndDateFieldValidator.validate,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintText: "Select a date",
                                          hintStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xffA1A1A1),
                                          )),
                                    ),
                                  ),
                                ),
                                Container(
                                    width: 30,
                                    child: Icon(Icons.arrow_drop_down)),
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: InkWell(
          key: Key('create'),
          onTap: () async {
            if (validateAndSave()) {
              try {
                if (widget.task == null) {
                  await widget.db.taskDao.insertTask(
                    TasksCompanion(
                      name: moor.Value(_textFieldController.value.text),
                      completed: moor.Value(false),
                      dueDate: moor.Value(widget.dueDate),
                      startDate: moor.Value(widget.startDate),
                    ),
                  );
                } else {
                  await widget.db.taskDao.updateTask(
                    widget.task.copyWith(
                      name: _textFieldController.value.text,
                      dueDate: widget.dueDate,
                      startDate: widget.startDate,
                    ),
                  );
                }

                Navigator.pop(context);
                _textFieldController.clear();
                widget.dueDate = null;
              } catch (e) {
                print(e);
              }
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: 40 + MediaQuery.of(context).padding.bottom,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            width: double.infinity,
            color: Colors.black,
            child: Text(widget.task == null ? 'Create Now' : 'Save',
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
          ),
        ));
  }
}
