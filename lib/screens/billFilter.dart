import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

import '../utils/utils.dart';

class BillFilterActivity extends StatefulWidget {
  BillFilterActivity();
  @override
  State<StatefulWidget> createState() {
    return new BillFilterActivityState();
  }
}

class BillFilterActivityState extends State<BillFilterActivity> {
  int paid = -1;
  int type = -1;

  TextEditingController title = new TextEditingController();
  TextEditingController amount = new TextEditingController();

  double amountLower = 0;
  double amountUpper = 2000;

  BillFilterActivityState();

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
          "Bill",
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
              if (title.text != "") {
                filter["title"] = title.text;
              }
              if (billDates.length > 0) {
                filter["paid_date_time"] = dateFormat.format(billDates[0]) +
                    "," +
                    dateFormat.format(billDates[1]);
              }
              if (paid >= 0) {
                filter["paid"] = paid.toString();
              }
              if (type >= 0) {
                filter["type"] = type.toString();
              }
              filter["amount"] = amountLower.round().toString() +
                  "," +
                  (amountUpper.round() == 2000
                      ? "10000000"
                      : amountUpper.round().toString());
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
                  child: new Text("Item"),
                ),
                new Expanded(
                  child: new Container(
                    margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: new TextField(
                        controller: title,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Item'),
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
                    child: new Text("Amount"),
                  ),
                  new Flexible(
                    child: new Container(
                      margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: new RangeSlider(
                        min: 0,
                        max: 20000,
                        lowerValue: amountLower,
                        upperValue: amountUpper,
                        divisions: 40,
                        showValueIndicator: true,
                        valueIndicatorMaxDecimals: 0,
                        onChanged:
                            (double newLowerValue, double newUpperValue) {
                          setState(() {
                            amountLower = newLowerValue;
                            amountUpper = newUpperValue;
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
                    child: new Text("Bill Date"),
                  ),
                  new Flexible(
                    child: new Container(
                      margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: new FlatButton(
                          onPressed: () async {
                            final List<DateTime> picked =
                                await DateRagePicker.showDatePicker(
                                    context: context,
                                    initialFirstDate: new DateTime.now(),
                                    initialLastDate: (new DateTime.now())
                                        .add(new Duration(days: 7)),
                                    firstDate: new DateTime.now()
                                        .subtract(new Duration(days: 10 * 365)),
                                    lastDate: new DateTime.now()
                                        .add(new Duration(days: 10 * 365)));
                            if (picked != null && picked.length == 2) {
                              print(picked);
                              billDates = picked;
                              setState(() {
                                billDatesRange =
                                    dateFormat.format(billDates[0]) +
                                        " to " +
                                        dateFormat.format(billDates[1]);
                              });
                            }
                          },
                          child: new Text(billDatesRange)),
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
                    child: new Text("Show"),
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
                    groupValue: paid,
                    onChanged: (value) {
                      setState(() {
                        paid = value;
                      });
                    },
                  ),
                  new Text("All"),
                  new Radio(
                    value: 1,
                    groupValue: paid,
                    onChanged: (value) {
                      setState(() {
                        paid = value;
                      });
                    },
                  ),
                  new Text("Paid"),
                  new Radio(
                    value: 0,
                    groupValue: paid,
                    onChanged: (value) {
                      setState(() {
                        paid = value;
                      });
                    },
                  ),
                  new Text("Received"),
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
                    child: new Text("Bill Type"),
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
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        type = value;
                      });
                    },
                  ),
                  new Text("All"),
                  new Radio(
                    value: 1,
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        type = value;
                      });
                    },
                  ),
                  new Text("Rent"),
                  new Radio(
                    value: 0,
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        type = value;
                      });
                    },
                  ),
                  new Text("Salary"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
