import 'package:flutter/material.dart';
import 'package:givenergy/global/colors/Color.dart';
import 'package:givenergy/screens/details/BatteryDetailScreen.dart';
import 'package:givenergy/screens/details/GridDetailScreen.dart';
import 'package:givenergy/screens/details/HomeDetailScreen.dart';
import 'package:givenergy/screens/details/SolarDetailScreen.dart';
import 'package:givenergy/screens/details/Graph.dart';
import 'package:givenergy/screens/dashboard/DashboardScreen.dart';

class DetailDashboard extends StatefulWidget {
  static final String view = "DETAIL_DASHBOARD";

  final int position;

  const DetailDashboard({Key key, @required this.position}) : super(key: key);

  @override
  _DetailDashboardState createState() => _DetailDashboardState();
}

class _DetailDashboardState extends State<DetailDashboard> {
  final pages = [
    // HomeDetailScreen(),
    // BatteryDetailScreen(),
    // GridDetailScreen(),
    // SolarDetailScreen(),
    GivGraph(),
    TestPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.gBlackColor,
      body: PageView.builder(
        // controller: PageController(
        //   initialPage: widget.position,
        // ),
        itemBuilder: (context, index) {
          return pages[index % pages.length];
        },
      ),
    );
  }
}

class BotNav extends StatefulWidget {
  static final String view = "BOT_NAV";

  final int position;

  const BotNav({Key key, @required this.position}) : super(key: key);
  @override
  _BotNavState createState() => _BotNavState();
}

class _BotNavState extends State<BotNav> {
  final pages = [
    
    GivGraph(),
   
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}