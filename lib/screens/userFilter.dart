import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';

import '../utils/utils.dart';

class UserFilterActivity extends StatefulWidget {
  UserFilterActivity();
  @override
  State<StatefulWidget> createState() {
    return new UserFilterActivityState();
  }
}

class UserFilterActivityState extends State<UserFilterActivity> {
  int food = -1;

  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController email = new TextEditingController();

  double rentLower = 0;
  double rentUpper = 20000;

  UserFilterActivityState();

  List<DateTime> billDates = new List();

  String billDatesRange = "Pick date range";

  @override
  void initState() {
    super.initState();
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
          "User",
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
              if (name.text != "") {
                filter["name"] = name.text;
              }
              if (phone.text != "") {
                filter["phone"] = phone.text;
              }
              if (email.text != "") {
                filter["email"] = email.text;
              }
              if (billDates.length > 0) {
                filter["paid_date_time"] = dateFormat.format(billDates[0]) +
                    "," +
                    dateFormat.format(billDates[1]);
              }
              if (food >= 0) {
                filter["food"] = food.toString();
              }
              filter["rent"] = rentLower.round().toString() +
                  "," +
                  (rentUpper.round() == 20000
                      ? "10000000"
                      : rentUpper.round().toString());
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
                  child: new Text("Name"),
                ),
                new Expanded(
                  child: new Container(
                    margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: new TextField(
                        controller: name,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Name'),
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
                    child: new Text("Phone"),
                  ),
                  new Expanded(
                    child: new Container(
                      margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: new TextField(
                          controller: phone,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Phone'),
                          onSubmitted: (String value) {}),
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
                    child: new Text("Email"),
                  ),
                  new Expanded(
                    child: new Container(
                      margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: new TextField(
                          controller: email,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Email'),
                          onSubmitted: (String value) {}),
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
                  new Container(
                    child: new Text(
                      "+",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text(rentLower.round().toString() +
                      " - " +
                      (rentUpper.round() == 20000
                          ? rentUpper.round().toString() + "+"
                          : rentUpper.round().toString())),
                ],
              ),
            ),
            // new Container(
            //   margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
            //   child: new Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: <Widget>[
            //       new Container(
            //         width: MediaQuery.of(context).size.width * 0.2,
            //         child: new Text("Bill Date"),
            //       ),
            //       new Flexible(
            //         child: new Container(
            //           margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
            //           child: new FlatButton(
            //               onPressed: () async {
            //                 final List<DateTime> picked =
            //                     await DateRagePicker.showDatePicker(
            //                         context: context,
            //                         initialFirstDate: new DateTime.now(),
            //                         initialLastDate: (new DateTime.now())
            //                             .add(new Duration(days: 7)),
            //                         firstDate: new DateTime.now()
            //                             .subtract(new Duration(days: 10 * 365)),
            //                         lastDate: new DateTime.now()
            //                             .add(new Duration(days: 10 * 365)));
            //                 if (picked != null && picked.length == 2) {
            //                   print(picked);
            //                   billDates = picked;
            //                   setState(() {
            //                     billDatesRange =
            //                         dateFormat.format(billDates[0]) +
            //                             " to " +
            //                             dateFormat.format(billDates[1]);
            //                   });
            //                 }
            //               },
            //               child: new Text(billDatesRange)),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            new Container(
              margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: new Text("Food"),
                  ),
                ],
              ),
            ),
            new Container(
              margin: new EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Radio(
                    value: -1,
                    groupValue: food,
                    onChanged: (value) {
                      setState(() {
                        food = value;
                      });
                    },
                  ),
                  new GestureDetector(
                    onTap: () {
                      setState(() {
                        food = -1;
                      });
                    },
                    child: new Text("All"),
                  ),
                  new Radio(
                    value: 1,
                    groupValue: food,
                    onChanged: (value) {
                      setState(() {
                        food = value;
                      });
                    },
                  ),
                  new GestureDetector(
                    onTap: () {
                      setState(() {
                        food = 1;
                      });
                    },
                    child: new Text("Veg"),
                  ),
                  new Radio(
                    value: 0,
                    groupValue: food,
                    onChanged: (value) {
                      setState(() {
                        food = value;
                      });
                    },
                  ),
                  new GestureDetector(
                    onTap: () {
                      setState(() {
                        food = 0;
                      });
                    },
                    child: new Text("Non Veg"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
