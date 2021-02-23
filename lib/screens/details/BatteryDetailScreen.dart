import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:givenergy/global/constants/Constant.dart';
import 'package:givenergy/global/functions/GlobalFunctions.dart';
import 'package:http/http.dart' as http;

class BatteryDetailScreen extends StatefulWidget {
  static final String view = "BATTERY_DETAIL_SCREEN";

  @override
  _BatteryDetailScreenState createState() => _BatteryDetailScreenState();
}

class _BatteryDetailScreenState extends State<BatteryDetailScreen> {
  // variables
  String _choice = Constants.filters[0];

  //home screen data
  String _energyIn = "---",
      _energyOut = "---",
      _fromSolar = "---",
      _fromGrid = "---",
      _batStatus = "---",
      percent = "0",
      _circlePercent = "0",
      _time = '';

  //timer for request every 4 minutes
  Timer timer;

  List<double> nowData = [];

  //for the list of times
  List<String> allTimes = [];

  @override
  void initState() {
    _time = Constants.getTime();
    _getBatteryData();
    timer =
        Timer.periodic(Duration(minutes: 4), (Timer t) => _getBatteryData());
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
          onRefresh: _getBatteryData,
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
                dpTitle("BATTERY"),
                verticalSpace(6.0),
                dpSubTitle(_batStatus),
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
                Stack(
                  children: [
                    dpMainImage("assets/db_battery_btn.png"),
                    Positioned(
                      bottom: 15,
                      right: 0,
                      left: 0,
                      child: Center(child: dbPercentText(percent)),
                    ),
                  ],
                ),
                verticalSpace(30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dmTextTitle("Energy In"),
                          dsTextTitle("- From Solar"),
                          dsTextTitle("- From Grid"),
                          dmTextTitle("Energy Out"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          dmvTextTitle(_energyIn),
                          dsvTextTitle(_fromSolar),
                          dsvTextTitle(_fromGrid),
                          dmvTextTitle(_energyOut),
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
        break;
    }
    _getBatteryData();
    setState(() {
      _choice = choice;
    });
  }

  Future<void> _getBatteryData() async {
    //send the request to non login request and get the result back. if status is false then send user to login screen after deleting shared preferences
    Constants.checkSession(Constants.nonBaseURL + Constants.getTime())
        .then((value) => {
              _processBattery(value),
            });
  }

  void _processBattery(bool isSessionActive) async {
    if (isSessionActive) {
      _getBatteryPercent();
      _getDetails();
      _getPowerNowValue();
    } else
      Constants.logoutUser(context);
  }

  void _getDetails() async {
    String sessionID = await Constants.getSessionID();
    String serialNumber = await Constants.getSerialNumber();
    var response = await http.post(
        "${Constants.nonBaseURL}${Constants.getTime()}&cookies=$sessionID&serialNumber=$serialNumber");
    final jsonResult = jsonDecode(response.body);
    if (jsonResult['total'] == 0) Constants.logoutUser(context);
    final data = jsonResult['rows'][0];
    _energyIn = data['chargeEnergyToday'] + " kWh";
    _energyOut = data['dischargeEnergyToday'] + " kWh";
    _fromSolar = (double.parse(data['chargeEnergyToday']) -
                double.parse(data['acChargeToday']))
            .toStringAsFixed(2) +
        " kWh";
    _fromGrid = data['acChargeToday'] + " kWh";
    _circlePercent = ((double.parse(data['dischargeEnergyToday']) /
                double.parse(data['consumptionToday'])) *
            100)
        .toStringAsFixed(2);
    if (double.parse(_circlePercent).round() < 0) {
      _circlePercent = "0";
    }
    if (mounted) setState(() {});
  }

  void _getBatteryPercent() async {
    String sessionID = await Constants.getSessionID();
    String serialNumber = await Constants.getSerialNumber();
    var response = await http.post(
        "${Constants.batteryURL}&cookies=$sessionID&serialNumber=$serialNumber");
    final jsonResult = jsonDecode(response.body);
    percent = jsonResult['soc'].toString();
    if (mounted) setState(() {});
  }

  void _getPowerNowValue() async {
    String sessionID = await Constants.getSessionID();
    String serialNumber = await Constants.getSerialNumber();
    var response = await http.post(
        "${Constants.graphURL}${Constants.getTime()}&attr=batPower&cookies=$sessionID&serialNumber=$serialNumber");
    final result = jsonDecode(response.body);
    if (result['data'] == null) Constants.logoutUser(context);
    List<dynamic> _data = List<dynamic>.from(result['data']);
    nowData.clear();
    for (final value in _data) {
      nowData.add(value['value']);
    }
    String lastValue = nowData.last.toString();
    lastValue.startsWith('-')
        ? _batStatus = "Charging"
        : _batStatus = "Discharging";
    if (mounted) setState(() {});
  }
}
