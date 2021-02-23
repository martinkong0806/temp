import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:givenergy/global/constants/Constant.dart';
import 'package:givenergy/global/functions/GlobalFunctions.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toggle_switch/toggle_switch.dart';

class GivGraph extends StatefulWidget {
  @override
  _GivGraphState createState() => _GivGraphState();
}

class _GivGraphState extends State<GivGraph> {
  List<Color> BlueColor = [
    const Color(0xff023e8a),
    const Color(0xff00b4d8),
  ];
  List<Color> GreenColor = [
    const Color(0xff229631),
    const Color(0xff21c063),
  ];

  List<Color> RedColor = [
    const Color(0xffd00000),
    const Color(0xffdc2f02),
  ];

  List<Color> YellowColor = [
    const Color(0xfffaa307),
    const Color(0xffffba08),
  ];

  List<Color> WhiteColor = [
    const Color(0xffffffff),
    const Color(0xffffffff),
  ];

  List<Color> NoColor = [
    const Color.fromRGBO(255, 255, 255, 0),
    const Color.fromRGBO(255, 255, 255, 0),
  ];

  final GlobalKey<_IconButtonRowState> _key = GlobalKey();

  bool showSol = true;
  bool showHome = true;
  bool showGrid = true;
  bool showBat = true;

  bool showAvg = false;
  List<bool> powOrEn = [true, false];
  List<bool> dateFormat = [true, false, false];
  bool showPow = true;

  String _time = "";
  Future<dynamic> totalData;

  Timer timer;
  @override
  void initState() {
    super.initState();
    _time = Constants.getTime();
    totalData = fetchAllData(_time, ['ppv', 'loadPower', 'pac', 'batPower']);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return SafeArea(
          child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.black,
          ),
          IconButtonRow(
            key: _key,
            showSol: showSol,
            showHome: showHome,
            showBat: showBat,
            showGrid: showGrid,
            changeShowingSol: changeShowingSol,
            changeShowingHome: changeShowingHome,
            changeShowingBat: changeShowingBat,
            changeShowingGrid: changeShowingGrid,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: ToggleButtons(
                      children: <Widget>[
                        Container(
                            width: 50,
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Day',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            width: 50,
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Week',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            width: 50,
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Month',
                              textAlign: TextAlign.center,
                            )),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0;
                              buttonIndex < dateFormat.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              dateFormat[buttonIndex] = true;
                            } else {
                              dateFormat[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      isSelected: dateFormat,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: ToggleButtons(
                      children: <Widget>[
                        Container(
                            width: 50,
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Power',
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            width: 50,
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Energy',
                              textAlign: TextAlign.center,
                            )),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0;
                              buttonIndex < powOrEn.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              powOrEn[buttonIndex] = true;
                              if (index == 0) {
                                showPow = true;
                              } else if (index == 1) {
                                showPow = false;
                              }
                            } else {
                              powOrEn[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      isSelected: powOrEn,
                    ),
                  ),
                ],
              ),
              Container(
                child: FutureBuilder<dynamic>(
                  future: totalData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<bool> visibleList = [
                        showSol,
                        showHome,
                        showGrid,
                        showBat
                      ];
                      List<double> minValList =
                          getMinValue(snapshot.data, visibleList);
                      List<double> maxValList =
                          getMaxValue(snapshot.data, visibleList);
                      List<FlSpot> emptyGraph = [FlSpot(-1, 0), FlSpot(25, 0)];
                      List<FlSpot> solPowData = showSol
                          ? getFlSpotList(snapshot.data[0].powerData)
                          : emptyGraph;
                      List<FlSpot> homePowData = showHome
                          ? getFlSpotList(snapshot.data[1].powerData)
                          : emptyGraph;
                      List<FlSpot> gridPowData = showGrid
                          ? getFlSpotList(snapshot.data[2].powerData)
                          : emptyGraph;
                      List<FlSpot> batPowData = showBat
                          ? getFlSpotList(snapshot.data[3].powerData)
                          : emptyGraph;
                      List dataList = [
                        solPowData,
                        homePowData,
                        gridPowData,
                        batPowData
                      ];
                      double graphWidth = 1000;

                      return Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                              // color: Color(0xff232d37)
                            ),
                            width: 500,
                            child: Container(
                              // color: Colors.white,
                              width: 1000,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 18.0, left: 12.0, top: 0, bottom: 0),
                                child: LineChart(
                                    chartMask(minValList, maxValList)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(79.0, 30, 28.0, 0),
                            width: 500,
                            child: SingleChildScrollView(
                              controller:
                                  ScrollController(initialScrollOffset: 100),
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                width: graphWidth,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 0.0, left: 0, top: 0, bottom: 0),
                                  child: LineChart(
                                    showPow
                                        ? powerDataGraph(
                                            dataList, minValList, maxValList)
                                        : avgData(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
              ),
              Container(
                  padding: EdgeInsetsDirectional.only(start: 50),
                  child: Text(
                    'Time',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ],
      ));
    } else {
      return SafeArea(
          child: Row(
        children: [
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: ToggleButtons(
                          children: <Widget>[
                            Container(
                                width: 50,
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  'Day',
                                  textAlign: TextAlign.center,
                                )),
                            Container(
                                width: 50,
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  'Week',
                                  textAlign: TextAlign.center,
                                )),
                            Container(
                                width: 50,
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  'Month',
                                  textAlign: TextAlign.center,
                                )),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          onPressed: (int index) {
                            setState(() {
                              for (int buttonIndex = 0;
                                  buttonIndex < dateFormat.length;
                                  buttonIndex++) {
                                if (buttonIndex == index) {
                                  dateFormat[buttonIndex] = true;
                                } else {
                                  dateFormat[buttonIndex] = false;
                                }
                              }
                            });
                          },
                          isSelected: dateFormat,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: ToggleButtons(
                          children: <Widget>[
                            Container(
                                width: 50,
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  'Power',
                                  textAlign: TextAlign.center,
                                )),
                            Container(
                                width: 50,
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  'Energy',
                                  textAlign: TextAlign.center,
                                )),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          onPressed: (int index) {
                            setState(() {
                              for (int buttonIndex = 0;
                                  buttonIndex < powOrEn.length;
                                  buttonIndex++) {
                                if (buttonIndex == index) {
                                  powOrEn[buttonIndex] = true;
                                  if (index == 0) {
                                    showPow = true;
                                  } else if (index == 1) {
                                    showPow = false;
                                  }
                                } else {
                                  powOrEn[buttonIndex] = false;
                                }
                              }
                            });
                          },
                          isSelected: powOrEn,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: FutureBuilder<dynamic>(
                      future: totalData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<bool> visibleList = [
                            showSol,
                            showHome,
                            showGrid,
                            showBat
                          ];
                          List<double> minValList =
                              getMinValue(snapshot.data, visibleList);
                          List<double> maxValList =
                              getMaxValue(snapshot.data, visibleList);
                          List<FlSpot> emptyGraph = [
                            FlSpot(-1, 0),
                            FlSpot(25, 0)
                          ];
                          List<FlSpot> solPowData = showSol
                              ? getFlSpotList(snapshot.data[0].powerData)
                              : emptyGraph;
                          List<FlSpot> homePowData = showHome
                              ? getFlSpotList(snapshot.data[1].powerData)
                              : emptyGraph;
                          List<FlSpot> gridPowData = showGrid
                              ? getFlSpotList(snapshot.data[2].powerData)
                              : emptyGraph;
                          List<FlSpot> batPowData = showBat
                              ? getFlSpotList(snapshot.data[3].powerData)
                              : emptyGraph;
                          List dataList = [
                            solPowData,
                            homePowData,
                            gridPowData,
                            batPowData
                          ];
                          double graphWidth = 1200;

                          return Stack(
                            children: <Widget>[
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(18),
                                  ),
                                  // color: Color(0xff232d37)
                                ),
                                width: 700,
                                child: Container(
                                  // color: Colors.white,
                                  width: 1000,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 18.0,
                                        left: 12.0,
                                        top: 0,
                                        bottom: 0),
                                    child: LineChart(
                                        chartMask(minValList, maxValList)),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(79.0, 30, 28.0, 0),
                                width: 700,
                                child: SingleChildScrollView(
                                  controller: ScrollController(
                                      initialScrollOffset: 100),
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    width: graphWidth,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 0.0,
                                          left: 0,
                                          top: 0,
                                          bottom: 0),
                                      child: LineChart(
                                        showPow
                                            ? powerDataGraph(dataList,
                                                minValList, maxValList)
                                            : avgData(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default, show a loading spinner.
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsetsDirectional.only(start: 50),
                      child: Text(
                        'Time',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
          Container(
            child: IconButtonRow(
              key: _key,
              showSol: showSol,
              showHome: showHome,
              showBat: showBat,
              showGrid: showGrid,
              changeShowingSol: changeShowingSol,
              changeShowingHome: changeShowingHome,
              changeShowingBat: changeShowingBat,
              changeShowingGrid: changeShowingGrid,
            ),
          ),
        ],
      ));
    }
  }

  changeShowingSol() {
    this.setState(() {
      this.showSol = !this.showSol;
    });
  }

  changeShowingHome() {
    this.setState(() {
      this.showHome = !this.showHome;
    });
  }

  changeShowingBat() {
    this.setState(() {
      this.showBat = !this.showBat;
    });
  }

  changeShowingGrid() {
    this.setState(() {
      this.showGrid = !this.showGrid;
    });
  }

  LineChartData chartMask(List<double> min, List<double> max) {
    double minY =
        (min.reduce((value, element) => value < element ? value : element) /
                    1000)
                .floorToDouble() *
            1000;
    double maxY =
        (max.reduce((value, element) => value > element ? value : element) /
                    1000)
                .ceilToDouble() *
            1000;

    return LineChartData(
      gridData: FlGridData(show: false),
      axisTitleData: FlAxisTitleData(
        show: true,
        leftTitle: AxisTitle(
            showTitle: true,
            titleText: 'Power/kW',
            textStyle: TextStyle(color: Colors.white, fontSize: 11)),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            return ' ';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            if (value % 1000 == 0) {
              return (value ~/ 1000).toString();
            } else {
              return "";
            }
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 10,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          show: false,
          spots: [
            FlSpot(0, 3),
            FlSpot(15, 4),
          ],
          isCurved: true,
          colors: BlueColor,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: BlueColor.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData powerDataGraph(List data, List<double> min, List<double> max) {
    // double minX = data.reduce((value, element) => data[value].length > data[element].length ? data[value].length: data[element].length)/12;
    double minY =
        (min.reduce((value, element) => value < element ? value : element) /
                    1000)
                .floorToDouble() *
            1000;
    double maxY =
        (max.reduce((value, element) => value > element ? value : element) /
                    1000)
                .ceilToDouble() *
            1000;

    return LineChartData(
      lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                List<LineTooltipItem> result = [];
                for (int j = 0; j < 4; j++) {
                  for (int i = 0; i < touchedBarSpots.length; i++) {
                    if (touchedBarSpots[i].barIndex == j) {
                      if (j == 0) {
                        result.add(LineTooltipItem(
                            '${touchedBarSpots[i].y}W Solar',
                            TextStyle(color: Colors.blue)));
                      } else if (j == 1) {
                        result.add(LineTooltipItem(
                            '${touchedBarSpots[i].y}W Home',
                            TextStyle(color: Colors.green)));
                      } else if (j == 2) {
                        result.add(LineTooltipItem(
                            '${touchedBarSpots[i].y}W Grid',
                            TextStyle(color: Colors.yellow)));
                      } else if (j == 3) {
                        result.add(LineTooltipItem(
                            '${touchedBarSpots[i].y}W Battery',
                            TextStyle(color: Colors.white)));
                      }
                    }
                    ;
                  }
                }

                return result;
              })),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          if (value % 500 == 0) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 2,
            );
          } else {
            return FlLine(
              color: const Color.fromRGBO(255, 255, 255, 0),
              strokeWidth: 1,
            );
          }
        },
        verticalInterval: 1,
        getDrawingVerticalLine: (value) {
          if (value % 2 == 0) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 2,
            );
          } else {
            return FlLine(
              color: Colors.black12,
              strokeWidth: 1,
            );
          }
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            return (value.toInt()).toString();
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 24,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: data[0],
          isCurved: true,
          colors: showSol ? BlueColor : NoColor,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: BlueColor.map((color) => color.withOpacity(0.3)).toList(),
            cutOffY: 0,
            applyCutOffY: true,
          ),
        ),
        LineChartBarData(
          spots: data[1],
          isCurved: true,
          colors: showHome ? GreenColor : NoColor,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: GreenColor.map((color) => color.withOpacity(0.3)).toList(),
            cutOffY: 0,
            applyCutOffY: true,
          ),
        ),
        LineChartBarData(
            spots: data[2],
            isCurved: true,
            colors: showGrid ? YellowColor : NoColor,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              colors:
                  YellowColor.map((color) => color.withOpacity(0.3)).toList(),
              cutOffY: 0,
              applyCutOffY: true,
            ),
            aboveBarData: BarAreaData(
              show: true,
              colors:
                  YellowColor.map((color) => color.withOpacity(0.3)).toList(),
              cutOffY: 0,
              applyCutOffY: true,
            )),
        LineChartBarData(
          spots: data[3],
          isCurved: true,
          colors: showBat ? WhiteColor : NoColor,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: WhiteColor.map((color) => color.withOpacity(0.3)).toList(),
            cutOffY: 0,
            applyCutOffY: true,
          ),
          aboveBarData: BarAreaData(
            show: true,
            colors: WhiteColor.map((color) => color.withOpacity(0.3)).toList(),
            cutOffY: 0,
            applyCutOffY: true,
          ),
        ),
      ],
    );
  }

  getMinValue(List<GraphData> data, List<bool> visibleList) {
    List<double> result = [];
    int j = 0;
    for (var i in data) {
      if (visibleList[j] == true) {
        result.add(i.minValue);
      } else {
        result.add(0);
      }
      j += 1;
    }
    return result;
  }

  getMaxValue(List<GraphData> data, List<bool> visibleList) {
    List<double> result = [];
    int j = 0;
    for (var i in data) {
      if (visibleList[j] == true) {
        result.add(i.maxValue);
      } else {
        result.add(0);
      }
      j += 1;
    }

    return result;
  }

  getFlSpotList(List<dynamic> data) {
    return data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble() / 12, e.value['value']);
    }).toList();
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          // colors: [
          //   ColorTween(begin: gradientColors[0], end: gradientColors[1])
          //       .lerp(0.2),
          //   ColorTween(begin: gradientColors[0], end: gradientColors[1])
          //       .lerp(0.2),
          // ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          // belowBarData: BarAreaData(show: true, colors: [
          //   ColorTween(begin: gradientColors[0], end: gradientColors[1])
          //       .lerp(0.2)
          //       .withOpacity(0.1),
          //   ColorTween(begin: gradientColors[0], end: gradientColors[1])
          //       .lerp(0.2)
          //       .withOpacity(0.1),
          // ]),
        ),
      ],
    );
  }
}

class GraphData {
  final double minValue;
  final double maxValue;
  final List<dynamic> powerData;

  GraphData({this.minValue, this.maxValue, this.powerData});

  factory GraphData.fromJson(Map<String, dynamic> json) {
    List<dynamic> extractedData = List<dynamic>.from(json['data']);

    return GraphData(
      minValue: double.parse(json['minValueText']),
      maxValue: double.parse(json['maxValueText']),
      powerData: extractedData,
    );
  }
}

class EnergyData {
  final double importToday;
  final double exportToday;

  EnergyData({this.importToday, this.exportToday});
  factory EnergyData.fromJson(Map<String, dynamic> json) {
    return EnergyData(
      importToday: double.parse(json['importToday']),
      exportToday: double.parse(json['exportToday']),
    );
  }
}

Future<EnergyData> fetchEnergyData(String _time) async {
  String sessionID = await Constants.getSessionID();
  String serialNumber = await Constants.getSerialNumber();
  final response = await http.post(
      "${Constants.nonBaseURL}$_time&cookies=$sessionID&serialNumber=$serialNumber");

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return EnergyData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

Future<GraphData> fetchGraphData(String _time, String attr) async {
  String sessionID = await Constants.getSessionID();
  String serialNumber = await Constants.getSerialNumber();

  final response = await http.post(
      "${Constants.graphURL}$_time}&attr=$attr&cookies=$sessionID&serialNumber=$serialNumber");
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return GraphData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

Future<dynamic> fetchAllData(String _time, List<String> attrs) async {
  List<GraphData> allData = [];
  for (String attr in attrs) {
    final data = await fetchGraphData(_time, attr);
    allData.add(data);
  }
  return allData;
}

class IconButtonPaint extends CustomPainter {
  double canvasWidth;
  double canvasHeight;
  var ringColor;
  bool showColor;

  IconButtonPaint(
      {this.canvasWidth, this.canvasHeight, this.ringColor, this.showColor});

  @override
  void paint(Canvas canvas, Size size) {
    double ballRadius = canvasHeight > canvasWidth ? canvasWidth : canvasHeight;

    drawGlowingCircle(
        canvas,
        0,
        0,
        ballRadius,
        showColor,
        Paint()
          ..color = ringColor
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            convertRadiusToSigma(20),
          ),
        Paint()
          ..color = ringColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
  }

  drawGlowingCircle(Canvas canvas, double offsetX, double offsetY,
      double ballRadius, bool condit, Paint paintGlow, Paint paintBoarder) {
    if (condit) {
      canvas.drawCircle(Offset(offsetX, offsetY), ballRadius * 1.2, paintGlow);
      canvas.drawCircle(
          Offset(offsetX, offsetY), ballRadius, Paint()..color = Colors.black);
      canvas.drawCircle(Offset(offsetX, offsetY), ballRadius, paintBoarder);
    } else {
      canvas.drawCircle(
          Offset(offsetX, offsetY), ballRadius, Paint()..color = Colors.black);
      canvas.drawCircle(
          Offset(offsetX, offsetY),
          ballRadius,
          Paint()
            ..color = Colors.grey
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4);
    }
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class IconButtonRow extends StatefulWidget {
  final Function changeShowingSol;
  final Function changeShowingHome;
  final Function changeShowingBat;
  final Function changeShowingGrid;
  bool showSol;
  bool showHome;
  bool showBat;
  bool showGrid;
  IconButtonRow({
    Key key,
    this.showSol,
    this.showHome,
    this.showBat,
    this.showGrid,
    this.changeShowingSol,
    this.changeShowingHome,
    this.changeShowingBat,
    this.changeShowingGrid,
  }) : super(key: key);

  @override
  _IconButtonRowState createState() => _IconButtonRowState();
}

class _IconButtonRowState extends State<IconButtonRow> {
  @override
  Widget build(BuildContext context) {
    final String solarName = 'assets/Solar.svg';
    final Widget solarSvg = SvgPicture.asset(solarName,
        color: Colors.white, semanticsLabel: 'Solar logo');
    final String pylonName = 'assets/Pylon.svg';
    final Widget pylonSvg = SvgPicture.asset(pylonName,
        color: Colors.white, semanticsLabel: 'Pylon logo');
    final String batteryName = 'assets/Battery.svg';
    final Widget batterySvg = SvgPicture.asset(batteryName,
        color: Colors.white, semanticsLabel: 'Battery logo');
    final String houseName = 'assets/House.svg';
    final Widget houseSvg = SvgPicture.asset(houseName,
        color: Colors.white, semanticsLabel: 'Battery logo');

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Container(
          height: 100,
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                        child: Center(
                      child: CustomPaint(
                        painter: IconButtonPaint(
                            canvasWidth: 30,
                            canvasHeight: 30,
                            ringColor: Colors.blue,
                            showColor: widget.showSol),
                      ),
                    )),
                  ),
                  Expanded(
                    child: Container(
                        child: Center(
                      child: CustomPaint(
                          painter: IconButtonPaint(
                              canvasWidth: 30,
                              canvasHeight: 30,
                              ringColor: Colors.green,
                              showColor: widget.showHome)),
                    )),
                  ),
                  Expanded(
                    child: Container(
                        child: Center(
                      child: CustomPaint(
                          painter: IconButtonPaint(
                              canvasWidth: 30,
                              canvasHeight: 30,
                              ringColor: Colors.white,
                              showColor: widget.showBat)),
                    )),
                  ),
                  Expanded(
                    child: Container(
                        child: Center(
                      child: CustomPaint(
                          painter: IconButtonPaint(
                              canvasWidth: 30,
                              canvasHeight: 30,
                              ringColor: Colors.yellow,
                              showColor: widget.showGrid)),
                    )),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 25, 20),
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.changeShowingSol();
                                  });
                                },
                                child: solarSvg))),
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(22, 24, 20, 30),
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.changeShowingHome();
                                  });
                                },
                                child: houseSvg))),
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 26),
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.changeShowingBat();
                                  });
                                },
                                child: batterySvg))),
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  widget.changeShowingGrid();
                                },
                                child: pylonSvg))),
                  )
                ],
              ),
            ],
          ));
    } else {
      return Container(
          height: 500,
          width: 100,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                        child: Center(
                      child: CustomPaint(
                        painter: IconButtonPaint(
                            canvasWidth: 30,
                            canvasHeight: 30,
                            ringColor: Colors.blue,
                            showColor: widget.showSol),
                      ),
                    )),
                  ),
                  Expanded(
                    child: Container(
                        child: Center(
                      child: CustomPaint(
                          painter: IconButtonPaint(
                              canvasWidth: 30,
                              canvasHeight: 30,
                              ringColor: Colors.green,
                              showColor: widget.showHome)),
                    )),
                  ),
                  Expanded(
                    child: Container(
                        child: Center(
                      child: CustomPaint(
                          painter: IconButtonPaint(
                              canvasWidth: 30,
                              canvasHeight: 30,
                              ringColor: Colors.white,
                              showColor: widget.showBat)),
                    )),
                  ),
                  Expanded(
                    child: Container(
                        child: Center(
                      child: CustomPaint(
                          painter: IconButtonPaint(
                              canvasWidth: 30,
                              canvasHeight: 30,
                              ringColor: Colors.yellow,
                              showColor: widget.showGrid)),
                    )),
                  )
                ],
              ),
              Column(
                children: [
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 25, 20),
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.changeShowingSol();
                                  });
                                },
                                child: solarSvg))),
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(22, 24, 20, 30),
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.changeShowingHome();
                                  });
                                },
                                child: houseSvg))),
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 26),
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.changeShowingBat();
                                  });
                                },
                                child: batterySvg))),
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  widget.changeShowingGrid();
                                },
                                child: pylonSvg))),
                  )
                ],
              ),
            ],
          ));
    }
  }
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.count(
          // Create a grid with 2 columns in portrait mode,
          // or 3 columns in landscape mode.
          crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
        );
      },
    );
  }
}
