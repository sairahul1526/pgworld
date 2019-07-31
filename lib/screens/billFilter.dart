import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

import '../utils/utils.dart';
import '../utils/config.dart';

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

  TextEditingController expenseType = new TextEditingController();
  TextEditingController title = new TextEditingController();
  TextEditingController amount = new TextEditingController();

  double amountLower = 0;
  double amountUpper = 20000;

  BillFilterActivityState();

  List<DateTime> billDates = new List();

  String billDatesRange = "Pick date range";

  String selectedType = "";

  List<List<String>> billFilterTypes = [];

  @override
  void initState() {
    super.initState();
    billTypes.forEach((billType) {
      billFilterTypes.add(billType);
    });
    billFilterTypes.add(["Rents", "10"]);
    billFilterTypes.add(["Salary", "11"]);
  }

  Future<String> selectTitle(BuildContext context) async {
    String returned = "";

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Select Expense Type"),
          content: new Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: new ListView.builder(
              shrinkWrap: true,
              itemCount: billFilterTypes.length,
              itemBuilder: (context, i) {
                return new FlatButton(
                  child: new Text(billFilterTypes[i][0]),
                  onPressed: () {
                    returned = billFilterTypes[i][1];
                    expenseType.text = billFilterTypes[i][0];
                    selectedType = billFilterTypes[i][1];
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
    return returned;
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
              if (billDates.length > 0) {
                filter["paid_date_time"] = dateFormat.format(billDates[0]) +
                    "," +
                    dateFormat.format(billDates[1]);
              }
              if (paid >= 0) {
                filter["paid"] = paid.toString();
              }
              if (selectedType.length > 0) {
                filter["type"] = selectedType;
              }
              filter["amount"] = amountLower.round().toString() +
                  "," +
                  (amountUpper.round() == 20000
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
            new GestureDetector(
              onTap: () {
                selectTitle(context);
              },
              child: new Container(
                color: Colors.transparent,
                height: 50,
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        child: new TextField(
                          enabled: false,
                          controller: expenseType,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Icon(Icons.label),
                            border: OutlineInputBorder(),
                            labelText: 'Expense Type',
                          ),
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                              billDates = picked;
                              setState(() {
                                billDatesRange =
                                    headingDateFormat.format(billDates[0]) +
                                        " to " +
                                        headingDateFormat.format(billDates[1]);
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
          ],
        ),
      ),
    );
  }
}
