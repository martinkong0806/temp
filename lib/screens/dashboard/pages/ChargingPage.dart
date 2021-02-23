import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givenergy/global/constants/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class ChargingPage extends StatefulWidget {
  static final String view = "CHARGING_PAGE_SCREEN";

  final bool arrived;

  const ChargingPage({Key key, this.arrived}) : super(key: key);

  @override
  _ChargingPageState createState() => _ChargingPageState();
}

class _ChargingPageState extends State<ChargingPage> {
  VideoPlayerController _videoPlayerController;

  String percentage = '0';

  @override
  void initState() {
    if (widget.arrived) {
      _videoPlayerController =
          VideoPlayerController.asset("assets/charging.mp4")
            ..initialize().then((value) => {
                  _videoPlayerController.setLooping(false),
                  _videoPlayerController.setVolume(0),
                });
      _videoPlayerController.addListener(() {
        print(_videoPlayerController.value.position.inMilliseconds);
        if (_videoPlayerController.value.position.inMilliseconds ==
            Constants.getVideoTime(50)) {
          _videoPlayerController.pause();
        }
      });
      _getBatteryPercent();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoPlayer(_videoPlayerController),
        Positioned(
          right: 0,
          left: 0,
          top: 0,
          bottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                percentage + " %",
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.arrived) {
      _videoPlayerController.dispose();
    }
    super.dispose();
  }

  void _getBatteryPercent() async {
    var response = await http.post(Constants.batteryURL);
    final jsonResult = jsonDecode(response.body);
    percentage = jsonResult['soc'].toString();
    print("Playing video");
    _videoPlayerController.play();
    if (mounted) setState(() {});
  }
}
