import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:pgworld/utils/api.dart';

import 'package:rate_my_app/rate_my_app.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utils/utils.dart';
import '../utils/config.dart';
import '../utils/models.dart';
import './login.dart';

class SettingsActivity extends StatefulWidget {
  SettingsActivity();
  @override
  State<StatefulWidget> createState() {
    return new SettingsActivityState();
  }
}

class SettingsActivityState extends State<SettingsActivity> {
  bool wifi = false;
  bool bathroom = false;
  bool tv = false;
  bool ac = false;

  String selectedHostelID;
  String hostelIDs;
  Hostels hostels;

  List<Widget> hostelWidgets = new List();

  String expiry;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    hostelIDs = prefs.getString('hostelIDs');
    selectedHostelID = prefs.getString('hostelID');
    print(hostelIDs);
    print(selectedHostelID);

    getHostelsData();
  }

  void getHostelsData() {
    Future<Hostels> request =
        getHostels(Map.from({'id': hostelIDs, 'status': '1'}));
    request.then((response) {
      setState(() {
        hostels = response;
        hostels.hostels.forEach((hostel) {
          if (hostel.id == selectedHostelID) {
            expiry =
                headingDateFormat.format(DateTime.parse(hostel.expiryDateTime));
          }
        });
        loading = false;
      });
    });
  }

  void logout() {
    prefs.clear();
    Navigator.pop(context);
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (BuildContext context) => new Login()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: new Text(
          prefs.getString('username').toUpperCase(),
          style: TextStyle(color: Colors.black),
        ),
        elevation: 4.0,
      ),
      body: ModalProgressHUD(
        child: loading
            ? new Container()
            : new Container(
                margin: new EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.1,
                    25,
                    MediaQuery.of(context).size.width * 0.1,
                    0),
                child: new Column(
                  children: <Widget>[
                    hostels != null
                        ? new Row(
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: new Text("HOSTEL"),
                              ),
                              new DropdownButton(
                                items: hostels.hostels.map((hostel) {
                                  return new DropdownMenuItem(
                                      child: new Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 200),
                                        child: new Text(
                                          hostel.name + " " + hostel.address,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                      value: hostel.id);
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedHostelID = value;
                                    prefs.setString('hostelID', value);
                                    hostelID = value;
                                    hostels.hostels.forEach((hostel) {
                                      if (hostel.id == value) {
                                        amenities = hostel.amenities.split(",");
                                        expiry = headingDateFormat.format(
                                            DateTime.parse(
                                                hostel.expiryDateTime));
                                      }
                                    });
                                  });
                                },
                                value: selectedHostelID,
                              )
                            ],
                          )
                        : new Text(""),
                    new Container(
                      margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: new Text("Subscription Expiry"),
                          ),
                          new Expanded(
                            child: new Container(
                              margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: new Text(expiry != null ? expiry : ""),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      height: 30,
                    ),
                    new Divider(),
                    new GestureDetector(
                      onTap: () {},
                      child: new Container(
                        height: 40,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Feedback & Support"),
                            new Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    new Divider(),
                    new Container(
                      color: Colors.red,
                      height: 40,
                      child: new GestureDetector(
                        onTap: () {
                          print("tapped");
                          RateMyApp rateMyApp = RateMyApp(
                            minDays: 0,
                            minLaunches: 0,
                            remindDays: 0,
                            remindLaunches: 0,
                          );

                          rateMyApp.showRateDialog(
                            context,
                            title: 'Rate this app',
                            message:
                                'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
                            rateButton: 'RATE',
                            noButton: 'NO THANKS',
                            laterButton: 'MAYBE LATER',
                          );
                        },
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Rate Us"),
                            new Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    new Divider(),
                    new FlatButton(
                      child: new Text(
                        "Log Out",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        logout();
                      },
                    ),
                    new Center(
                      child: new Text(
                        "\n\nMade with :) in Hyderabad, India\nCopyright © 2019 PGWorld\n\n" +
                            (Platform.isAndroid
                                ? APPVERSION.ANDROID
                                : APPVERSION.IOS),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
        inAsyncCall: loading,
      ),
    );
  }
}
