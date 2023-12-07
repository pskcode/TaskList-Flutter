import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskist/Views/HomeView.dart';
import 'package:taskist/Common/Globals.dart' as Globals;

loadAppThemeColor(BuildContext context) async {

  var AppPreference = await SharedPreferences.getInstance();
  if(Globals.PrimaryColor == null){
    Globals.showToastMessage(context, "Loading Theme");

    if(AppPreference.getString(Globals.SelectedTheme) != null){
      Globals.PrimaryColor = Globals.colorFromString(AppPreference.getString(Globals.SelectedTheme));
      AppPreference.setString(Globals.SelectedTheme, Globals.PrimaryColor.toString());
    }else{
      Globals.PrimaryColor = Color.fromRGBO(244, 67, 54, 1.0);
      AppPreference.setString(Globals.SelectedTheme, Globals.PrimaryColor.toString());
    }
  }

}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Future<String>method(){

  }

  @override
  Widget build(BuildContext context) {

    loadAppThemeColor(context);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeView(),
    );

  }
}