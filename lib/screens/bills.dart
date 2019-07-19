import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pgworld/utils/utils.dart';

import './bill.dart';
import './billFilter.dart';
import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';

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

  List<ListItem> bills = new List();
  bool end = false;
  bool ongoing = false;

  double width = 0;

  String offset = defaultOffset;
  bool loading = true;

  ScrollController _controller;

  String previousDate = "";

  int total = 0;

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
    filter["limit"] = defaultLimit;
    filter["offset"] = offset;
    filter["orderby"] = "paid_date_time";
    filter["sortby"] = "desc";

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    fillData();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (!end && !ongoing) {
        setState(() {
          loading = true;
        });
        fillData();
      }
    }
  }

  void fillData() {
    ongoing = true;
    filter["offset"] = offset;
    Future<Bills> data = getBills(filter);
    data.then((response) {
      if (response.bills != null && response.bills.length > 0) {
        offset = (int.parse(response.pagination.offset) + response.bills.length)
            .toString();
        response.bills.forEach((bill) {
          if (bill is Bill) {
            if (previousDate.compareTo(bill.paidDateTime.split(" ")[0]) != 0) {
              previousDate = bill.paidDateTime.split(" ")[0];
              bills.add(HeadingItem(previousDate));
            }
          }
          if (bill.paid == "0") {
            total += int.parse(bill.amount);
          } else {
            total -= int.parse(bill.amount);
          }
          bills.add(bill);
        });
      } else {
        end = true;
      }
      if (response.meta != null && response.meta.messageType == "1") {
        oneButtonDialog(context, "", response.meta.message,
            !(response.meta.status == STATUS_403));
      }
      setState(() {
        ongoing = false;
        loading = false;
      });
    });
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
      data["limit"] = defaultLimit;
      data["offset"] = defaultOffset;
      data["orderby"] = "paid_date_time";
      data["sortby"] = "desc";
      offset = defaultOffset;
      total = 0;
      print(data);
      setState(() {
        filter = data;
        bills.clear();
        fillData();
      });
    }
  }

  addPage(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as String;

    if (data != null) {
      if (user != null) {
        filter["user_id"] = user.id;
      } else if (employee != null) {
        filter["employee_id"] = employee.id;
      }
      filter["status"] = "1";
      filter["hostel_id"] = hostelID;
      filter["limit"] = defaultLimit;
      filter["offset"] = offset;
      filter["orderby"] = "paid_date_time";
      filter["sortby"] = "desc";
      offset = defaultOffset;

      bills.clear();
      fillData();
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return new Scaffold(
      bottomNavigationBar: new Card(
        child: new Container(
          padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
          height: 50,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Text(
                (total > 0 ? "" : "- ") +
                    "₹" +
                    total.toString().replaceAll("-", ""),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: total > 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: new Text(
          user != null ? "Rents" : (employee != null ? "Salary" : "Bills"),
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              filterPage(context, new BillFilterActivity());
            },
            icon: new Icon(Icons.filter_list),
          ),
          new IconButton(
            onPressed: () {
              addPage(
                  context,
                  user != null
                      ? new BillActivity(null, user, null)
                      : (employee != null
                          ? new BillActivity(null, null, employee)
                          : new BillActivity(null, null, null)));
            },
            icon: new Icon(Icons.add),
          ),
        ],
      ),
      body: ModalProgressHUD(
        child: bills.length == 0
            ? new Center(
                child: new Text(loading ? "" : "No bills"),
              )
            : new ListView.builder(
                controller: _controller,
                itemCount: bills.length,
                itemBuilder: (context, i) {
                  final item = bills[i];
                  if (item is HeadingItem) {
                    return new Container(
                      decoration: i != 0
                          ? new BoxDecoration(
                              border: new Border(
                              top: BorderSide(
                                color: HexColor("#dedfe0"),
                              ),
                            ))
                          : null,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, i != 0 ? 10 : 0, 0, 0),
                      child: new Text(
                        headingDateFormat.format(DateTime.parse(item.heading)),
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    );
                  } else if (item is Bill) {
                    return new ListTile(
                      dense: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new BillActivity(bills[i], null, null)),
                        );
                      },
                      title: new Container(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                padding: EdgeInsets.all(7),
                                color: item.paid == "0"
                                    ? HexColor(COLORS.RED)
                                    : HexColor(COLORS.GREEN),
                                child: new Icon(
                                  item.userID != ""
                                      ? Icons.local_hotel
                                      : (item.employeeID != ""
                                          ? Icons.account_box
                                          : Icons.receipt),
                                  color: Colors.white,
                                )),
                            new Expanded(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Text(
                                        item.title,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      new Text(
                                        (item.paid == "0" ? "" : "- ") +
                                            "₹" +
                                            item.amount,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: item.paid == "0"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  item.description.length > 0
                                      ? new Container(
                                          width: width * 0.7,
                                          child: new Text(
                                            item.description,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w100,
                                                color: Colors.grey),
                                          ),
                                        )
                                      : new Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
        inAsyncCall: loading,
      ),
    );
  }
}
