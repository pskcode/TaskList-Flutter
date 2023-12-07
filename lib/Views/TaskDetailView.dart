import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskist/Common/Database.dart';
import 'package:taskist/Common/Globals.dart' as Globals;
import 'package:taskist/Models/Task.dart';
import 'package:taskist/Views/AddTaskView.dart';

class TaskDetailView extends StatefulWidget {
  final Task TaskDetail;
  TaskDetailView({Key key, @required this.TaskDetail}) : super(key: key);

  @override
  _TaskDetailViewState createState() => _TaskDetailViewState(TaskDetail);
}

class _TaskDetailViewState extends State<TaskDetailView> {
  Task TaskDetail;
  _TaskDetailViewState(this.TaskDetail); //constructor

  Widget getStartTime() {
    if (!TaskDetail.IsTracking) {
      return Container();
    }

    if (TaskDetail.StartTime != "") {
      //started
      return addTextField('Start Time', txtStartDateContoller);
    } else {
      //not started
      return Container();
    }

//    if(TaskDetail.IsCompleted){
//      return addTextField('Start Time', txtStartDateContoller);
//    }else{
//      return Container();
//    }
  }

  Widget getDuration() {
    if (!TaskDetail.IsTracking) {
      return Container();
    }

    if (TaskDetail.StartTime != "") {
      //started
      return addTextField('Duration', txtDurationContoller);
    } else {
      //not started
      return Container();
    }

//    if(TaskDetail.IsCompleted){
//      return addTextField('Duration', txtDurationContoller);
//    }else{
//      return Container();
//    }
  }

  Widget getEndTime() {
    if (!TaskDetail.IsTracking) {
      return Container();
    }
    if (TaskDetail.IsCompleted) {
      return addTextField('End Time', txtEndDateContoller);
    } else {
      return Container();
    }
  }

  Widget addTextField(String placeHolder, TextEditingController txtContol) {
    return Container(
      margin: EdgeInsets.only(top: 15, right: 20, left: 20),
      child: TextField(
        controller: txtContol,
        cursorColor: Globals.PrimaryColor,
        obscureText: false,
        readOnly: true,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
          color: TaskDetail.Color != ""
              ? Globals.colorFromString(TaskDetail.Color)
              : Globals.PrimaryColor,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
          labelText: placeHolder,
          labelStyle: TextStyle(
            color: Globals.PrimaryColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Globals.PrimaryColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Globals.PrimaryColor,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget addTextArea(String placeHolder, TextEditingController txtControl) {
    return Container(
      margin: EdgeInsets.only(top: 15, right: 20, left: 20),
      child: TextField(
        controller: txtControl,
        cursorColor: Globals.PrimaryColor,
        obscureText: false,
        readOnly: true,
        keyboardType: TextInputType.multiline,
        maxLines: 6,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
          color: TaskDetail.Color != ""
              ? Globals.colorFromString(TaskDetail.Color)
              : Globals.PrimaryColor,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
          labelText: placeHolder,
          labelStyle: TextStyle(
            color: Globals.PrimaryColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Globals.PrimaryColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Globals.PrimaryColor,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget getMarkAsCompleteButton() {
    if (TaskDetail.IsCompleted) {
      return Container();
    }
    if (!TaskDetail.IsTracking) {
      return Container(
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
              child: GestureDetector(
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Text('Mark as Complete',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            color: Globals.TextColor)),
                  ),
                ),
                onTap: () async {
                  //Mark as complete
                  showCompleteTaskDialog(context);
                },
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget getStartEndButtonButton() {
    if (!TaskDetail.IsTracking) {
      return Container();
    }
    if (TaskDetail.StartTime == "") {
      return Container(
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
              child: GestureDetector(
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Text('Start Task',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            color: Globals.TextColor)),
                  ),
                ),
                onTap: () async {
                  //Start Task
                  showStartTaskDialog(context);
                },
              ),
            )
          ],
        ),
      );
    } else if (TaskDetail.EndTime == "") {
      return Container(
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
              child: GestureDetector(
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Text('End Task',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            color: Globals.TextColor)),
                  ),
                ),
                onTap: () async {
                  //END Task
                  showEndTaskDialog(context);
                },
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget getTaskDetailView() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            addTextField('Title', txtTitleContoller),
            addTextArea('Description', txtDescriptionContoller),
            addTextField('Created on', txtDateContoller),
            getStartTime(),
            getEndTime(),
            getDuration(),
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: <Widget>[
                      getStartEndButtonButton(),
                      getMarkAsCompleteButton()
                    ],
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

  final txtStartDateContoller = TextEditingController();
  final txtEndDateContoller = TextEditingController();
  final txtDurationContoller = TextEditingController();

  var creationDate = "";
  Timer timer;

  @override
  void dispose() {
    // TODO: implement dispose
    if (timer != null) {
      timer.cancel();
    }
    txtTitleContoller.dispose();
    txtDescriptionContoller.dispose();
    txtDateContoller.dispose();

    txtStartDateContoller.dispose();
    txtEndDateContoller.dispose();
    txtDurationContoller.dispose();

    super.dispose();
  }

  void loadData() {
    txtTitleContoller.text = TaskDetail.Title;
    txtDescriptionContoller.text = TaskDetail.Description;
    txtDateContoller.text = Globals.getDateFromString(TaskDetail.CreationDate);

    if (TaskDetail.IsTracking) {
      if (TaskDetail.StartTime != "") {
        DateTime now = DateTime.now();
        final start = DateTime.parse(TaskDetail.StartTime);
        ;
        final duration = now.difference(start).inSeconds;

        txtStartDateContoller.text =
            Globals.getStartEndTime(TaskDetail.StartTime);
        txtDurationContoller.text = Globals.showDuration(duration);
      }
      if (TaskDetail.IsCompleted) {
        txtEndDateContoller.text = Globals.getStartEndTime(TaskDetail.EndTime);
        txtDurationContoller.text = Globals.showDuration(TaskDetail.Duration);
      }
    }

    if (TaskDetail.IsTracking &&
        TaskDetail.StartTime != "" &&
        !TaskDetail.IsCompleted) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => timerMethod());
    } else {
      if (timer != null) {
        timer.cancel();
      }
    }
  }

  timerMethod() {
    DateTime now = DateTime.now();
    final start = DateTime.parse(TaskDetail.StartTime);
    ;
    final duration = now.difference(start).inSeconds;
    txtDurationContoller.text = Globals.showDuration(duration);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  showDeleteDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Yes",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
      onPressed: () async {
        Navigator.of(context).pop();
        TaskDetail.IsDeleted = true;
        await DBProvider.db.updateTask(TaskDetail);
        setState(() {
          Globals.showToastMessage(context, "Task deleted successfully");
          new Future.delayed(new Duration(seconds: 0), () {
            Navigator.pop(context);
          });
        });
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Delete Task"),
      content: Container(
        margin: EdgeInsets.only(top: 10),
        child: Text("Are you sure you want to delete task?"),
      ),
      actions: [
        FlatButton(
          child: Text(
            "No",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        okButton,
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

  showCompleteTaskDialog(BuildContext context) {
    // Create button
    Widget yesButton = FlatButton(
      child: Text("Yes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
      onPressed: () async {
        Navigator.of(context).pop();

        TaskDetail.IsCompleted = true;

        await DBProvider.db.updateTask(TaskDetail);
        setState(() {
          loadData();
          Globals.showToastMessage(context, "Task completed successfully");
        });
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Complete Task"),
      content: Container(
        margin: EdgeInsets.only(top: 10),
        child: Text("Are you sure you want to complete task?"),
      ),
      actions: [
        FlatButton(
          child: Text(
            "No",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).pop();
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

  showEndTaskDialog(BuildContext context) {
    // Create button
    Widget yesButton = FlatButton(
      child: Text("Yes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
      onPressed: () async {
        Navigator.of(context).pop();

        DateTime now = DateTime.now();
        final start = DateTime.parse(TaskDetail.StartTime);
        ;
        final duration = now.difference(start).inSeconds;

        TaskDetail.EndTime = now.toString();
        TaskDetail.IsCompleted = true;
        TaskDetail.Duration = duration;

        await DBProvider.db.updateTask(TaskDetail);
        setState(() {
          loadData();
          Globals.showToastMessage(context, "Task completed successfully");
//                  new Future.delayed(new Duration(seconds: 0), () {
//                    Navigator.pop(context, 'Updated Task');
//                  });
        });
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("End Task"),
      content: Container(
        margin: EdgeInsets.only(top: 10),
        child: Text("Are you sure you want to end task tracking?"),
      ),
      actions: [
        FlatButton(
          child: Text(
            "No",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).pop();
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

  showStartTaskDialog(BuildContext context) {
    // Create button
    Widget yesButton = FlatButton(
      child: Text("Yes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
      onPressed: () async {
        Navigator.of(context).pop();

        TaskDetail.StartTime = DateTime.now().toString();
        await DBProvider.db.updateTask(TaskDetail);
        loadData();
        setState(() {
          Globals.showToastMessage(context, "Task started successfully");
        });
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Start Task"),
      content: Container(
        margin: EdgeInsets.only(top: 10),
        child: Text("Are you sure you want to start task tracking?"),
      ),
      actions: [
        FlatButton(
          child: Text(
            "No",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).pop();
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

  Widget getEditButton() {
    if (!TaskDetail.IsCompleted) {
      if (TaskDetail.StartTime != "") {
        return Container();
      }
      return Container(
        margin: EdgeInsets.only(right: 20),
        child: GestureDetector(
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onTap: () async {
            Task result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTaskView(
                          IsEditMode: true,
                          TaskDetail: TaskDetail,
                        )));
            if (result != null) {
              TaskDetail = result;
              setState(() {
                //print("Task Status : " + result);
                loadData();
              });
            }
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Widget getDeleteButton() {
    return Container(
      margin: EdgeInsets.only(right: 20),
      child: GestureDetector(
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        onTap: () {
          showDeleteDialog(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Task Detail',
          style: TextStyle(color: Globals.TextColor),
        ),
        backgroundColor: Globals.PrimaryColor,
        actions: <Widget>[getDeleteButton(), getEditButton()],
      ),
      body: Container(
        color: TaskDetail.IsCompleted
            ? Color.fromRGBO(240, 240, 240, 1)
            : Colors.white,
        child: SingleChildScrollView(
          child: Container(
            height: TaskDetail.IsCompleted ? 620 : 620,
            child: getTaskDetailView(),
          ),
        ),
      ),
    );
  }
}
