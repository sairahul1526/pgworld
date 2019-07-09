import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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

  String offset = defaultOffset;
  bool loading = true;

  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    filter["status"] = "1";
    filter["hostel_id"] = hostelID;
    filter["limit"] = defaultLimit;
    filter["offset"] = offset;

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
    Future<Employees> data = getEmployees(filter);
    data.then((response) {
      if (response.employees != null && response.employees.length > 0) {
        offset =
            (int.parse(response.pagination.offset) + response.employees.length)
                .toString();
        employees.addAll(response.employees);
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

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: new Text(
          "Employees",
          style: TextStyle(color: Colors.black),
        ),
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
      body: ModalProgressHUD(
        child: employees.length == 0
            ? new Center(
                child: new Text("No employees"),
              )
            : new ListView.separated(
                controller: _controller,
                itemCount: employees.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (itemContext, i) {
                  return new ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new BillsActivity(null, employees[i])),
                      );
                    },
                    title: new Container(
                      child: new Slidable(
                        actionPane: new SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    child: new Column(
                                      children: <Widget>[
                                        new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new Text(
                                              employees[i]
                                                      .name[0]
                                                      .toUpperCase() +
                                                  employees[i]
                                                      .name
                                                      .substring(1),
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            new Text(
                                              "₹" + employees[i].salary,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                        new Row(
                                          children: <Widget>[
                                            employees[i].phone != ""
                                                ? new ButtonTheme(
                                                    height: 25,
                                                    child: new FlatButton.icon(
                                                      shape: new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  15.0)),
                                                      color:
                                                          HexColor("#AED6F1"),
                                                      label: new Text(
                                                        employees[i].phone +
                                                            "12344",
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                      icon: new Icon(
                                                        Icons.phone,
                                                        size: 15,
                                                      ),
                                                      onPressed: () {
                                                        makePhone(
                                                            employees[i].phone);
                                                      },
                                                    ),
                                                  )
                                                : new Container(),
                                            employees[i].phone != ""
                                                ? new Container(
                                                    height: 50,
                                                    width: 10,
                                                  )
                                                : new Container(),
                                            new Flexible(
                                              // fit: FlexFit.loose,
                                              child: employees[i].email != ""
                                                  ? new ButtonTheme(
                                                      height: 25,
                                                      child:
                                                          new FlatButton.icon(
                                                        shape: new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    15.0)),
                                                        color:
                                                            HexColor("#AED6F1"),
                                                        label: new Flexible(
                                                          child: new Text(
                                                            "sameerbabu.sha.sameerbabu.sha." +
                                                                employees[i]
                                                                    .email,
                                                            softWrap: false,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                        icon: new Icon(
                                                          Icons.email,
                                                          size: 15,
                                                        ),
                                                        onPressed: () {
                                                          sendMail(employees[i]
                                                              .email);
                                                        },
                                                      ),
                                                    )
                                                  : new Container(),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        secondaryActions: <Widget>[
                          new IconSlideAction(
                            caption: 'EDIT',
                            icon: Icons.edit,
                            color: Colors.blue,
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        new EmployeeActivity(employees[i])),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        inAsyncCall: loading,
      ),
    );
  }
}
