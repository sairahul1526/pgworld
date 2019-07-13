import 'package:flutter/material.dart';
import 'package:pgworld/utils/api.dart';
import 'package:pgworld/utils/models.dart';

import './rooms.dart';
import './logs.dart';
import './users.dart';
import './bills.dart';
import './notes.dart';
import './employees.dart';
import './settings.dart';
import './report.dart';
import '../utils/utils.dart';
import '../utils/config.dart';

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DashBoardState();
  }
}

class DashBoardState extends State<DashBoard> {
  FocusNode textSecondFocusNode = new FocusNode();

  Dashboard dashboard;

  @override
  void initState() {
    super.initState();
    fillData();
  }

  void fillData() {
    Map<String, String> filter = new Map();
    filter["hostel_id"] = hostelID;
    Future<Dashboards> data = getDashboards(filter);
    data.then((response) {
      if (response.dashboards != null && response.dashboards.length > 0) {
        setState(() {
          dashboard = response.dashboards[0];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: new Text(
            "DashBoard",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 4.0,
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new SettingsActivity(),
                    ));
              },
              icon: new Icon(Icons.settings),
              color: Colors.black,
            ),
          ],
        ),
        body: new ListView(
          children: <Widget>[
            new Container(
              child: new GridView.count(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(20.0),
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                crossAxisCount: 2,
                children: <Widget>[
                  new GestureDetector(
                    child: new Card(
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child: new Container(
                                padding: EdgeInsets.all(10),
                                decoration: new BoxDecoration(
                                  color: HexColor("#D7BDE2"),
                                  shape: BoxShape.circle,
                                ),
                                child: new Icon(
                                  Icons.supervisor_account,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            new Text(
                              (dashboard != null ? dashboard.user : ""),
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                            new Text("Users",
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new UsersActivity(null)),
                      );
                    },
                  ),
                  new GestureDetector(
                    child: new Card(
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child: new Container(
                                padding: EdgeInsets.all(10),
                                decoration: new BoxDecoration(
                                  color: HexColor("#F5CBA7"),
                                  shape: BoxShape.circle,
                                ),
                                child: new Icon(
                                  Icons.local_hotel,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            new Text(
                              (dashboard != null ? dashboard.room : ""),
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                            new Text("Rooms",
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new RoomsActivity()),
                      );
                    },
                  ),
                  new GestureDetector(
                    child: new Card(
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child: new Container(
                                padding: EdgeInsets.all(10),
                                decoration: new BoxDecoration(
                                  color: HexColor("#F9E79F"),
                                  shape: BoxShape.circle,
                                ),
                                child: new Icon(
                                  Icons.attach_money,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            new Text(
                              (dashboard != null ? dashboard.bill : ""),
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                            new Text("Bills",
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new BillsActivity(null, null)),
                      );
                    },
                  ),
                  new GestureDetector(
                    child: new Card(
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child: new Container(
                                padding: EdgeInsets.all(10),
                                decoration: new BoxDecoration(
                                  color: HexColor("#A2D9CE"),
                                  shape: BoxShape.circle,
                                ),
                                child: new Icon(
                                  Icons.format_list_numbered,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            new Text(
                              (dashboard != null ? dashboard.note : ""),
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                            new Text("Notes",
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new NotesActivity()),
                      );
                    },
                  ),
                  new GestureDetector(
                    child: new Card(
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child: new Container(
                                padding: EdgeInsets.all(10),
                                decoration: new BoxDecoration(
                                  color: HexColor("#AED6F1"),
                                  shape: BoxShape.circle,
                                ),
                                child: new Icon(
                                  Icons.account_box,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            new Text(
                              (dashboard != null ? dashboard.employee : ""),
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                            new Text("Employees",
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new EmployeesActivity()),
                      );
                    },
                  ),
                ],
              ),
            ),
            new Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 1,
              color: Colors.grey,
            ),
            new Container(
              child: new GridView.count(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(20.0),
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                crossAxisCount: 2,
                children: <Widget>[
                  new GestureDetector(
                    child: new Card(
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(10),
                              decoration: new BoxDecoration(
                                color: HexColor("#F5B7B1"),
                                shape: BoxShape.circle,
                              ),
                              child: new Icon(
                                Icons.track_changes,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            new Text("Activity",
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new LogsActivity()),
                      );
                    },
                  ),
                  new GestureDetector(
                    child: new Card(
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(10),
                              decoration: new BoxDecoration(
                                color: HexColor("#ABB2B9"),
                                shape: BoxShape.circle,
                              ),
                              child: new Icon(
                                Icons.show_chart,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            new Text("Reports",
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ReportActivity()),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
