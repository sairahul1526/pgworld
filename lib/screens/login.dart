import 'package:flutter/material.dart';
// import 'package:easy_json/easy_json.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import './dashboard.dart';
import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/utils.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  FocusNode textSecondFocusNode = new FocusNode();

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool loggedIn = true;
  bool wrongCreds = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      headers["appversion"] = APPVERSION.ANDROID;
      if (kReleaseMode) {
        headers["apikey"] = APIKEY.ANDROID_LIVE;
      } else {
        headers["apikey"] = APIKEY.ANDROID_TEST;
      }
    } else {
      headers["appversion"] = APPVERSION.IOS;
      if (kReleaseMode) {
        headers["apikey"] = APIKEY.IOS_LIVE;
      } else {
        headers["apikey"] = APIKEY.IOS_TEST;
      }
    }
    Future<bool> prefInit = initSharedPreference();
    prefInit.then((onValue) {
      prefs.clear();
      if (onValue) {
        if (prefs.getString("username") != null &&
            prefs.getString("username").length > 0) {
          adminName = prefs.getString("username");
          hostelID = prefs.getString("hostelID");
          amenities = prefs.getString("amenities").split(",");
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => new DashBoard()));
        } else {
          setState(() {
            loggedIn = false;
          });
        }
      } else {
        setState(() {
          loggedIn = false;
        });
      }
    });
  }

  void login() {
    setState(() {
      loggedIn = true;
    });
    Future<Admins> employeeResponse = getAdmins(
        Map.from({'username': username.text, 'password': password.text}));
    employeeResponse.then((response) {
      if (response == null ||
          response.meta == null ||
          response.meta.status != "200") {
        setState(() {
          loggedIn = false;
        });
      } else {
        if (response.admins.length == 0) {
          setState(() {
            loggedIn = false;
            wrongCreds = true;
          });
        } else {
          prefs.setString('username', response.admins[0].username);
          prefs.setString('hostelIDs', response.admins[0].hostels);
          prefs.setString('hostelID', response.admins[0].hostels.split(",")[0]);
          adminName = response.admins[0].username;
          hostelID = response.admins[0].hostels.split(",")[0];

          print("response.admins[0].hostels " + response.admins[0].hostels);
          // get hostel details
          Future<Hostels> hostelResponse =
              getHostels(Map.from({'id': response.admins[0].hostels}));
          hostelResponse.then((hostelresponse) {
            // List<String> hostels = new List();
            // hostelresponse.hostels.forEach((hos) {
            //   print(json.encode(hos));
            //   hostels.add(json.encode(hos.toString()));
            // });
            // print(hostelresponse.hostels[0].amenities.split(","));
            // print(json.encode(hostelresponse.hostels));
            amenities = hostelresponse.hostels[0].amenities.split(",");
            // prefs.setString("hostels", toJsonString(hostelresponse));
          });

          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => new DashBoard()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
        elevation: 4.0,
      ),
      body: loggedIn
          ? new Center(child: showProgress("Logging in..."))
          : new Container(
              margin: new EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.1,
                  100,
                  MediaQuery.of(context).size.width * 0.1,
                  0),
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[
                  new TextField(
                    controller: username,
                    autocorrect: false,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: 'Username'),
                    onSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(textSecondFocusNode);
                    },
                  ),
                  new Container(
                    margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: new TextField(
                      controller: password,
                      focusNode: textSecondFocusNode,
                      obscureText: true,
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Password'),
                      onSubmitted: (s) {
                        login();
                      },
                    ),
                  ),
                  new Container(
                    margin: new EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: new MaterialButton(
                      color: Colors.lightBlue,
                      textColor: Colors.white,
                      height: 40,
                      child: new Text("          Login          "),
                      onPressed: () {
                        login();
                      },
                    ),
                  ),
                  new Container(
                      margin: new EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: new Center(
                        child: new Text(
                          wrongCreds ? "Incorrect Username/Password" : "",
                          style: new TextStyle(color: Colors.red),
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
