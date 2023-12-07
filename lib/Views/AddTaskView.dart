import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:taskist/Common/Database.dart';
import 'package:taskist/Common/Globals.dart' as Globals;
import 'package:intl/intl.dart';
import 'package:taskist/Models/Task.dart';

class AddTaskView extends StatefulWidget {
  final bool IsEditMode;
  final Task TaskDetail;

  AddTaskView({Key key, @required this.IsEditMode, @required this.TaskDetail})
      : super(key: key);

  @override
  _AddTaskViewState createState() => _AddTaskViewState(IsEditMode, TaskDetail);
}

class _AddTaskViewState extends State<AddTaskView> {
  bool IsEditMode;
  bool IsTracking = false;
  Task TaskDetail;

  Color TaskColor = Colors.red;

  _AddTaskViewState(this.IsEditMode, this.TaskDetail); //constructor

  static TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  Widget addTextField(
      String placeHolder, bool IsEnabled, TextEditingController txtContol) {
    return Container(
      margin: EdgeInsets.only(top: 15, right: 20, left: 20),
      child: TextField(
        controller: txtContol,
        cursorColor: Globals.PrimaryColor,
        obscureText: false,
        readOnly: IsEnabled,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: placeHolder,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Globals.PrimaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            )),
      ),
    );
  }

  Widget addTextArea(
      String placeHolder, bool IsEnabled, TextEditingController txtControl) {
    return Container(
      margin: EdgeInsets.only(top: 15, right: 20, left: 20),
      child: TextField(
        controller: txtControl,
        cursorColor: Globals.PrimaryColor,
        obscureText: false,
        readOnly: IsEnabled,
        keyboardType: TextInputType.multiline,
        maxLines: 6,
        maxLength: 250,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: placeHolder,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Globals.PrimaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            )),
      ),
    );
  }

  Widget getBottomButton() {
    if (IsEditMode != null && IsEditMode == true) {
      return GestureDetector(
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Text('Update Task',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20.0,
                    color: Globals.TextColor)),
          ),
        ),
        onTap: () async {
          if (txtTitleContoller.text.trim().length == 0) {
            Globals.showToastMessage(context, "Please enter task title");
            return;
          } else if (txtDescriptionContoller.text.trim().length == 0) {
            Globals.showToastMessage(context, "Please enter task description");
            return;
          } else {
            Task updateTask = Task(
                Id: TaskDetail.Id,
                Title: txtTitleContoller.text,
                Description: txtDescriptionContoller.text,
                CreationDate: creationDate,
                IsCompleted: TaskDetail.IsCompleted,
                IsDeleted: TaskDetail.IsDeleted,
                StartTime: TaskDetail.StartTime,
                EndTime: TaskDetail.EndTime,
                Duration: TaskDetail.Duration,
                Color: TaskColor.toString(),
                IsTracking: IsTracking);

            //UPDATE TASK

            if (IsTracking) {
              showStartTrackOnUpdateDialog(context, updateTask);
            } else {
              await DBProvider.db.updateTask(updateTask);
              setState(() {
                Globals.showToastMessage(context, "Task updated successfully");
                new Future.delayed(new Duration(seconds: 0), () {
                  Navigator.pop(context, updateTask);
                });
              });
            }
          }
        },
      );
    } else {
      return GestureDetector(
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Text('Save Task',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20.0,
                    color: Globals.TextColor)),
          ),
        ),
        onTap: () async {
          if (txtTitleContoller.text.trim().length == 0) {
            Globals.showToastMessage(context, "Please enter task title");
            return;
          } else if (txtDescriptionContoller.text.trim().length == 0) {
            Globals.showToastMessage(context, "Please enter task description");
            return;
          } else {
            //INSERT TASK

            Task newTask = Task(
                Title: txtTitleContoller.text,
                Description: txtDescriptionContoller.text,
                CreationDate: creationDate,
                IsCompleted: false,
                IsDeleted: false,
                StartTime: "",
                EndTime: "",
                Duration: 0,
                Color: Globals.colorFromString(TaskColor.toString()).toString(),
                IsTracking: IsTracking);

            if (IsTracking) {
              showStartTrackDialog(context, newTask);
            } else {
              //Save Task
              try {
                await DBProvider.db.newTask(newTask);
                setState(() {
                  Globals.showToastMessage(context, "Task saved successfully");
                  new Future.delayed(new Duration(seconds: 0), () {
                    Navigator.pop(context, 'Added New Task');
                  });
                });
              } catch (err) {
                print('P Add Task Error : ' + err.toString());
              }
            }
          }
        },
      );
    }
  }

  showStartTrackDialog(BuildContext context, Task newTask) {
    // Create button
    Widget yesButton = FlatButton(
      child: Text("Save & Start Tracking",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
      onPressed: () async {
        Navigator.of(context).pop();
        newTask.StartTime = DateTime.now().toString();
        await DBProvider.db.newTask(newTask);
        setState(() {
          Globals.showToastMessage(context, "Task saved and tracking started");
          new Future.delayed(new Duration(seconds: 0), () {
            Navigator.pop(context, 'Added New Task');
          });
        });
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Save Task"),
      content: Container(
        margin: EdgeInsets.only(top: 10),
        child: Text("Do you want to start task tracking along?"),
      ),
      actions: [
        FlatButton(
          child: Text(
            "Save",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            Navigator.of(context).pop();

            await DBProvider.db.newTask(newTask);
            setState(() {
              Globals.showToastMessage(context, "Task saved successfully");
              new Future.delayed(new Duration(seconds: 0), () {
                Navigator.pop(context, 'Added New Task');
              });
            });
          },
        ),
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showStartTrackOnUpdateDialog(BuildContext context, Task updateTask) {
    // Create button
    Widget yesButton = FlatButton(
      child: Text("Update & Start Tracking",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
      onPressed: () async {
        Navigator.of(context).pop();
        updateTask.StartTime = DateTime.now().toString();
        await DBProvider.db.updateTask(updateTask);
        setState(() {
          Globals.showToastMessage(
              context, "Task updated and tracking started");
          new Future.delayed(new Duration(seconds: 0), () {
            Navigator.pop(context, updateTask);
          });
        });
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Update Task"),
      content: Container(
        margin: EdgeInsets.only(top: 10),
        child: Text("Do you want to update and start task tracking along?"),
      ),
      actions: [
        FlatButton(
          child: Text(
            "Update",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            Navigator.of(context).pop();

            await DBProvider.db.updateTask(updateTask);
            setState(() {
              Globals.showToastMessage(context, "Task updated successfully");
              new Future.delayed(new Duration(seconds: 0), () {
                Navigator.pop(context, updateTask);
              });
            });
          },
        ),
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget addColorPicker() {
    return Container(
      height: 80,
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      child: Center(
        child: Container(
          width: double.infinity,
//          color: Colors.red,
          margin: EdgeInsets.only(right: 20, left: 20),
          child: Center(
            child: MaterialColorPicker(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              allowShades: false,
              spacing: 10,
              circleSize: ((queryData.size.width - 40) - (20 * 7)) / 7,
              onMainColorChange: (Color color) {
//                String otherColorString = Globals.colorFromString(color.toString()).toString();
//                print(color.toString());
//                print(otherColorString);
                TaskColor = color;
                setState(() {});
              },
              selectedColor: TaskColor,
              colors: [
                Colors.red,
                Colors.amber,
                Colors.orange,
                Colors.lightGreen,
                Colors.lightBlue,
                Colors.grey,
                Colors.deepPurple,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCheckBox() {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(right: 20, left: 20, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              IsTracking ? Icons.check_box : Icons.check_box_outline_blank,
              color: Globals.PrimaryColor,
              size: 35,
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Would you like to track Task?',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20.0,
                      color: Globals.PrimaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        IsTracking = !IsTracking;
        setState(() {});
      },
    );
  }

  Widget getAddTaskView() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            addTextField('Task Title', false, txtTitleContoller),
            addTextArea('Task Description', false, txtDescriptionContoller),
            addTextField('Task Date', true, txtDateContoller),
            addColorPicker(),
            getCheckBox(),
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Globals.PrimaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(27.5),
                          topRight: Radius.circular(27.5),
                          bottomLeft: Radius.circular(27.5),
                          bottomRight: Radius.circular(27.5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 55,
                            child: getBottomButton(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  final txtTitleContoller = TextEditingController();
  final txtDescriptionContoller = TextEditingController();
  final txtDateContoller = TextEditingController();

  var creationDate = "";
  MediaQueryData queryData;

  @override
  void dispose() {
    // TODO: implement dispose
    txtTitleContoller.dispose();
    txtDescriptionContoller.dispose();
    txtDateContoller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (!IsEditMode) {
      var now = DateTime.now();
      creationDate = now.toString();
      txtDateContoller.text =
          DateFormat("E, MMM d, yyyy").format(now); //DateFormat("yy-MM-dd")
    } else {
      txtTitleContoller.text = TaskDetail.Title;
      txtDescriptionContoller.text = TaskDetail.Description;
      creationDate = TaskDetail.CreationDate.toString();
      DateTime newDate = DateTime.parse(TaskDetail.CreationDate);
      txtDateContoller.text = DateFormat("E, MMM d, yyyy").format(newDate);
      TaskColor = Globals.colorFromString(TaskDetail.Color);
      IsTracking = TaskDetail.IsTracking;
    }
  }

  String getTitle() {
    if (IsEditMode != null && IsEditMode == true) {
      return "Edit Task";
    } else {
      return "Add Task";
    }
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          getTitle(),
          style: TextStyle(color: Globals.TextColor),
        ),
        backgroundColor: Globals.PrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 600,
          child: getAddTaskView(),
        ),
      ),
    );
  }
}
