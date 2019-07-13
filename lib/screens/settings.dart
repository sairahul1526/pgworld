import 'package:flutter/material.dart';
import 'package:pgworld/utils/api.dart';

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
      body: new Container(
        margin: new EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1,
            25, MediaQuery.of(context).size.width * 0.1, 0),
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
                                constraints: BoxConstraints(maxWidth: 200),
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
                                expiry = hostel.expiryDateTime;
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
            new FlatButton(
              child: new Text(
                "LOGOUT",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                logout();
              },
            )
          ],
        ),
      ),
    );
  }
}
