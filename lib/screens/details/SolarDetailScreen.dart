import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:givenergy/global/constants/Constant.dart';
import 'package:givenergy/global/functions/GlobalFunctions.dart';
import 'package:http/http.dart' as http;

class SolarDetailScreen extends StatefulWidget {
  static final String view = "SOLAR_DETAIL_SCREEN";

  @override
  _SolarDetailScreenState createState() => _SolarDetailScreenState();
}

class _SolarDetailScreenState extends State<SolarDetailScreen> {
  // variables
  String _choice = Constants.filters[0];

  //Solar screen data
  String _solarGenerated = "---",
      _toHome = "---",
      _toBattery = "---",
      _toGrid = "---",
      percent = "0",
      percentValue = "0",
      _time = '';

  //timer for request every 4 minutes
  Timer timer;

  List<double> nowData = [];

  //for the list of times
  List<String> allTimes = [];

  @override
  void initState() {
    _time = Constants.getTime();
    _getSolarData();
    timer = Timer.periodic(Duration(minutes: 4), (Timer t) => _getSolarData());
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
          onRefresh: _getSolarData,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                Column(
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
                    dpTitle("SOLAR"),
                    verticalSpace(6.0),
                    dpSubTitle("Generating"),
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
                    dpMainImage("assets/db_solar_btn.png"),
                    verticalSpace(30.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              dmTextTitle("Solar Energy Generated"),
                              dsTextTitle("- To Home"),
                              dsTextTitle("- To Battery"),
                              dsTextTitle("- To Grid"),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              dmvTextTitle(_solarGenerated),
                              dsvTextTitle(_toHome),
                              dsvTextTitle(_toBattery),
                              dsvTextTitle(_toGrid),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
    _getSolarData();
    setState(() {
      _choice = choice;
    });
  }

  Future<void> _getSolarData() async {
    //send the request to non login request and get the result back. if status is false then send user to login screen after deleting shared preferences
    Constants.checkSession(Constants.nonBaseURL + Constants.getTime())
        .then((value) => {
              _processSolar(value),
            });
  }

  void _processSolar(bool isSessionActive) {
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
        "${Constants.nonBaseURL}${Constants.getTime()}&cookies=$sessionID&serialNumber=$serialNumber");
    final jsonResult = jsonDecode(response.body);
    if (jsonResult['total'] == 0) Constants.logoutUser(context);
    final data = jsonResult['rows'][0];
    _solarGenerated = data['pvGenerationToday'] + " kWh";
    percentValue = data['pvGenerationToday'];
    _toHome = (double.parse(data['pvGenerationToday']) -
                (double.parse(data['chargeEnergyToday']) -
                    double.parse(data['acChargeToday'])) -
                double.parse(data['exportToday']))
            .toStringAsFixed(2) +
        " kWh";
    _toBattery = (double.parse(data['chargeEnergyToday']) -
                double.parse(data['acChargeToday']))
            .toStringAsFixed(2) +
        " kWh";
    _toGrid = data['exportToday'] + " kWh";
    percent = ((double.parse(data['pvGenerationToday']) /
                double.parse(data['consumptionToday'])) *
            100)
        .toStringAsFixed(2);
    if (double.parse(percent).round() < 0) {
      percent = "0";
    }
    if (mounted) setState(() {});
  }

  void _getPowerNowValue() async {
    String sessionID = await Constants.getSessionID();
    String serialNumber = await Constants.getSerialNumber();
    var response = await http.post(
        "${Constants.graphURL}${Constants.getTime()}&attr=ppv&cookies=$sessionID&serialNumber=$serialNumber");
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
