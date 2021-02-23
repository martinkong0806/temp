import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:givenergy/global/colors/Color.dart';

class CombinedChartPageScreen extends StatefulWidget {
  static final String view = "COMBINED_CHART_PAGE_SCREEN";

  @override
  _CombinedChartPageScreenState createState() =>
      _CombinedChartPageScreenState();
}

class _CombinedChartPageScreenState extends State<CombinedChartPageScreen> {
  var first = [1.0, -1.0, 1.5, 24.0, 0.0, 45.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  var second = [10.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  var third = [0.0, 11.0, 11.5, 12.0, 0.0, 0.0, -0.5, -11.0, -0.5, 0.0, 0.0];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Sparkline(
                  sharpCorners: false,
                  data: first,
                  lineWidth: 6,
                  lineGradient: new LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.grey[600], Color.gWhiteColor],
                  ),
                ),
                Sparkline(
                  sharpCorners: false,
                  data: second,
                  lineWidth: 6,
                  lineGradient: new LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green, Color.gGreenColor],
                  ),
                ),
                Sparkline(
                  sharpCorners: false,
                  data: third,
                  lineWidth: 6,
                  lineGradient: new LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue, Color.gBlueColor],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
