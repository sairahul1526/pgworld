import 'package:flutter/material.dart';
// import 'package:easy_json/easy_json.dart';

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
  List<String> hostelIDs;
  Hostels hostels;

  @override
  void initState() {
    super.initState();
    // logout();
    print(prefs.getString('hostelIDs'));
    print(prefs.getString('hostelID'));
    print(prefs.getString('hostels'));
    hostelIDs = prefs.getString('hostelIDs').split(',');
    selectedHostelID = prefs.getString('hostelID');
    // hostels = ofJsonString(Hostels, prefs.getString('hostels'));
    print(hostels);
  }

  Widget bodyData(List<Hostel> hostels) => new DropdownButton(
        items: hostels.map((hostel) {
          return new DropdownMenuItem(
              child: new Text(hostel.name + " " + hostel.address),
              value: hostel.id);
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedHostelID = value;
            prefs.setString('hostelID', value);
            hostelID = value;
            hostels.forEach((hostel) {
              if (hostel.id == value) {
                amenities = hostel.amenities.split(",");
              }
            });
          });
        },
        value: selectedHostelID,
      );

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
          title: new Text(prefs.getString('username').toUpperCase()),
          elevation: 4.0,
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                logout();
              },
              icon: new Icon(
                Icons.adjust,
                color: Colors.red,
              ),
            )
          ]),
      body: new Container(
        margin: new EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1,
            25, MediaQuery.of(context).size.width * 0.1, 0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: new Text("HOSTEL"),
                ),
                // new Expanded(
                //   child: new DropdownButton(
                //     items: hostels.map((hostel) {
                //       return new DropdownMenuItem(
                //           child: new Text(hostel.name + " " + hostel.address),
                //           value: hostel.id);
                //     }).toList(),
                //     onChanged: (value) {
                //       setState(() {
                //         selectedHostelID = value;
                //         prefs.setString('hostelID', value);
                //         hostelID = value;
                //         hostels.forEach((hostel) {
                //           if (hostel.id == value) {
                //             amenities = hostel.amenities.split(",");
                //           }
                //         });
                //       });
                //     },
                //     value: selectedHostelID,
                //   ),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
