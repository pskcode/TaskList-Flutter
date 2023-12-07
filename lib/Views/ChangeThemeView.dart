import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskist/Common/Database.dart';
import 'package:taskist/Common/Globals.dart' as Globals;
import 'package:taskist/Models/Task.dart';
import 'package:taskist/Views/RecentlyDeletedView.dart';

class ChangeThemeView extends StatefulWidget {
  @override
  _ChangeThemeViewState createState() => _ChangeThemeViewState();
}

class Theme {
  Color color;
  String colorName;

  Theme({this.color, this.colorName});
}

class _ChangeThemeViewState extends State<ChangeThemeView> {
  List<Theme> themeList;

  Future<void> loadThemeList() async {
    themeList = [
      Theme(
          color: Globals.colorFromString(
              Color.fromRGBO(244, 67, 54, 1.0).toString()),
          colorName: "Default"),
      Theme(
          color: Globals.colorFromString(Colors.black.toString()),
          colorName: "Black"),
//      Theme(color: Colors.red, colorName: "Red"),
      Theme(
          color: Globals.colorFromString(Colors.pink.toString()),
          colorName: "Pink"),
      Theme(
          color: Globals.colorFromString(Colors.orange.toString()),
          colorName: "Orange"),
      Theme(
          color: Globals.colorFromString(Colors.purple.toString()),
          colorName: "Purple"),
      Theme(
          color: Globals.colorFromString(Colors.indigo.toString()),
          colorName: "Indigo"),
      Theme(
          color: Globals.colorFromString(Colors.lightBlue.toString()),
          colorName: "Sky Blue"),
      Theme(
          color: Globals.colorFromString(Colors.teal.toString()),
          colorName: "Teal"),
      Theme(
          color: Globals.colorFromString(Colors.green.toString()),
          colorName: "Green"),
    ];
  }

  Widget getListView() {
    return ListView.builder(
        itemCount: themeList.length,
        itemBuilder: (BuildContext context, int position) {
          return _tileWithCard(position);
        });
  }

  Card _tileWithCard(int position) {
//    String msg = "P : Global: " + Globals.PrimaryColor.toString() + " List: "+themeList[position].color.toString();
//    print(msg);
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        onTap: () async {
          Globals.PrimaryColor = themeList[position].color;
          final AppPreference = await SharedPreferences.getInstance();
          AppPreference.setString(
              Globals.SelectedTheme, themeList[position].color.toString());
          setState(() {});
        },
        title: Text(themeList[position].colorName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: themeList[position].color,
            )),
        subtitle: Text("Demo data for normal text",
            style: TextStyle(
              color: themeList[position].color,
            )),
        trailing: Container(
          decoration: BoxDecoration(
              color: themeList[position].color,
              border: Border.all(color: Colors.black, width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          margin: EdgeInsets.only(right: 15),
          height: 35,
          width: 35,
        ),
        leading: Icon(
          Globals.PrimaryColor.toString() ==
                  themeList[position].color.toString()
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: themeList[position].color,
          size: 25,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadThemeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Change Theme',
          style: TextStyle(color: Globals.TextColor),
        ),
        backgroundColor: Globals.PrimaryColor,
      ),
      body: Center(
        child: Container(
          child: getListView(),
        ),
      ),
    );
  }
}
