import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:givenergy/global/colors/Color.dart';
import 'package:givenergy/global/constants/Constant.dart';

import 'package:http/http.dart' as http;
import 'package:givenergy/screens/details/DetailDashboard.dart';

import 'pages/CirclePage.dart';
import 'package:givenergy/screens/dashboard/pages/CirclePage.dart';

class DashboardScreen extends StatefulWidget {
  static final String view = "DASHBOARD_SCREEN";

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //variables
  final today = new DateTime.now();
  int _selectedIndex = 0;
  static const List<Widget> _options = <Widget>[
    DetailDashboard(position: 2),
    DetailDashboard(position: 2),
    DetailDashboard(position: 2)
  ];
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _weatherTitle = "", _weatherInfo = "", _iconURL = "";

  @override
  void initState() {
    _displayInfoPrompt();
    _getWeatherDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                AppBar(
                  backgroundColor: Colors.black,
                ),
                Positioned(
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Constants.logoutUser(context),
                    child: Icon(
                      Icons.exit_to_app_outlined,
                      color: Color.gWhiteColor,
                      size: 30,
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  child: GestureDetector(
                    onTap: () => Constants.inDevelopment(context),
                    child: Icon(
                      Icons.info,
                      color: Color.gWhiteColor,
                      size: 30,
                    ),
                  ),
                ),
                Column(
                  children: [
                    // Expanded(
                    //   flex: 1,
                    //   child: Center(
                    //     child: Container(
                    //       child: Text(
                    //         DateFormat('EEEE d MMMM yyyy').format(today),
                    //         style: TextStyle(
                    //           color: Color.gWhiteColor,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        // // padding: EdgeInsets.all(10),
                        // child: Text(
                        //   DateFormat('h:mm a').format(today),
                        //   style: TextStyle(
                        //     color: Color.gWhiteColor,
                        //   ),
                        // ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        // margin: EdgeInsets.all(10),
                        // padding: EdgeInsets.all(10),
                        // child: Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Visibility(
                        //       child: Image.network(
                        //         _iconURL,
                        //       ),
                        //       visible: _iconURL == "" ? false : true,
                        //     ),
                        //     // Column(
                        //     //   children: [
                        //     //     Expanded(
                        //     //       child: Center(
                        //     //         child: Text(
                        //     //           _weatherTitle,
                        //     //           style: TextStyle(
                        //     //             color: Color.gWhiteColor,
                        //     //             letterSpacing: 1.2,
                        //     //             fontSize: 16,
                        //     //           ),
                        //     //         ),
                        //     //       ),
                        //     //     ),
                        //     //     Expanded(
                        //     //       child: Center(
                        //     //         child: Text(
                        //     //           _weatherInfo,
                        //     //           style: TextStyle(
                        //     //             color: Color.gWhiteColor,
                        //     //             letterSpacing: 1.2,
                        //     //             fontSize: 18,
                        //     //           ),
                        //     //         ),
                        //     //       ),
                        //     //     ),
                        //     //   ],
                        //     // ),
                        //   ],
                        // ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Center(child: Container(child: CirclePage())),
                    ),
                  ],
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            unselectedItemColor: Colors.white,
            onTap: (int index) => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailDashboard(position: index))),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart),
                label: 'Graphs',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _getWeatherDetails() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var response = await http.post(Constants.weatherURL +
        "lat=${position.latitude}&lon=${position.longitude}&units=metric&${Constants.weatherAppID}");
    final jsonResult = jsonDecode(response.body);
    _weatherTitle = jsonResult['weather'][0]['main'];
    _iconURL = "http://openweathermap.org/img/w/" +
        jsonResult['weather'][0]['icon'].toString() +
        ".png";
    final fh = (jsonResult['main']['temp'] * 9 / 5) + 32;
    _weatherInfo = jsonResult['main']['temp'].toStringAsFixed(2) +
        "°C/" +
        fh.toStringAsFixed(2) +
        "°F";
    if (mounted) setState(() {});
  }

  void _displayInfoPrompt() {
    Constants.isFirstDone().then((value) => {
          if (!value)
            {
              Constants.inDevelopment(context),
              Constants.firstTimeOpened(),
            }
        });
  }
}
