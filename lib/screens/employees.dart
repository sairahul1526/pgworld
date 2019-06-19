import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pgworld/screens/bill.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import './employee.dart';
import './bills.dart';
import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/utils.dart';

class EmployeesActivity extends StatefulWidget {
  @override
  EmployeesActivityState createState() {
    return new EmployeesActivityState();
  }
}

class EmployeesActivityState extends State<EmployeesActivity> {
  Map<String, String> filter = new Map();

  List<Employee> employees = new List();
  bool end = false;
  bool ongoing = false;

  double width = 0;

  @override
  void initState() {
    super.initState();
    filter["hostel_id"] = hostelID;
    filter["status"] = "1";

    fillData();
  }

  void fillData() {
    if (!end && !ongoing) {
      ongoing = true;
      Future<Employees> data = getEmployees(filter);
      data.then((response) {
        if (response.employees.length > 0) {
          setState(() {
            employees.addAll(response.employees);
          });
        } else {
          end = true;
        }
        ongoing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Employees"),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new EmployeeActivity(null)),
              );
            },
            icon: new Icon(Icons.add),
          ),
        ],
      ),
      body: new ListView.separated(
        itemCount: employees.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (itemContext, i) {
          return new ListTile(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new EmployeeActivity(employees[i])),
              );
            },
            title: new Container(
              child: new Slidable(
                actionPane: new SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: new Column(
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        employees[i].name,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    new Container(
                      margin: new EdgeInsets.all(13),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Flexible(
                            child: new Column(
                              children: <Widget>[
                                new RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: employees[i].phone,
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.blue,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            makePhone(employees[i].phone);
                                          }),
                                  ]),
                                ),
                                new RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: employees[i].email,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            sendMail(employees[i].email);
                                          }),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          new Container(
                              margin: EdgeInsets.only(left: 10),
                              width: width * 0.4,
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Flexible(
                                    child: new Column(
                                      children: <Widget>[
                                        new Text(
                                          employees[i].designation,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        new Text(
                                          "₹" + employees[i].salary,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w100,
                                              color: Colors.green),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                secondaryActions: <Widget>[
                  new IconSlideAction(
                    caption: 'Salary',
                    color: Colors.red,
                    icon: Icons.money_off,
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new BillsActivity(null, employees[i])),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
