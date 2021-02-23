import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:givenergy/global/constants/Constant.dart';
import 'package:givenergy/global/functions/GlobalFunctions.dart';
import 'package:http/http.dart' as http;

class GridDetailScreen extends StatefulWidget {
  static final String view = "GRID_DETAIL_SCREEN";

  @override
  _GridDetailScreenState createState() => _GridDetailScreenState();
}

class _GridDetailScreenState extends State<GridDetailScreen> {
  // variables
  String _choice = Constants.filters[0];

  //grid screen data
  String _energyImported = "---",
      _energyExported = "---",
      _toHome = "---",
      _toBattery = "---",
      _gridStatus = "---",
      percent = "0",
      percentDisplay = "0",
      _time = '';

  //timer for request every 4 minutes
  Timer timer;

  List<double> nowData = [];

  //for the list of times
  List<String> allTimes = [];

  @override
  void initState() {
    _time = Constants.getTime();
    _getGridData();
    timer = Timer.periodic(Duration(minutes: 4), (Timer t) => _getGridData());
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
          onRefresh: _getGridData,
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
                dpTitle("GRID"),
                verticalSpace(6.0),
                dpSubTitle(_gridStatus),
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
                dpMainImage("assets/db_grid_btn.png"),
                verticalSpace(30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dmTextTitle("Energy Imported"),
                          dsTextTitle("- To Home"),
                          dsTextTitle("- To Battery"),
                          dmTextTitle("Energy Exported"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          dmvTextTitle(_energyImported),
                          dsvTextTitle(_toHome),
                          dsvTextTitle(_toBattery),
                          dmvTextTitle(_energyExported),
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
    _getGridData();
    setState(() {
      _choice = choice;
    });
  }

  Future<void> _getGridData() async {
    //send the request to non login request and get the result back. if status is false then send user to login screen after deleting shared preferences
    Constants.checkSession(Constants.nonBaseURL + Constants.getTime())
        .then((value) => {
              _processGrid(value),
            });
  }

  void _processGrid(bool isSessionActive) {
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
    _energyImported = data['importToday'] + " kWh";
    percentDisplay = data['importToday'];
    percent = ((double.parse(data['importToday']) /
                double.parse(data['consumptionToday'])) *
            100)
        .toString();
    _energyExported = data['exportToday'] + " kWh";
    _toHome = (double.parse(data['importToday']) -
                double.parse(data['acChargeToday']))
            .toStringAsFixed(2) +
        " kWh";
    _toBattery =
        double.parse(data['acChargeToday']).toStringAsFixed(2) + " kWh";
    if (double.parse(percent).round() < 0) {
      percent = "0";
    }
    if (mounted) setState(() {});
  }

  void _getPowerNowValue() async {
    String sessionID = await Constants.getSessionID();
    String serialNumber = await Constants.getSerialNumber();
    var response = await http.post(
        "${Constants.graphURL}${Constants.getTime()}&attr=pac&cookies=$sessionID&serialNumber=$serialNumber");
    final result = jsonDecode(response.body);
    if (result['data'] == null) Constants.logoutUser(context);
    List<dynamic> _data = List<dynamic>.from(result['data']);
    nowData.clear();
    for (final value in _data) {
      nowData.add(value['value']);
    }
    String lastValue = nowData.last.toString();
    lastValue.startsWith('-')
        ? _gridStatus = "Importing"
        : _gridStatus = "Exporting";
    if (mounted) setState(() {});
  }
}
