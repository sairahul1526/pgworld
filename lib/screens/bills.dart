import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import './bill.dart';
import './billFilter.dart';
import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/utils.dart';

class BillsActivity extends StatefulWidget {
  final Employee employee;
  final User user;

  BillsActivity(this.user, this.employee);
  @override
  BillsActivityState createState() {
    return new BillsActivityState(user, employee);
  }
}

class BillsActivityState extends State<BillsActivity> {
  User user;
  Employee employee;

  BillsActivityState(this.user, this.employee);

  Map<String, String> filter = new Map();

  List<Bill> bills = new List();
  bool end = false;
  bool ongoing = false;

  double width = 0;

  @override
  void initState() {
    super.initState();

    if (user != null) {
      filter["user_id"] = user.id;
    } else if (employee != null) {
      filter["employee_id"] = employee.id;
    }
    filter["status"] = "1";
    filter["hostel_id"] = hostelID;

    fillData();
  }

  void fillData() {
    if (!end && !ongoing) {
      ongoing = true;
      Future<Bills> data = getBills(filter);
      data.then((response) {
        if (response.bills.length > 0) {
          setState(() {
            bills.addAll(response.bills);
          });
        } else {
          end = true;
        }
        ongoing = false;
      });
    }
  }

  filterPage(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as Map<String, String>;

    if (data != null) {
      if (user != null) {
        data["user_id"] = user.id;
      } else if (employee != null) {
        data["employee_id"] = employee.id;
      }
      data["status"] = "1";
      data["hostel_id"] = hostelID;
      print(data);
      setState(() {
        filter = data;
        bills.clear();
        fillData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
              user != null ? "Rents" : (employee != null ? "Salary" : "Bills")),
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                filterPage(context, new BillFilterActivity());
              },
              icon: new Icon(Icons.filter_list),
            ),
            new IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => user != null
                          ? new BillActivity(null, user, null)
                          : (employee != null
                              ? new BillActivity(null, null, employee)
                              : new BillActivity(null, null, null))),
                );
              },
              icon: new Icon(Icons.add),
            ),
          ],
        ),
        body: new ListView.separated(
          itemCount: bills.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, i) {
            return new ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          new BillActivity(bills[i], null, null)),
                );
              },
              title: new Container(
                margin: new EdgeInsets.all(13),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Flexible(
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            bills[i].title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          bills[i].description.length > 0
                              ? new Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: new Text(
                                    bills[i].description,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                )
                              : new Text(""),
                        ],
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(left: 10),
                      width: width * 0.4,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text(
                            "₹" + bills[i].amount,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w100,
                                color: bills[i].paid == "0"
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          new Text(
                            bills[i].paidDateTime.split(" ")[0],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w100),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
