
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

Color PrimaryColor = null; //Color.fromRGBO(244, 67, 54, 1.0);
Color TextColor = Color.fromRGBO(255, 255, 255, 1.0);

//Static Keys
final String SelectedTheme = "SelectedTheme";

showToastMessage(BuildContext context, String Message) {
  Fluttertoast.showToast(
      msg: Message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white
  );
}

String getDateFromString(String date){
  DateTime NewDate = DateTime.parse(date);
  String prnDate = DateFormat("d/MM/yyyy").format(NewDate);
  return prnDate;
}

String getStartEndTime(String date){
  DateTime NewDate = DateTime.parse(date);
  String prnDate = DateFormat("hh:mm:ss, MMM d, yyyy").format(NewDate);
  return prnDate;
}

String showDuration(int duration){

  int hour = (duration/3600).floor();
  int minute = ((duration % 3600)/60).floor();
  int seconds = ((duration % 3600) % 60).floor();

  String output;

  String h = hour>0?hour.toString() + " Hours " : "";
  String m = minute>0?minute.toString() + " Minutes " : "";
  String s = seconds>0?seconds.toString() + " Seconds" : "";

  output = h + m + s;
//  print("Duration :"+output);
  return output;
}

String showDurationNumbers(int duration){

  int hour = (duration/3600).floor();
  int minute = ((duration % 3600)/60).floor();
  int seconds = ((duration % 3600) % 60).floor();

  String output;

  String h = hour>0?(hour.toString().length<2?"0"+hour.toString():hour.toString())+ ":":"00:";
  String m = minute>0?(minute.toString().length<2?"0"+minute.toString():minute.toString()) + ":":"00:";
  String s = seconds>0?(seconds.toString().length<2?"0"+seconds.toString():seconds.toString()) : "00";

  output = h + m + s;
//  print("Duration :"+output);
  return output;
}

Color colorFromString(String colorString){
  String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
  int value = int.parse(valueString, radix: 16);
  Color otherColor = new Color(value);
  return otherColor;
}