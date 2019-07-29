import 'package:flutter/material.dart';
import '../utils/api.dart';
import '../utils/models.dart';

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

class DashBoardState extends State<DashBoard> with WidgetsBindingObserver {
  FocusNode textSecondFocusNode = new FocusNode();

  Dashboard dashboard;

  String hostelId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    hostelId = hostelID;

    fillData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("Current state = $state");
  }

  void fillData() {
    checkInternet().then((internet) {
      if (internet == null || !internet) {
        oneButtonDialog(context, "No Internet connection", "", true);
      } else {
        Map<String, String> filter = new Map();
        filter["hostel_id"] = hostelID;
        Future<Dashboards> data = getDashboards(filter);
        data.then((response) {
          if (response.dashboards != null && response.dashboards.length > 0) {
            setState(() {
              dashboard = response.dashboards[0];
            });
          }
          if (response.meta != null && response.meta.messageType == "1") {
            oneButtonDialog(context, "", response.meta.message,
                !(response.meta.status == STATUS_403));
          }
        });
      }
    });
  }

  filterPage(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as String;
    if (data != null) {
      if (hostelId != hostelID) {
        hostelId = hostelID;
        fillData();
      }
    }
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
                filterPage(context, new SettingsActivity());
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
                                  color: HexColor("#A179E0"),
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
                                  color: HexColor("#DF7B8D"),
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
                                  color: HexColor("#67CCB7"),
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
                                  color: HexColor("#D8B868"),
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
                                  color: HexColor("#539ECE"),
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
                                color: HexColor("#C36BB4"),
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
                                color: HexColor("#78C697"),
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
