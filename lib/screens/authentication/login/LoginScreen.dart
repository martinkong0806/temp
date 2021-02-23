import 'package:flutter/material.dart';
import 'package:givenergy/global/colors/Color.dart';
import 'package:givenergy/global/constants/Constant.dart';
import 'package:givenergy/global/functions/GlobalFunctions.dart';
import 'package:givenergy/screens/dashboard/DashboardScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static final String view = "LOGIN_SCREEN";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _mailTEController = new TextEditingController();
  TextEditingController _uidTEController = new TextEditingController();

  bool _enableTextField = true, _isRemembered = false;

  ProgressDialog pr;

  @override
  void initState() {
    _processRememberPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Image.asset(
          "assets/glow.png",
          height: size.height,
          width: size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  verticalSpace(20.0),
                  centerGivEnergyLogo(300.0),
                  verticalSpace(30.0),
                  Image.asset(
                    "assets/profile.png",
                    height: 120,
                  ),
                  verticalSpace(100.0),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _mailTEController,
                            style: TextStyle(color: Color.gWhiteColor),
                            keyboardType: TextInputType.text,
                            enabled: _enableTextField,
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(
                                color: Color.gWhiteColor,
                              ),
                              contentPadding:
                                  EdgeInsets.only(top: 20.0, bottom: 20.0),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 15.0,
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Color.gWhiteColor,
                                ),
                              ),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color.gWhiteColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color.gWhiteColor,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color.gWhiteColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color.gWhiteColor,
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
                          verticalSpace(20.0),
                          TextFormField(
                            controller: _uidTEController,
                            style: TextStyle(
                              color: Color.gWhiteColor,
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            enabled: _enableTextField,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: Color.gWhiteColor,
                              ),
                              contentPadding:
                                  EdgeInsets.only(top: 20.0, bottom: 20.0),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 15.0,
                                ),
                                child: Icon(
                                  Icons.lock,
                                  size: 20,
                                  color: Color.gWhiteColor,
                                ),
                              ),
                              filled: true,
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color.gWhiteColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color.gWhiteColor,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color.gWhiteColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color.gWhiteColor,
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
                          GestureDetector(
                            onTap: () => _processRememberCB(!_isRemembered),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: _isRemembered,
                                  onChanged: (value) =>
                                      _processRememberCB(value),
                                  checkColor: Color.gWhiteColor,
                                  activeColor: Color.gBlueColor,
                                ),
                                Text(
                                  "Remember Me?",
                                  style: TextStyle(
                                    letterSpacing: 1.2,
                                    color: Color.gWhiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            child: GestureDetector(
                              onTap: () => _processLogin(context),
                              child: Card(
                                color: Color.gBlueColor,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 55),
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Color.gWhiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _processLogin(BuildContext context) async {
    if (!(_formKey.currentState.validate())) return;
    _formKey.currentState.save();

    setState(() {
      _enableTextField = !_enableTextField;
    });

    pr = ProgressDialog(context);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
      message: "Logging In",
      borderRadius: 10.0,
    );
    await pr.show();
    String username = _mailTEController.text.trim();
    String password = _uidTEController.text.trim();
    var loginURL =
        "${Constants.baseURL}?action=login&email=$username&password=$password";
    Constants.loginRequest(loginURL).then((value) => {
          _concludeLogin(value),
        });
  }

  void _concludeLogin(bool isLoggedIn) async {
    if (!(isLoggedIn)) {
      _mailTEController.clear();
      _uidTEController.clear();
      setState(() {
        _enableTextField = !_enableTextField;
      });
      pr.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            backgroundColor: Color.gBlackColor,
            title: new Text(
              "Authentication Failed",
              style: TextStyle(
                color: Color.gWhiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: new Text(
              "Username/Password is not correct, please try again. if you don't have the account please create from web portal",
              style: TextStyle(color: Color.gGreyColor),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      //check if user remembered then store the values
      if (_isRemembered) {
        Constants.rememberUser(_mailTEController.text.toString(),
            _uidTEController.text.toString());
      }
      pr.hide();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(DashboardScreen.view, (route) => false);
    }
  }

  void _processRememberCB(value) {
    setState(() {
      _isRemembered = value;
    });
  }

  void _processRememberPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool("isRemembered") != null &&
        sharedPreferences.getBool("isRemembered")) {
      //take username and password and display in fields
      setState(() {
        _isRemembered = true;
        _mailTEController.text = sharedPreferences.getString("username");
        _uidTEController.text = sharedPreferences.getString("uid");
      });
    }
  }
}
