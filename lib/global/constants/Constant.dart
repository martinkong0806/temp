import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givenergy/global/colors/Color.dart';
import 'package:givenergy/global/functions/GlobalFunctions.dart';
import 'package:givenergy/screens/authentication/login/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static final String baseURL =
      "http://35.176.205.42:8090/Single_Page_Application/ControllerMobileTest";
  static final String nonBaseURL =
      "http://35.176.205.42:8090/Single_Page_Application/ControllerMobileTest?action=invMeter&date=";
  static final String graphURL =
      "http://35.176.205.42:8090/Single_Page_Application/ControllerMobileTest?action=graphDay&date=";
  static final String batteryURL =
      "http://35.176.205.42:8090/Single_Page_Application/ControllerMobileTest?action=inverter";
  static final String weatherURL =
      "http://api.openweathermap.org/data/2.5/weather?";

  static final String weatherAppID = "APPID=73d09ced2f3cf27bfcb01bb85e2a1493";

  static const String today = "Today";
  static const String monthly = "Monthly";
  static const String yearly = "Yearly";

  static const List<String> filters = <String>[today, monthly, yearly];
  static final gGIVStyle = TextStyle(
    color: Color.gBlueColor,
    fontSize: 55,
  );
  static final gEnergyStyle = TextStyle(
    color: Color.gGreenColor,
    fontSize: 55,
  );

  static void moveToLogin(BuildContext context, String view) {
    Navigator.of(context).pushNamedAndRemoveUntil(view, (route) => false);
  }

  static Future<bool> loginRequest(String url) async {
    var response = await http.post(url);
    final jsonResult = jsonDecode(response.body);
    if (jsonResult['success'] == null) {
      //store the session key in preferences and use with later calls
      storePreference(jsonResult['JSESSIONID'], jsonResult['serialNumber']);
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getSessionID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("sessionID");
  }

  static Future<bool> isFirstDone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('isFirstDone') == null
        ? false
        : preferences.getBool('isFirstDone');
  }

  static firstTimeOpened() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isFirstDone', true);
  }

  static Future<String> getSerialNumber() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("serialNumber");
  }

  static Future<bool> checkSession(String url) async {
    var response = await http.post(url);
    //check if the response starts with html tag this means session is expired and internal server error occur
    return (response.body.toString().startsWith('<')) ? false : true;
  }

  static logoutUser(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("sessionID");
    preferences.remove("serialNumber");
    preferences.remove("isLoggedIn");
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginScreen.view, (route) => false);
  }

  static inDevelopment(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Text(
              "Greetings From ",
              style: TextStyle(color: Color.gWhiteColor),
            ),
            Flexible(child: centerGivEnergyLogo(100)),
          ],
        ),
        content: RichText(
          text: TextSpan(style: TextStyle(color: Color.gWhiteColor), children: [
            TextSpan(
                text:
                    "Welcome to GivEnergy App development version 1.00\n"),
            TextSpan(
              text: "Updated features:\n",
            ),
            TextSpan(
              text: "Animated Energyflow graph\n",
            ),
            TextSpan(
              text: "Graph page(Currently only supports daily power usage graph),\nTODO List:\nEnergy Graph, \nSettings Page \nUpdated on 19/02/2021",
            ),
          ]),
        ),
        actions: [
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "OK",
                style: positiveTBS(),
              ))
        ],
        backgroundColor: Color.gBlackColor,
      ),
      barrierDismissible: true,
    );
  }

  static void storePreference(String sessionID, String serialNum) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString('sessionID', sessionID);
    _pref.setString('serialNumber', serialNum);
    _pref.setString('isLoggedIn', "true");
  }

  static rememberUser(String username, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isRemembered", true);
    sharedPreferences.setString("username", username.trim());
    sharedPreferences.setString("uid", password.trim());
  }

  static String getTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  static String getMonth() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MM');
    return getYear() + "-" + formatter.format(now) + "-01";
  }

  static String getYear() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy');
    return formatter.format(now) + "-01-01";
  }

  static String getCurrentHour() {
    var now = new DateTime.now();
    var formatter = new DateFormat('HH');
    return formatter.format(now);
  }

  static double getVideoTime(int batteryPercent) {
    if (batteryPercent < 100 && batteryPercent >= 90) {
      //above 90
      return 8000;
    } else if (batteryPercent < 90 && batteryPercent >= 80) {
      //above 80
      return 7000;
    } else if (batteryPercent < 80 && batteryPercent >= 70) {
      //above 70
      return 6500;
    } else if (batteryPercent < 70 && batteryPercent >= 60) {
      //above 60
      return 6000;
    } else if (batteryPercent < 60 && batteryPercent >= 50) {
      //above 50
      return 5500;
    } else if (batteryPercent < 50 && batteryPercent >= 40) {
      //above 40
      return 5000;
    } else if (batteryPercent < 40 && batteryPercent >= 30) {
      //above 30
      return 4000;
    } else if (batteryPercent < 30 && batteryPercent >= 20) {
      //above 20
      return 3000;
    } else if (batteryPercent < 20 && batteryPercent >= 10) {
      //above 10
      return 2000;
    } else {
      //below 10
      return 1000;
    }
  }

  static double getIntervals(double _maxChartValue) {
    if (_maxChartValue.toInt() == 0) {
      return 1;
    } else if (_maxChartValue.toInt() < 5)
      return _maxChartValue;
    else if (_maxChartValue.toInt() < 50)
      return _maxChartValue / 0.05;
    else if (_maxChartValue.toInt() < 500)
      return _maxChartValue / 0.2;
    else if (_maxChartValue.toInt() < 1500)
      return _maxChartValue / 0.5;
    else if (_maxChartValue.toInt() < 2500)
      return _maxChartValue / 1.3;
    else
      return _maxChartValue / 2.4;
  }

  static double getCurrentDate() {
    return double.parse(Constants.getCurrentHour()) - 1;
  }

  static double displayExtraGraphAxis(double value) {
    if (value < 0) {
      //negative
      if (value <= -3000)
        return -700;
      else if (value <= -2500 && value > -3000)
        return -500;
      else if (value <= -2000 && value > -2500)
        return -300;
      else
        return -100;
    } else {
      //positive
      if (value <= -1000)
        return -700;
      else if (value <= 1000)
        return 100;
      else if (value <= 1500)
        return 300;
      else if (value <= 2500)
        return 500;
      else
        return 700;
    }
  }
}
