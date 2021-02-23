import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givenergy/global/colors/Color.dart';

Widget backButton(BuildContext context) {
  return IconButton(
    onPressed: () => Navigator.of(context).pop(),
    icon: Icon(
      Icons.arrow_back_ios_outlined,
      size: 30,
      color: Color.gWhiteColor,
    ),
  );
}

//dp == detailsPage
Widget dpTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      color: Color.gWhiteColor,
      fontSize: 25,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
  );
}

Widget dpSubTitle(String subTitle) {
  return Text(
    subTitle == "" ? "---" : subTitle,
    style: TextStyle(
      color: Color.gGreyColor,
      fontSize: 16,
      letterSpacing: 1.2,
    ),
  );
}

//pn == powerNow
Widget pnTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      color: Color.gWhiteColor,
      fontSize: 25,
    ),
  );
}

Widget pnValue(List<double> nowData) {
  return Text(
    nowData.isEmpty ? "---" : nowData.last.toString() + " W",
    style: TextStyle(
      color: Color.gGreyColor,
      fontSize: 24,
    ),
  );
}

//vertical and horizontal space using sized box
Widget verticalSpace(double height) {
  return SizedBox(height: height);
}

Widget horizontalSpace(double width) {
  return SizedBox(width: width);
}

//dp == detailsPage
Widget dpMainImage(String assetPath) {
  return Image.asset(
    assetPath,
    width: 150,
    height: 150,
  );
}

//dm == detailMain
Widget dmTextTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      color: Color.gWhiteColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
  );
}

//dmv == detailMainValue
Widget dmvTextTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      color: Color.gWhiteColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
  );
}

//ds == detailSub
Widget dsTextTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      color: Color.gGreyColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
  );
}

//dsv == detailSubValue
Widget dsvTextTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      color: Color.gGreyColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
  );
}

//dcs == detailsChartSub
Widget dcsText(String title) {
  return Text(
    title.toUpperCase(),
    style: TextStyle(
      fontSize: 18,
      color: Color.gGreyColor,
      letterSpacing: 1.2,
    ),
  );
}

//db == detailsBattery
Widget dbPercentText(String percent) {
  return Text(
    percent == "" ? "---" : percent + " %",
    style: TextStyle(
      color: Color.gWhiteColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
  );
}

//view graph button
Widget graphBtn(final borderColor) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
    decoration: BoxDecoration(
      color: Color.gBlackColor,
      border: Border.all(color: borderColor, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    child: Text(
      "VIEW GRAPH".toUpperCase(),
      style: TextStyle(color: Color.gGreyColor),
    ),
  );
}

//changing orientation of app to vertical
void verticalOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

//changing orientation of app to horizontal (default)
void horizontalOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

//givEnergy Logo Widget
Widget centerGivEnergyLogo(double imageWidth) {
  return Center(
    child: Image.asset(
      "assets/givenergy_logo.png",
      width: imageWidth,
    ),
  );
}

//givEnergy Dialog Title style
TextStyle appTS() {
  return TextStyle(
    color: Color.gGreyColor,
    fontSize: 20.0,
    letterSpacing: 1.2,
  );
}

//email styling
TextStyle emailTS() {
  return TextStyle(
    color: Color.gBlueColor,
    fontWeight: FontWeight.bold,
  );
}

//email styling
TextStyle positiveTBS() {
  return TextStyle(color: Color.gGreenColor);
}
