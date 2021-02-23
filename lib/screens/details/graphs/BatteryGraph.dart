import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:givenergy/global/colors/Color.dart';
import 'package:givenergy/global/constants/Constant.dart';
import 'package:givenergy/global/functions/GlobalFunctions.dart';
import 'package:http/http.dart' as http;

class BatteryGraph extends StatefulWidget {
  static final String view = "BATTERY_GRAPH";

  @override
  _BatteryGraphState createState() => _BatteryGraphState();
}

class _BatteryGraphState extends State<BatteryGraph> {
  //home screen data
  String percent = "0", _time = '', _timePeriod = "hour";
  double _maxChartValue = 1, _minChartValue = 0, _xTime = 24;
  bool _isNegative = false, _showBottomTitles = true;

  //timer for request every 4 minutes
  Timer timer;

  List<FlSpot> _chartData = [];
  List<double> nowData = [];

  //for the list of times
  List<String> allTimes = [];

  @override
  void initState() {
    horizontalOrientation();
    _time = Constants.getTime();
    _getBatteryData();
    timer =
        Timer.periodic(Duration(minutes: 4), (Timer t) => _getBatteryData());
    super.initState();
  }

  @override
  void dispose() {
    verticalOrientation();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.gBlackColor,
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: RefreshIndicator(
              onRefresh: _getBatteryData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: backButton(context),
                    ),
                    verticalSpace(10.0),
                    displayGraph(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
      _xTime = Constants.getCurrentDate();
      _getChartData();
    } else
      Constants.logoutUser(context);
  }

  void _getChartData() async {
    String sessionID = await Constants.getSessionID();
    String serialNumber = await Constants.getSerialNumber();
    var response = await http.post(
        "${Constants.graphURL}$_time}&attr=pac&cookies=$sessionID&serialNumber=$serialNumber");
    final result = jsonDecode(response.body);
    if (result['data'] == null) Constants.logoutUser(context);
    List<dynamic> _data = List<dynamic>.from(result['data']);

    // to store the hour / month / year value only once so per hour / month / year only 1 value comes
    List<double> _timeGot = [];

    _chartData.clear();
    _maxChartValue = double.parse(result['maxValueText']);
    _minChartValue = double.parse(result['minValueText']);
    if (_minChartValue < 0) {
      //negative graph
      _isNegative = true;
    }

    if (_timePeriod == "hour") {
      //for every 1 counter
      double clock = 1;
      for (final value in _data) {
        String time;
        if (value['hour'] == 0) {
          //if hour is zero
          if (value['minute'] < 10) {
            time = "00:0${value['minute'].toString()}";
          } else {
            time = "00:${value['minute'].toString()}";
          }
        } else if (value['hour'] > 12) {
          String hour = "";
          if (value['hour'] == 1) {
            hour = "13";
          } else if (value['hour'] == 2) {
            hour = "14";
          } else if (value['hour'] == 3) {
            hour = "15";
          } else if (value['hour'] == 4) {
            hour = "16";
          } else if (value['hour'] == 5) {
            hour = "17";
          } else if (value['hour'] == 6) {
            hour = "18";
          } else if (value['hour'] == 7) {
            hour = "19";
          } else if (value['hour'] == 8) {
            hour = "20";
          } else if (value['hour'] == 9) {
            hour = "21";
          } else if (value['hour'] == 10) {
            hour = "22";
          } else if (value['hour'] == 11) {
            hour = "23";
          } else {
            hour = "24";
          }
          if (value['minute'] < 10) {
            time = "$hour:0${value['minute'].toString()}";
          } else {
            time = "$hour:${value['minute'].toString()}";
          }
        } else {
          if (value['minute'] < 10) {
            time =
                "0${value['hour'].toString()}:0${value['minute'].toString()}";
          } else {
            time = "${value['hour'].toString()}:${value['minute'].toString()}";
          }
        }
        allTimes.add(time);
        _chartData
            .add(FlSpot(clock++, double.parse(value['value'].toString())));
      }
    } else {
      for (final value in _data) {
        if (!_timeGot.contains(double.parse(value[_timePeriod].toString()))) {
          _timeGot.add(double.parse(value[_timePeriod].toString()));
          _chartData.add(FlSpot(double.parse(value[_timePeriod].toString()),
              double.parse(value['value'].toString())));
        }
      }
    }
    if (mounted) setState(() {});
  }

  Widget displayGraph() {
    if (_chartData.length == 0)
      return CircularProgressIndicator();
    else
      return Row(
        children: [
          RotatedBox(
            quarterTurns: -1,
            child: Text(
              "Power",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 2.5),
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  bottom: _showBottomTitles ? 10 : 25,
                  left: 5,
                ),
                width: MediaQuery.of(context).size.width * 0.93,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    minY: _isNegative
                        ? _minChartValue +
                            Constants.displayExtraGraphAxis(_minChartValue)
                        : _minChartValue,
                    maxY: _maxChartValue +
                        Constants.displayExtraGraphAxis(_maxChartValue),
                    maxX: allTimes.length.toDouble() + 2,
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: _showBottomTitles,
                        getTextStyles: (value) => const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        getTitles: (value) {
                          int _value = value.round();
                          return allTimes[++_value];
                        },
                        interval: 25,
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (value) => const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        getTitles: (value) {
                          return (value.toInt()).toString() + "W";
                        },
                        interval: _maxChartValue == 0
                            ? 140
                            : Constants.getIntervals(_maxChartValue),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[700],
                          strokeWidth: 0.4,
                        );
                      },
                      drawVerticalLine: true,
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.grey[700],
                          strokeWidth: 0.4,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _chartData,
                        isCurved: false,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        colors: [
                          Colors.grey,
                          Color.gWhiteColor,
                        ],
                        belowBarData: BarAreaData(
                          show: true,
                          cutOffY: 0,
                          applyCutOffY: true,
                          colors: [
                            Colors.grey,
                            Color.gWhiteColor,
                          ].map((e) => e.withOpacity(0.52)).toList(),
                        ),
                        aboveBarData: BarAreaData(
                          show: true,
                          cutOffY: 0,
                          applyCutOffY: true,
                          colors: [
                            Colors.grey,
                            Color.gWhiteColor,
                          ].map((e) => e.withOpacity(0.52)).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Time (HH:MM)",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
  }
}
