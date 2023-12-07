import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskist/Common/Database.dart';
import 'package:taskist/Common/Globals.dart' as Globals;
import 'package:taskist/Models/Task.dart';
import 'package:taskist/Views/ChangeThemeView.dart';
import 'package:taskist/Views/RecentlyDeletedView.dart';

import 'AddTaskView.dart';
import 'TaskDetailView.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  bool IsGrid = false;
  List<Task> taskList;

  String selectedSegmentValue = "";
  Timer timer;

  Future<void> loadTaskList() async {
    if(selectedSegmentValue == "All"){
      taskList = await DBProvider.db.getAllTasks();
    }else if(selectedSegmentValue == "Completed"){
      taskList = await DBProvider.db.getCompletedTasks();
    }else if(selectedSegmentValue == "Pending"){
      taskList = await DBProvider.db.getPendingTasks();
    }else{
      taskList = [];
    }
    startTimer();
    setState(() {

    });
  }

  timerMethod(){
    loadTaskList();
    setState(() {

    });
  }

  String getTime(Task taskDetail){
    if(taskDetail.IsTracking ){
      if(!taskDetail.IsCompleted){
        if(taskDetail.StartTime != ""){
          DateTime now = DateTime.now();
          final start = DateTime.parse(taskDetail.StartTime);
          final duration = now.difference(start).inSeconds;
          return Globals.showDurationNumbers(duration);
        }else{
          return "";
        }
      }else{
        return "";
        final start = DateTime.parse(taskDetail.StartTime);
        final end = DateTime.parse(taskDetail.EndTime);;
        final duration = end.difference(start).inSeconds;
        return Globals.showDurationNumbers(duration);
      }

    }else{
      return "";
    }

  }

  startTimer(){
    if(taskList != null && taskList.length>0){
      if(timer != null){
        timer.cancel();
      }
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => timerMethod());
    }else{
      if(timer != null){
        timer.cancel();
      }
    }
  }

  Widget getNoTaskView(){
    if(selectedSegmentValue == "All"){
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
                  Text('No tasks added yet', style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold ),),
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Text('Please click on + button to add Task', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 120,  //To give minus from bottom from center
          )
        ],
      );
    }else{
      return Container();
    }

  }

  Widget getNoCompletedTaskView(){
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
                Text('No tasks completed yet', style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold ),),

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

  Widget getNoPendingTaskView(){
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
                Text('No task pending', style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold ),),

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
      if(selectedSegmentValue == "All"){
        return getNoTaskView();
      }else if(selectedSegmentValue == "Completed"){
        return getNoCompletedTaskView();
      }else if(selectedSegmentValue == "Pending"){
        return getNoPendingTaskView();
      }else{
        return Container(
          color: Colors.green,
        );
      }

    }

  }

  Card _tileWithCard(int position) => Card(
    child: ListTile(
      contentPadding: EdgeInsets.all(8),
      onTap: () async {
        String result = await Navigator.push(context, MaterialPageRoute(
            builder: (context)=>TaskDetailView(TaskDetail: taskList[position],)
        ));
        setState(() {
          //print("Task Status : " + result);
          loadTaskList();
        });
      },
      title: Text(taskList[position].Title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: taskList[position].Color!=""?Globals.colorFromString(taskList[position].Color):Globals.PrimaryColor,
          )
      ),
      subtitle: Container(
        margin: EdgeInsets.only(top: 8),
        child: Text(
          taskList[position].Description,
          overflow: TextOverflow.ellipsis,
          maxLines: 4,
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
      trailing: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 0),
            child: Text(
              Globals.getDateFromString(taskList[position].CreationDate),
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Expanded(
            child: Container(
//              color: Colors.red,
              width: 70,
              child: Align(
                child: Text(
                  getTime(taskList[position]),
                  style: TextStyle(
                    color: Globals.colorFromString(taskList[position].Color),
                    fontSize: 12
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );

  List<Container> _buildGridTileList(int count) => List.generate(
      count,
          (i) => Container(
            child: GestureDetector(
              onTap: () async {
                String result = await Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>TaskDetailView(TaskDetail: taskList[i],)
                ));
                setState(() {
                  //print("Task Status : " + result);
                  loadTaskList();
                });
              },
              child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: taskList[i].Color!=""?Globals.colorFromString(taskList[i].Color):Globals.PrimaryColor,
                          width: 0.8
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: Text(
                                    taskList[i].Title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: taskList[i].Color!=""?Globals.colorFromString(taskList[i].Color):Globals.PrimaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: Icon(
                                  taskList[i].IsCompleted ? Icons.check_circle : Icons.check_circle_outline,
                                  color: taskList[i].Color!=""?Globals.colorFromString(taskList[i].Color):Globals.PrimaryColor,
                                  size: 25,
                                )),
                            )
                          ],
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  taskList[i].Description,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(color: Colors.black54, fontSize: 13),
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              getTime(taskList[i]),
                              style: TextStyle(
                                  color: Globals.colorFromString(taskList[i].Color),
                                  fontSize: 11
                              ),
                            ),
                            Container(
//                              margin: EdgeInsets.only(top: 8),
                              child: Text(
                                Globals.getDateFromString(taskList[i].CreationDate),
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
              ),
            )
      )
  );

  Widget getGridView() {

    if(taskList != null && taskList.length != 0){
      return GridView.extent(
          scrollDirection: Axis.vertical,
          maxCrossAxisExtent: 180,
          padding: const EdgeInsets.all(4),
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          children: _buildGridTileList(taskList.length)
      );
    }else{
      return getNoTaskView();
    }
  }

  Widget getGridIcon(){
    if(taskList!= null && taskList.length != 0){
      return Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          child: Container(
            height: 55,
            width: 55,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(27.5),
                  topRight: Radius.circular(27.5),
                  bottomLeft: Radius.circular(27.5),
                  bottomRight: Radius.circular(27.5)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            margin: EdgeInsets.only(top: 20, right: 20),
            child: Icon(
                Icons.format_list_bulleted,
                color: Globals.PrimaryColor,
                size: 22,
              ),
          ),
          onTap: () {
            setState(() {
              IsGrid = false;
            });
          },
        ),
      );
    }else{
      return Container();
    }
  }

  Widget getListIcon(){
    if(taskList!= null && taskList.length != 0){
      return Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          child: Container(
            height: 55,
            width: 55,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(27.5),
                  topRight: Radius.circular(27.5),
                  bottomLeft: Radius.circular(27.5),
                  bottomRight: Radius.circular(27.5)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
//              color: Colors.red,
            margin: EdgeInsets.only(top: 20, right: 20),
            child: Icon(
              Icons.grid_on,
              color: Globals.PrimaryColor,
              size: 22,
            ),
          ),
          onTap: () {
            setState(() {
              IsGrid = true;
            });
          },
        )
      );
    }else{
      return Container();
    }
  }

  Widget getTaskView() {
    if (IsGrid) {
      return Stack(
        children: <Widget>[
          getGridView(),
          getGridIcon()
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          getListView(),
          getListIcon()
        ],
      );
    }
  }

  Widget getSegmentControl(segmentControlChildren){
    if(taskList!= null && taskList.length==0 && selectedSegmentValue =="All"){
      return Container();
    }
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.only(top: 0),
      child: CupertinoSegmentedControl(
        borderColor: Globals.PrimaryColor,
        pressedColor: Colors.transparent,
        selectedColor: Globals.PrimaryColor,
        children: segmentControlChildren,
        groupValue: selectedSegmentValue,
        onValueChanged: (value){
          selectedSegmentValue = value;
          loadTaskList();
          setState(() {

          });
        },
      ),
    );

  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(timer != null){
      timer.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    selectedSegmentValue = "All";
    startTimer();
    loadTaskList();

  }

  Widget addWidget(String title){
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          color: title == selectedSegmentValue?Colors.white:Globals.PrimaryColor,
//          fontWeight: FontWeight.bold,
          fontSize: 15
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final Map<String, Widget> segmentControlChildren = <String, Widget>{
      "All": addWidget("All"),
      "Completed": addWidget("Completed"),
      "Pending": addWidget("Pending"),
    };

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              'Taskist',
              style: TextStyle(color: Globals.TextColor),
            ),
          backgroundColor: Globals.PrimaryColor,
          leading: Container(
            margin: EdgeInsets.only(left: 20),
            child: GestureDetector(
              child: Icon(
                Icons.delete_sweep,
                color: Globals.TextColor,
                size: 30,
              ),
              onTap: () async {

                String result = await Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>RecentlyDeletedView()
                ));
                setState(() {
                  //print("Task Status : " + result);
                  selectedSegmentValue = "All";
                  loadTaskList();
                });

              },
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 20),
              child: GestureDetector(
                child: Icon(
                  Icons.color_lens,
                  color: Globals.TextColor,
                  size: 30,
                ),
                onTap: () async {

                  String result = await Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>ChangeThemeView()
                  ));
                  setState(() {
                    //print("Task Status : " + result);
                    selectedSegmentValue = "All";
                    loadTaskList();
                  });

                },
              ),
            )
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              getSegmentControl(segmentControlChildren),
              Expanded(
                child: getTaskView(),
              )
            ],
          ),
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(right: 10, bottom: 40),
          width: 65,
          height: 65,
          child: FloatingActionButton(
            tooltip: 'Add Task',
            backgroundColor: Globals.PrimaryColor,
            child: Icon(
              Icons.add,
              color: Globals.TextColor,
              size: 30,
            ),
            onPressed: () async {

               String result = await Navigator.push(context, MaterialPageRoute(
                   builder: (context)=>AddTaskView(IsEditMode: false,)
               ));
               setState(() {
                 //print("Task Status : " + result);
                 selectedSegmentValue = "All";
                 loadTaskList();
               });
            },
          ),
        )
    );
  }
}

