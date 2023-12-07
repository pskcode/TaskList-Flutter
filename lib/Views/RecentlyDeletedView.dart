import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskist/Common/Database.dart';
import 'package:taskist/Common/Globals.dart' as Globals;
import 'package:taskist/Models/Task.dart';

import 'AddTaskView.dart';
import 'TaskDetailView.dart';

class RecentlyDeletedView extends StatefulWidget {
  @override
  _RecentlyDeletedViewState createState() => _RecentlyDeletedViewState();
}

class _RecentlyDeletedViewState extends State<RecentlyDeletedView> {

  List<Task> taskList;

  Future<void> loadTaskList() async {
    taskList = await DBProvider.db.getAllDeletedTasks();
    setState(() {
      print(taskList);
    });
  }

  Widget getNoTaskView(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 0),
          child: Center(
            child: Column(
              children: <Widget>[
                Opacity(
                  opacity: 1.0,
                  child: Image.asset('assets/images/no-tasks1.png',height: 120,width: 120),
                ),
                Text('No tasks deleted yet', style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold ),),

              ],
            ),
          ),
        ),
        Container(
          height: 120,  //To give minus from bottom from center
        )
      ],
    );
  }

  Widget getListView() {

    if(taskList != null && taskList.length != 0){
      return ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (BuildContext context, int position) {
            return _tileWithCard(position);
          });
    }else{
      return getNoTaskView();
    }

  }

  showRecoverDialog(BuildContext context, Task TaskDetail) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Yes", style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: () async {
        Navigator.of(context).pop();
        TaskDetail.IsDeleted = false;
        await DBProvider.db.updateTask(TaskDetail);
        setState(() {
          Globals.showToastMessage(context, "Task recovered successfully");
          new Future.delayed(new Duration(seconds: 0), () {
            Navigator.pop(context);
          });
        });
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(

      title: Text("Recover Task"),
      content: Container(
        margin: EdgeInsets.only(top: 10),
        child: Text("Are you sure you want to recover this task?"),
      ),
      actions: [
        FlatButton(
          child: Text("No", style: TextStyle(fontWeight: FontWeight.bold),),
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

  Widget _tileWithCard(int position) => Dismissible(
    key: Key(taskList[position].Id.toString()),
    background: Container(
      color: Colors.red,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Text('Delete Forever', style: TextStyle(color: Colors.white, fontSize: 20),),
            )
          ],
        ),
      ),
    ),
    direction: DismissDirection.endToStart,
    child: Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        onTap: () async {
          showRecoverDialog(context, taskList[position]);
        },
        title: Text(taskList[position].Title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: taskList[position].Color!=""?Globals.colorFromString(taskList[position].Color):Globals.PrimaryColor)),
        subtitle: Container(
          margin: EdgeInsets.only(top: 8),
          child: Text(
            taskList[position].Description,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
        leading: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                taskList[position].IsCompleted? Icons.radio_button_checked:Icons.radio_button_unchecked,
                color: taskList[position].Color!=""?Globals.colorFromString(taskList[position].Color):Globals.PrimaryColor,
                size: 30,
              ),
            ],
          ),
        ),
        trailing: GestureDetector(
          child: Container(
            margin: EdgeInsets.only(top: 0),
            child: Text(
              Globals.getDateFromString(taskList[position].CreationDate),
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.normal),
            ),
          ),
          onTap: () {
            print("Clicked");
          },
        ),
      ),
    ),
    confirmDismiss: (DismissDirection direction) async {
      return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Delete forever"),
            content: const Text("Are you sure you want delete this task forever?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () => {
                  Navigator.of(context).pop(false)
                },
                child: const Text("No"),
              ),
              FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    await DBProvider.db.deleteTask(taskList[position].Id);
                    loadTaskList();
                    setState(() {

                    });
                  },
                  child: const Text("Yes, Delete", style: TextStyle(color: Colors.red),)
              ),
            ],
          );
        },
      );
    },
    onDismissed: (direction){
      loadTaskList();
      setState(() {

      });
    },
  );

  Widget getTaskView() {
    return Stack(
      children: <Widget>[
        getListView(),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTaskList();

  }

  showDeleteDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Empty Now", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
      onPressed: () async {
        Navigator.of(context).pop();
        await DBProvider.db.deleteAllTask();
        loadTaskList();
        setState(() {
          Globals.showToastMessage(context, "Trash emptied");

        });
      },
    );

    // Create AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(

      title: Text("Empty Trash"),
      content: Container(
        margin: EdgeInsets.only(top: 10),
        child: Text("Are you sure you want to empty trash? It won't be recovered anymore."),
      ),
      actions: [
        FlatButton(
          child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold),),
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

  Widget getDeleteAllButton(){
    if(taskList != null && taskList.length > 0){
      return Container(
        margin: EdgeInsets.only(right: 20),
        child: GestureDetector(
          child: Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
          onTap: (){
            showDeleteDialog(context);
          },
        ),
      );
    }else{
      return Container();
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Recently Deleted',
            style: TextStyle(color: Globals.TextColor),
          ),
          backgroundColor: Globals.PrimaryColor,
          actions: <Widget>[
            getDeleteAllButton(),
          ],
        ),
        body: Center(
          child: Container(
            child: getTaskView(),
          ),
        ),

    );
  }
}

