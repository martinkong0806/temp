import 'package:flutter/material.dart';
import 'package:givenergy/global/functions/GlobalFunctions.dart';
import 'package:givenergy/screens/authentication/login/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard/DashboardScreen.dart';

class SplashScreen extends StatefulWidget {
  static final String view = "SPLASH_SCREEN";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        progressSplash();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [centerGivEnergyLogo(350)],
        ),
      ),
    );
  }

  void progressSplash() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    
    if ((_shared.getString('isLoggedIn') == null) ||
        (_shared.getString('isLoggedIn').isEmpty)) {
      moveScreen(false);
    } else {
      moveScreen(true);
    }
  }

  void moveScreen(bool isLoggedIn) {
    if (!isLoggedIn) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginScreen.view, (route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(DashboardScreen.view, (route) => false);
    }
  }
}
