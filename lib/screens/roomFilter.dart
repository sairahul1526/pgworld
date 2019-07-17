import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';

import '../utils/utils.dart';
import '../utils/config.dart';

class RoomFilterActivity extends StatefulWidget {
  RoomFilterActivity();
  @override
  State<StatefulWidget> createState() {
    return new RoomFilterActivityState();
  }
}

class RoomFilterActivityState extends State<RoomFilterActivity> {
  bool filled = false;

  TextEditingController roomno = new TextEditingController();
  TextEditingController rent = new TextEditingController();
  TextEditingController capacity = new TextEditingController();

  Map<String, bool> avaiableAmenities = new Map<String, bool>();

  bool loading = false;

  double rentLower = 0;
  double rentUpper = 20000;

  double capacityLower = 0;
  double capacityUpper = 5;

  RoomFilterActivityState();

  @override
  void initState() {
    super.initState();
    amenities.forEach((amenity) => avaiableAmenities[amenity] = false);
  }

  List<Widget> amenitiesWidget() {
    List<Widget> widgets = new List();
    avaiableAmenities.forEach((k, v) => widgets.add(new Row(
          children: <Widget>[
            new Checkbox(
              value: v,
              onChanged: (bool value) {
                setState(() {
                  avaiableAmenities[k] = value;
                });
              },
            ),
            new Text(getAmenityName(k))
          ],
        )));
    return widgets;
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
          "Room",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 4.0,
        actions: <Widget>[
          new MaterialButton(
            textColor: Colors.white,
            child: new Text(
              "FILTER",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Map<String, String> filter = new Map();
              if (roomno.text != "") {
                filter["roomno"] = roomno.text;
              }
              if (filled) {
                filter["vacant"] = "1";
              }
              List<String> savedAmenities = new List();
              avaiableAmenities.forEach((k, v) {
                if (v) {
                  savedAmenities.add(k);
                }
              });
              if (savedAmenities.length > 0) {
                filter["amenities"] = savedAmenities.join(",");
              }
              filter["rent"] = rentLower.round().toString() +
                  "," +
                  rentUpper.round().toString();
              filter["capacity"] = capacityLower.round().toString() +
                  "," +
                  capacityUpper.round().toString();
              Navigator.pop(context, filter);
            },
          ),
        ],
      ),
      body: new Container(
        margin: new EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1,
            25, MediaQuery.of(context).size.width * 0.1, 0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: new Text("Room No."),
                ),
                new Expanded(
                  child: new Container(
                    margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: new TextField(
                        controller: roomno,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Room No.'),
                        onSubmitted: (String value) {}),
                  ),
                ),
              ],
            ),
            new Container(
              margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: new Text("Rent"),
                  ),
                  new Flexible(
                    child: new Container(
                      margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: new RangeSlider(
                        min: 0,
                        max: 20000,
                        lowerValue: rentLower,
                        upperValue: rentUpper,
                        divisions: 40,
                        showValueIndicator: true,
                        valueIndicatorMaxDecimals: 0,
                        onChanged:
                            (double newLowerValue, double newUpperValue) {
                          setState(() {
                            rentLower = newLowerValue;
                            rentUpper = newUpperValue;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: new Text("Capacity"),
                  ),
                  new Flexible(
                    child: new Container(
                      margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: new RangeSlider(
                        min: 0,
                        max: 5,
                        lowerValue: capacityLower,
                        upperValue: capacityUpper,
                        showValueIndicator: true,
                        divisions: 5,
                        valueIndicatorMaxDecimals: 0,
                        onChanged:
                            (double newLowerValue, double newUpperValue) {
                          setState(() {
                            capacityLower = newLowerValue;
                            capacityUpper = newUpperValue;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: new Text("Available"),
                  ),
                  new Flexible(
                    child: new Container(
                      margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: new Checkbox(
                        value: filled,
                        onChanged: (bool value) {
                          setState(() {
                            filled = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              margin: new EdgeInsets.fromLTRB(0, 30, 0, 0),
            ),
            new Container(
              margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: new Text("Amenities"),
                  ),
                ],
              ),
            ),
            new Expanded(
              child: new GridView.count(
                  childAspectRatio: 3,
                  primary: false,
                  crossAxisCount: 2,
                  children: amenitiesWidget()),
            ),
          ],
        ),
      ),
    );
  }
}
