import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import './dashboard.dart';
import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/utils.dart';
import './support.dart';

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
      if (onValue) {
        if (prefs.getString("username") != null &&
            prefs.getString("username").length > 0) {
          adminName = prefs.getString("username");
          adminEmailID = prefs.getString("email");
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
    checkInternet().then((internet) {
      if (internet == null || !internet) {
        oneButtonDialog(context, "No Internet connection", "", true);
        setState(() {
          loggedIn = false;
        });
      } else {
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
              prefs.setString('email', response.admins[0].email);
              prefs.setString('hostelIDs', response.admins[0].hostels);
              prefs.setString(
                  'hostelID', response.admins[0].hostels.split(",")[0]);
              prefs.setString('amenities', response.admins[0].amenities);
              adminName = response.admins[0].username;
              adminEmailID = response.admins[0].email;
              hostelID = response.admins[0].hostels.split(",")[0];
              amenities = response.admins[0].amenities.split(",");

              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => new DashBoard()));
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(
      //   iconTheme: IconThemeData(
      //     color: Colors.black,
      //   ),
      //   backgroundColor: Colors.white,
      //   title: new Text(
      //     "Log in",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   elevation: 4.0,
      // ),
      body: ModalProgressHUD(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.1,
              100,
              MediaQuery.of(context).size.width * 0.1,
              0),
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              new SizedBox(
                width: 100,
                height: 100,
                child: new Image.asset('assets/appicon.png'),
              ),
              new Center(
                child: new Container(
                  margin: EdgeInsets.only(top: 10),
                  child: new Text("Cloud PG"),
                ),
              ),
              new Container(
                height: 50,
              ),
              new TextField(
                controller: username,
                autocorrect: false,
                autofocus: true,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Username',
                  prefixIcon: Icon(Icons.account_circle),
                ),
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
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  onSubmitted: (s) {
                    login();
                  },
                ),
              ),
              new Container(
                margin: new EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: new MaterialButton(
                  height: 40,
                  child: new Text(
                    "Log in",
                  ),
                  onPressed: () {
                    login();
                  },
                ),
              ),
              new Container(
                child: new MaterialButton(
                  height: 40,
                  child: new Text(
                    "Don't have an account yet?\nSign Up.",
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new SupportActivity(false)));
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
        inAsyncCall: loggedIn,
      ),
    );
  }
}
