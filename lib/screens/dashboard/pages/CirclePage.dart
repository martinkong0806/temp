import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:givenergy/global/colors/Color.dart';
import 'package:givenergy/global/constants/Constant.dart';
import 'package:givenergy/screens/details/DetailDashboard.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CirclePage extends StatefulWidget {
  static final String view = "CIRCLE_PAGE_SCREEN";

  @override
  _CirclePageState createState() => _CirclePageState();
}

class _CirclePageState extends State<CirclePage> with TickerProviderStateMixin {
  double _homeDemand = 0, _gridDemand = 0, _solarDemand = 0, _batteryDemand = 0;
  double _solarToHome = 0,
      _solarToBattery = 0,
      _solarToGrid = 0,
      _gridToBattery = 0,
      _gridToHome = 0,
      _batteryToHome =                  0;

  //timer for request every 4 minutes
  Timer timer;
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _getPowerDetails();
    timer =
        Timer.periodic(Duration(minutes: 2), (Timer t) => _getPowerDetails());

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
       RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000),()=>{
      _getPowerDetails()
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000),()=>{
      
    });
    
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    if(mounted)
    setState(() {
       
    });
    _refreshController.loadComplete();
  }

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
    double _energyFlowWidth = min(MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height * 10 / 14 * 1.5);
    double _energyFlowHeight = min(MediaQuery.of(context).size.height * 10 / 14,
        MediaQuery.of(context).size.width);
    double _infoSize = _energyFlowHeight > _energyFlowWidth
        ? _energyFlowWidth / 5
        : _energyFlowHeight / 5;
    return SmartRefresher(
      enablePullDown: true,
        enablePullUp: false,
        header: ClassicHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
          child: Container(
        child: Stack(
          children: [
            Container(
              width: _energyFlowWidth,
              height: _energyFlowHeight,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, snapshot) {
                  return Center(
                    child: CustomPaint(
                      painter: ButtonPaint(
                        value: _controller.value,
                        canvasWidth: _energyFlowWidth,
                        canvasHeight: _energyFlowHeight,
                        homeDemand: _homeDemand,
                        solarToHome: _solarToHome,
                        solarToBattery: _solarToBattery,
                        solarToGrid: _solarToGrid,
                        gridToBattery: _gridToBattery,
                        gridToHome: _gridToHome,
                        batteryToHome: _batteryToHome,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: _energyFlowWidth,
              height: _energyFlowHeight,
              child: Stack(children: [
                Positioned(
                    top: _energyFlowHeight / 2 - _infoSize / 2,
                    left: 30,
                    child: Transform.scale(
                      scale: 0.75,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailDashboard(position: 3))),
                        child: Container(
                          width: _infoSize,
                          height: _infoSize,
                          child: Column(
                            children: [
                              Flexible(flex: 2, child: Center(child: solarSvg)),
                              Flexible(
                                  flex: 1,
                                  child: Center(
                                      child: Text('$_solarDemand kW',
                                          softWrap: false,
                                          style: TextStyle(
                                            color: Colors.white,
                                          )))),
                            ],
                          ),
                        ),
                      ),
                    )),
                Positioned(
                    top: _energyFlowHeight / 2 - _infoSize / 2,
                    right: 30,
                    child: Transform.scale(
                      scale: 0.75,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailDashboard(position: 2))),
                        child: Container(
                          width: _infoSize,
                          height: _infoSize,
                          child: Column(
                            children: [
                              Flexible(flex: 2, child: Center(child: pylonSvg)),
                              Flexible(
                                  flex: 1,
                                  child: Center(
                                      child: Text('$_gridDemand kW',
                                          softWrap: false,
                                          style: TextStyle(
                                            color: Colors.white,
                                          )))),
                            ],
                          ),
                        ),
                      ),
                    )),
                Positioned(
                    bottom: 30,
                    right: _energyFlowWidth / 2 - _infoSize / 2,
                    child: Transform.scale(
                      scale: 0.75,
                      child: Container(
                        width: _infoSize,
                        height: _infoSize,
                        child: Column(
                          children: [
                            Flexible(flex: 2, child: Center(child: batterySvg)),
                            Flexible(
                                flex: 1,
                                child: Center(
                                    child: Text('$_batteryDemand kW',
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.white,
                                        )))),
                          ],
                        ),
                      ),
                    )),
                Positioned(
                    top: 30,
                    right: _energyFlowWidth / 2 - _infoSize / 2,
                    child: Transform.scale(
                      scale: 0.75,
                      child: Container(
                        width: _infoSize,
                        height: _infoSize,
                        child: Column(
                          children: [
                            Flexible(flex: 2, child: Center(child: houseSvg)),
                            Flexible(
                                flex: 1,
                                child: Center(
                                    child: Text('$_homeDemand kW',
                                        softWrap: false,
                                        style: TextStyle(
                                          color: Colors.white,
                                        )))),
                          ],
                        ),
                      ),
                    )),
              ]),
            ),
         ],
        ),
      ),
    );
  }

  void _getPowerDetails() async {
    String sessionID = await Constants.getSessionID();
    String serialNumber = await Constants.getSerialNumber();
    var response = await http.post(
        "${Constants.batteryURL}&cookies=$sessionID&serialNumber=$serialNumber");
    final jsonResult = jsonDecode(response.body);
    // print(jsonResult);
    if (jsonResult['success']) {
      _homeDemand = double.parse(jsonResult['loadPowerkW'].toString());
      _batteryDemand = double.parse(jsonResult['batPower'].toString());
      _gridDemand = double.parse(jsonResult['gridPowerkW'].toString());
      _solarDemand = (double.parse(jsonResult['pvPower']) / 1000);
      if (mounted) setState(() {});
    } else
      Constants.logoutUser(context);
    if (mounted) setState(() {});
    var flowResponse = await http.post(
        "${Constants.nonBaseURL}${Constants.getTime()}&cookies=$sessionID&serialNumber=$serialNumber");
    final flowJsonResult = jsonDecode(flowResponse.body);
    

    if (flowJsonResult['total'] == 0) Constants.logoutUser(context);
    final data = flowJsonResult['rows'][0];
    _solarToHome = (double.parse(data['pvGenerationToday']) -
        (double.parse(data['chargeEnergyToday']) -
            double.parse(data['acChargeToday'])) -
        double.parse(data['exportToday']));
    _solarToBattery = (double.parse(data['chargeEnergyToday']) -
        double.parse(data['acChargeToday']));
    _solarToGrid = double.parse(data['exportToday']);
    _gridToBattery = double.parse(data['acChargeToday']);
    _gridToHome = double.parse(data['importToday']);
    _batteryToHome = double.parse(data['dischargeEnergyToday']);

   
   
  }
}

class ButtonPaint extends CustomPainter {
  double canvasWidth;
  double canvasHeight;
  double homeDemand;
  double solarToHome;
  double solarToGrid;
  double solarToBattery;
  double gridToBattery;
  double gridToHome;
  double batteryToHome;

  ButtonPaint(
      {this.value,
      this.canvasWidth,
      this.canvasHeight,
      this.homeDemand,
      this.solarToHome,
      this.solarToGrid,
      this.solarToBattery,
      this.gridToBattery,
      this.gridToHome,
      this.batteryToHome});

  final double value;
  Paint _axisPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  Paint _offlinePaint = Paint()
    ..color = Colors.grey[800]
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) async {
    double ballRadius =
        canvasHeight > canvasWidth ? canvasWidth / 10 : canvasHeight / 10;
    bool isSolarToHome = solarToHome > 0;
    bool isSolarToBattery = solarToBattery > 0;
    bool isSolarToGrid = solarToGrid > 0;
    bool isGridToHome = gridToHome > 0;
    bool isGridToBattry = gridToBattery > 0;
    bool isBatteryToHome = batteryToHome > 0;

    //Battery to Home
    powerLines(canvas, 0, canvasHeight / 2 - ballRadius / 2 - 30, 0,
        -canvasHeight / 2 + ballRadius / 2 + 30, 0, 0, isBatteryToHome);
    //Solar to Grid
    powerLines(canvas, -canvasWidth / 2 + ballRadius / 2 + 30, 0,
        canvasWidth / 2 - ballRadius / 2 - 30, 0, 0, 0, isSolarToGrid);
    //Solar to Home
    powerLines(canvas, -canvasWidth / 2 + ballRadius / 2 + 30, 0, 0,
        -canvasHeight / 2 + ballRadius / 2 + 30, -15, -15, isSolarToHome);
    //Solar to Battery
    powerLines(canvas, -canvasWidth / 2 + ballRadius / 2 + 30, 0, 0,
        canvasHeight / 2 - ballRadius / 2 - 30, -15, 15, isSolarToBattery);
    //Grid to Home
    powerLines(canvas, canvasWidth / 2 - ballRadius / 2 - 30, 0, 0,
        -canvasHeight / 2 + ballRadius / 2 + 30, 15, -15, isGridToHome);
    //Grid to Battery
    powerLines(canvas, canvasWidth / 2 - ballRadius / 2 - 30, 0, 0,
        canvasHeight / 2 - ballRadius / 2 - 30, 15, 15, isGridToBattry);

    drawGlowingCircle(
        canvas,
        canvasWidth / 2 - ballRadius - 30,
        0,
        ballRadius,
        true,
        Paint()
          ..color = Colors.yellow
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            convertRadiusToSigma(25),
          ),
        Paint()
          ..color = Colors.yellow
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
    drawGlowingCircle(
        canvas,
        -canvasWidth / 2 + ballRadius + 30,
        0,
        ballRadius,
        true,
        Paint()
          ..color = Colors.blue
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            convertRadiusToSigma(25),
          ),
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
    drawGlowingCircle(
        canvas,
        0,
        -canvasHeight / 2 + ballRadius + 30,
        ballRadius,
        true,
        Paint()
          ..color = Colors.green
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            convertRadiusToSigma(25),
          ),
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
    drawGlowingCircle(
        canvas,
        0,
        canvasHeight / 2 - ballRadius - 30,
        ballRadius,
        true,
        Paint()
          ..color = Colors.white
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            convertRadiusToSigma(25),
          ),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
  }

  drawAxis(double value, Canvas canvas, double startX, double startY,
      double endX, double endY, double offsetX, double offsetY, Paint paint) {
    var firstAxis = getPath(startX, startY, endX, endY, offsetX, offsetY);
    canvas.drawPath(firstAxis, _axisPaint);
    UI.PathMetrics pathMetrics = firstAxis.computeMetrics();
    for (UI.PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * value,
      );
      try {
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length).position;

        canvas.drawCircle(
            offset,
            9.0,
            Paint()
              ..color = Colors.orange
              ..maskFilter =
                  MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(7)));
        canvas.drawCircle(offset, 4.0, paint);
      } catch (e) {}
    }
  }

  drawGlowingCircle(Canvas canvas, double offsetX, double offsetY,
      double ballRadius, bool condit, Paint paintGlow, Paint paintBoarder) {
    if (condit) {
      canvas.drawCircle(Offset(offsetX, offsetY), ballRadius * 1.5, paintGlow);
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

  powerLines(Canvas canvas, double startX, double startY, double endX,
      double endY, double offsetX, double offsetY, bool condit) {
    if (condit) {
      drawAxis(value, canvas, startX, startY, endX, endY, offsetX, offsetY,
          Paint()..color = Colors.orange);
    } else {
      canvas.drawPath(
          getPath(startX, startY, endX, endY, offsetX, offsetY), _offlinePaint);
    }
  }

  Path getPath(double startX, double startY, double endX, double endY,
      double offsetX, double offsetY) {
    if (startX == endX || startY == endY) {
      return Path()
        ..moveTo(startX, startY)
        ..lineTo(endX, endY);
    } else {
      return Path()
        ..moveTo(startX, startY + offsetY)
        ..conicTo(offsetX, offsetY, endX + offsetX, endY, 12);
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
