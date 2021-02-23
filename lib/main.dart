import 'package:flutter/material.dart';
import 'package:givenergy/screens/SplashScreen.dart';
import 'package:givenergy/screens/authentication/login/LoginScreen.dart';
import 'package:givenergy/screens/connecting/ConnectionScreen.dart';
import 'package:givenergy/screens/connecting/GreetingScreen.dart';
import 'package:givenergy/screens/dashboard/DashboardScreen.dart';
import 'package:givenergy/screens/dashboard/SettingsScreen.dart';
import 'package:givenergy/screens/details/DetailDashboard.dart';
import 'package:givenergy/screens/details/graphs/BatteryGraph.dart';
import 'package:givenergy/screens/details/graphs/GridGraph.dart';
import 'package:givenergy/screens/details/graphs/HomeGraph.dart';

import 'screens/details/graphs/SolarGraph.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GivEnergy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: SplashScreen.view,
      routes: {
        SplashScreen.view: (context) => SplashScreen(),
        LoginScreen.view: (context) => LoginScreen(),
        GreetingScreen.view: (context) => GreetingScreen(),
        ConnectionScreen.view: (context) => ConnectionScreen(),
        DashboardScreen.view: (context) => DashboardScreen(),
        SettingsScreen.view: (context) => SettingsScreen(),
        DetailDashboard.view: (context) => DetailDashboard(position: 0),
        HomeGraph.view: (context) => HomeGraph(),
        BatteryGraph.view: (context) => BatteryGraph(),
        GridGraph.view: (context) => GridGraph(),
        SolarGraph.view: (context) => SolarGraph(),
      },
    );
  }
}
