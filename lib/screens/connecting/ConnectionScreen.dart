import 'package:flutter/material.dart';
import 'package:givenergy/global/constants/Constant.dart';
import 'package:givenergy/screens/dashboard/DashboardScreen.dart';

class ConnectionScreen extends StatefulWidget {
  static final String view = "CONNECTION_SCREEN";

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
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
          body: GestureDetector(
            onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                DashboardScreen.view, (route) => false),
            child: SafeArea(
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
                      Image.asset(
                        "assets/connecting.png",
                        height: 250,
                      ),
                      Text(
                        "CONNECTING ...",
                        style: Constants.gGIVStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
