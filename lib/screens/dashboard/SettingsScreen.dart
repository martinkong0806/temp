import 'package:flutter/material.dart';
import 'package:givenergy/global/colors/Color.dart';

class SettingsScreen extends StatefulWidget {
  static final String view = "SETTINGS_SCREEN";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //1st panel
  final TextEditingController _m1UPTOTEController = new TextEditingController();
  final TextEditingController _m1DOWNTOTEController =
      new TextEditingController();

  //2nd panel
  final TextEditingController _m2UPTOTEController = new TextEditingController();
  final TextEditingController _m2DOWNTOTEController =
      new TextEditingController();

  //3rd panel
  final TextEditingController _m3BD1StartTimeTEController =
      new TextEditingController();
  final TextEditingController _m3BD1EndTimeTEController =
      new TextEditingController();
  final TextEditingController _m3BD2StartTimeTEController =
      new TextEditingController();
  final TextEditingController _m3BD2EndTimeTEController =
      new TextEditingController();
  final TextEditingController _m3DischargePercentTEController =
      new TextEditingController();

  //4th panel
  final TextEditingController _m4BD1StartTimeTEController =
      new TextEditingController();
  final TextEditingController _m4BD1EndTimeTEController =
      new TextEditingController();
  final TextEditingController _m4BD2StartTimeTEController =
      new TextEditingController();
  final TextEditingController _m4BD2EndTimeTEController =
      new TextEditingController();
  final TextEditingController _m4DischargePercentTEController =
      new TextEditingController();

  //5th panel
  final TextEditingController _acCharge1StartTimeTEController =
      new TextEditingController();
  final TextEditingController _acCharge1EndTimeTEController =
      new TextEditingController();
  final TextEditingController _acCharge2StartTimeTEController =
      new TextEditingController();
  final TextEditingController _acCharge2EndTimeTEController =
      new TextEditingController();
  final TextEditingController _acCBUPTO1TEController =
      new TextEditingController();
  final TextEditingController _acCBUPTO2TEController =
      new TextEditingController();

  //visibility constants
  bool _m1Visibility = false,
      _m2Visibility = false,
      _m3Visibility = false,
      _m4Visibility = false,
      _m5Visibility = false,
      _m6Visibility = false;

  //switches handlers
  bool _m1Selected = false,
      _m2Selected = false,
      _m3Selected = false,
      _m4Selected = false,
      _m5Selected = false,
      _m6Selected = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: -MediaQuery.of(context).size.height * 0.36,
          child: Image.asset(
            "assets/spread.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.gBlackColor,
                      ),
                      child: Card(
                        color: Color.gBlackColor,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.arrow_back_ios_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              "SETTINGS",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.2,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Card(
                          color: Color.gBlackColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SwitchListTile(
                                  value: _m1Selected,
                                  onChanged: (value) {
                                    setState(() {
                                      _m1Selected = value;
                                    });
                                  },
                                  title: Text(
                                    "Dynamic Default",
                                    style: TextStyle(
                                      color: Color.gWhiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Maximise the use of Solar Generation to increase self-consumption",
                                    style: TextStyle(
                                      color: Color.gGreyColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  activeColor: Colors.green,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _m1Visibility = !_m1Visibility;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Advanced Options",
                                          style: TextStyle(
                                            color: Color.gBlueColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          _m1Visibility
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Color.gWhiteColor,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _m1Visibility,
                                  child: Card(
                                    color: Color.gBlackColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: <Widget>[
                                            TextFormField(
                                              controller: _m1UPTOTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType: TextInputType.text,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Charge my battery up to %",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller: _m1DOWNTOTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Discharge my battery down to %",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons.battery_alert_sharp,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            Align(
                                              child: GestureDetector(
                                                // onTap: () => updateProfile(),
                                                child: Card(
                                                  color: Colors.black,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 55),
                                                    child: Text(
                                                      "UPDATE",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                ),
                                              ),
                                              alignment: Alignment.bottomCenter,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Color.gBlackColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SwitchListTile(
                                  value: _m2Selected,
                                  onChanged: (value) {
                                    setState(() {
                                      _m2Selected = value;
                                    });
                                  },
                                  title: Text(
                                    "Store For Later Use",
                                    style: TextStyle(
                                      color: Color.gWhiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Store from excess solar during the day and discharge the battery between 4pm-7am",
                                    style: TextStyle(
                                      color: Color.gGreyColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  activeColor: Colors.green,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _m2Visibility = !_m2Visibility;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Advanced Options",
                                          style: TextStyle(
                                            color: Color.gBlueColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          _m2Visibility
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Color.gWhiteColor,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _m2Visibility,
                                  child: Card(
                                    color: Color.gBlackColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: <Widget>[
                                            TextFormField(
                                              controller: _m2UPTOTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Charge my battery up to %",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller: _m2DOWNTOTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Discharge my battery down to %",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons.battery_alert_sharp,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            Align(
                                              child: GestureDetector(
                                                // onTap: () => updateProfile(),
                                                child: Card(
                                                  color: Colors.black,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 55),
                                                    child: Text(
                                                      "UPDATE",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                ),
                                              ),
                                              alignment: Alignment.bottomCenter,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Color.gBlackColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SwitchListTile(
                                  value: _m3Selected,
                                  onChanged: (value) {
                                    setState(() {
                                      _m3Selected = value;
                                    });
                                  },
                                  title: Text(
                                    "Timed Battery Discharge To Meet Demand",
                                    style: TextStyle(
                                      color: Color.gWhiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Store from excess solar during the day and discharge the battery between user set times.",
                                    style: TextStyle(
                                      color: Color.gGreyColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  activeColor: Colors.green,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _m3Visibility = !_m3Visibility;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Advanced Options",
                                          style: TextStyle(
                                            color: Color.gBlueColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          _m3Visibility
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Color.gWhiteColor,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _m3Visibility,
                                  child: Card(
                                    color: Color.gBlackColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: <Widget>[
                                            TextFormField(
                                              controller:
                                                  _m3BD1StartTimeTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Battery Discharge 1 Start Time",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _m3BD1EndTimeTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Battery Discharge 1 End Time",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _m3BD2StartTimeTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Battery Discharge 2 Start Time",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _m3BD2EndTimeTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Battery Discharge 2 End Time",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _m3DischargePercentTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Discharge my better to %",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            Align(
                                              child: GestureDetector(
                                                // onTap: () => updateProfile(),
                                                child: Card(
                                                  color: Colors.black,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 55),
                                                    child: Text(
                                                      "UPDATE",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                ),
                                              ),
                                              alignment: Alignment.bottomCenter,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Color.gBlackColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SwitchListTile(
                                  value: _m4Selected,
                                  onChanged: (value) {
                                    setState(() {
                                      _m4Selected = value;
                                    });
                                  },
                                  title: Text(
                                    "Timed Battery Discharge At Full Power (Export)",
                                    style: TextStyle(
                                      color: Color.gWhiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Store from excess solar during the day and discharge battery at full power between user set times.",
                                    style: TextStyle(
                                      color: Color.gGreyColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  activeColor: Colors.green,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _m4Visibility = !_m4Visibility;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Advanced Options",
                                          style: TextStyle(
                                            color: Color.gBlueColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          _m4Visibility
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Color.gWhiteColor,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _m4Visibility,
                                  child: Card(
                                    color: Color.gBlackColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: <Widget>[
                                            TextFormField(
                                              controller:
                                                  _m4BD1StartTimeTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Battery Discharge 1 Start Time",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _m4BD1EndTimeTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Battery Discharge 1 End Time",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _m4BD2StartTimeTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Battery Discharge 2 Start Time",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _m4BD2EndTimeTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Battery Discharge 2 End Time",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _m4DischargePercentTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Discharge my better to %",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            Align(
                                              child: GestureDetector(
                                                // onTap: () => updateProfile(),
                                                child: Card(
                                                  color: Colors.black,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 55),
                                                    child: Text(
                                                      "UPDATE",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                ),
                                              ),
                                              alignment: Alignment.bottomCenter,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Color.gBlackColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SwitchListTile(
                                  value: _m5Selected,
                                  onChanged: (value) {
                                    setState(() {
                                      _m5Selected = value;
                                    });
                                  },
                                  title: Text(
                                    "Battery Smart Charge",
                                    style: TextStyle(
                                      color: Color.gWhiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Charge the battery at full power between user set times. Utilise off peak energy or solar during the day.",
                                    style: TextStyle(
                                      color: Color.gGreyColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  activeColor: Colors.green,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _m5Visibility = !_m5Visibility;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Advanced Options",
                                          style: TextStyle(
                                            color: Color.gBlueColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          _m5Visibility
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Color.gWhiteColor,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _m5Visibility,
                                  child: Card(
                                    color: Color.gBlackColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: <Widget>[
                                            TextFormField(
                                              controller:
                                                  _acCharge1StartTimeTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "AC Charge 1 Start Time",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _acCharge1EndTimeTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "AC Charge 1 End Time",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _acCharge2StartTimeTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "AC Charge 2 Start Time",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _acCharge2EndTimeTEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "AC Charge 2 End Time",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _acCBUPTO1TEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Charge  Battery 1 Up to %",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller:
                                                  _acCBUPTO2TEController,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              // enabled: _enableTextField,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Charge  Battery 2 Up to %",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                contentPadding: EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 15.0,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white
                                                    .withOpacity(0.1),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              validator: (String value) {
                                                if (value.isNotEmpty)
                                                  return null;
                                                else
                                                  return "Please fill this field";
                                              },
                                              onSaved: (String value) {
                                                // _username = value;
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            Align(
                                              child: GestureDetector(
                                                // onTap: () => updateProfile(),
                                                child: Card(
                                                  color: Colors.black,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 55),
                                                    child: Text(
                                                      "UPDATE",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  elevation: 10,
                                                ),
                                              ),
                                              alignment: Alignment.bottomCenter,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Color.gBlackColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SwitchListTile(
                              value: _m6Selected,
                              onChanged: (value) {
                                setState(() {
                                  _m6Selected = value;
                                });
                              },
                              title: Text(
                                "Octopus Agile",
                                style: TextStyle(
                                  color: Color.gWhiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Automatically finds the cheapest energy rates to charge the battery and discharges the battery when prices are at their highest.",
                                style: TextStyle(
                                  color: Color.gGreyColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              activeColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
