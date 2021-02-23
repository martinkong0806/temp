import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:givenergy/global/constants/Constant.dart';
import 'package:givenergy/global/functions/GlobalFunctions.dart';
import 'package:http/http.dart' as http;

class HomeDetailScreen extends StatefulWidget {
  static final String view = "HOME_DETAIL_SCREEN";

  @override
  _HomeDetailScreenState createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  // variables
  String _choice = Constants.filters[0];

  //home screen data
  String _usedTodayKwh = "---",
      _fromSolar = "---",
      _fromBattery = "---",
      _fromGrid = "---",
      _time = '';

  //timer for request every 4 minutes
  Timer timer;

  List<double> nowData = [];

  //for the list of times
  List<String> allTimes = [];

  @override
  void initState() {
    _time = Constants.getTime();
    _getHomeData();
    timer = Timer.periodic(Duration(minutes: 4), (Timer t) => _getHomeData());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: -MediaQuery.of(context).size.height * 0.28,
          child: Image.asset(
            "assets/spread.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        RefreshIndicator(
          onRefresh: _getHomeData,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      backButton(context),
                      // PopupMenuButton(
                      //   icon: Icon(
                      //     Icons.timeline_rounded,
                      //     size: 30,
                      //     color: Color.gWhiteColor,
                      //   ),
                      //   onSelected: filterSelected,
                      //   itemBuilder: (BuildContext context) {
                      //     return Constants.filters.map((String choice) {
                      //       return PopupMenuItem<String>(
                      //         child: Text(choice),
                      //         value: choice,
                      //       );
                      //     }).toList();
                      //   },
                      // ),
                    ],
                  ),
                ),
                dpTitle("HOME"),
                verticalSpace(6.0),
                dpSubTitle("Usage"),
                verticalSpace(30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    pnTitle("Power Now"),
                    horizontalSpace(8.0),
                    pnValue(nowData),
                  ],
                ),
                verticalSpace(20.0),
                dpMainImage("assets/db_home_btn.png"),
                verticalSpace(30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dmTextTitle("Used Today"),
                          dsTextTitle("- From Solar"),
                          dsTextTitle("- From Battery"),
                          dsTextTitle("- From Grid"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          dmvTextTitle(_usedTodayKwh),
                          dsvTextTitle(_fromSolar),
                          dsvTextTitle(_fromBattery),
                          dsvTextTitle(_fromGrid),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void filterSelected(String choice) {
    switch (choice) {
      case Constants.today:
        _time = Constants.getTime();
        break;
      case Constants.monthly:
        _time = Constants.getMonth();
        break;
      case Constants.yearly:
        _time = Constants.getYear();
        break;
      default:
        _time = Constants.getTime();
        break;
    }
    _getHomeData();
    setState(() {
      _choice = choice;
    });
  }

  Future<void> _getHomeData() async {
    Constants.checkSession(Constants.nonBaseURL + Constants.getTime())
        .then((value) => {
              _processHome(value),
            });
  }

  void _processHome(bool isSessionActive) {
    if (isSessionActive) {
      _getDetails();
      _getPowerNowValue();
    } else
      Constants.logoutUser(context);
  }

  void _getDetails() async {
    String sessionID = await Constants.getSessionID();
    String serialNumber = await Constants.getSerialNumber();
    var response = await http.post(
        "${Constants.nonBaseURL}${Constants.getTime()}&cookies$sessionID&serialNumber=$serialNumber");
    final jsonResult = jsonDecode(response.body);
    if (jsonResult['total'] == 0) Constants.logoutUser(context);
    final data = jsonResult['rows'][0];
    _usedTodayKwh = data['consumptionToday'] + " kWh";
    _fromSolar = (double.parse(data['pvGenerationToday']) -
                (double.parse(data['chargeEnergyToday']) -
                    double.parse(data['acChargeToday'])) -
                double.parse(data['exportToday']))
            .toStringAsFixed(2) +
        " kWh";
    _fromBattery = data['dischargeEnergyToday'] + " kWh";
    _fromGrid = (double.parse(data['importToday']) -
                double.parse(data['acChargeToday']))
            .toStringAsFixed(2) +
        " Kwh";
    if (mounted) setState(() {});
  }

  void _getPowerNowValue() async {
    String sessionID = await Constants.getSessionID();
    String serialNumber = await Constants.getSerialNumber();
    var response = await http.post(
        "${Constants.graphURL}${Constants.getTime()}&attr=loadPower&cookies=$sessionID&serialNumber=$serialNumber");
    final result = jsonDecode(response.body);
    if (result['data'] == null) Constants.logoutUser(context);
    List<dynamic> _data = List<dynamic>.from(result['data']);
    nowData.clear();
    for (final value in _data) {
      nowData.add(value['value']);
    }
    if (mounted) setState(() {});
  }
}
