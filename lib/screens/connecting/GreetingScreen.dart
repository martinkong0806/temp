import 'package:flutter/material.dart';
import 'package:givenergy/global/constants/Constant.dart';
import 'package:givenergy/screens/connecting/ConnectionScreen.dart';

class GreetingScreen extends StatefulWidget {
  static final String view = "GREETING_SCREEN";

  @override
  _GreetingScreenState createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> {
  @override
  void initState() {
    progressScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/glow.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Wrap(
                    children: [
                      Text(
                        "Giv",
                        style: Constants.gGIVStyle,
                      ),
                      Text(
                        "Energy",
                        style: Constants.gEnergyStyle,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "GOOD MORNING\nAMANDA",
                      style: Constants.gEnergyStyle,
                      textAlign: TextAlign.center,
                    ),
                    Image.asset(
                      "assets/application_icon.png",
                      height: 170,
                    ),
                  ],
                ),
                SizedBox(),
                SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void progressScreen() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(ConnectionScreen.view, (route) => false);
    });
  }
}
