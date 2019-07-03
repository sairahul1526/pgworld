import 'package:flutter/material.dart';
import 'package:pgworld/screens/report.dart';

import './rooms.dart';
import './logs.dart';
import './users.dart';
import './bills.dart';
import './notes.dart';
import './employees.dart';
import './settings.dart';
import '../utils/utils.dart';

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DashBoardState();
  }
}

class DashBoardState extends State<DashBoard> {
  FocusNode textSecondFocusNode = new FocusNode();

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
                  new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: HexColor("#D7BDE2"),
                    child: new MaterialButton(
                      child: new Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // new Icon(
                            //   Icons.supervisor_account,
                            //   color: Colors.white,
                            //   size: 35,
                            // ),
                            new Text(
                              "1987",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            new Text("Users",
                                style: new TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new UsersActivity(null)),
                        );
                      },
                    ),
                  ),
                  new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: HexColor("#F5CBA7"),
                    child: new MaterialButton(
                      child: new Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // new Icon(
                            //   Icons.local_hotel,
                            //   color: Colors.white,
                            //   size: 35,
                            // ),
                            new Text(
                              "107",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            new Text("Rooms",
                                style: new TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new RoomsActivity()),
                        );
                      },
                    ),
                  ),
                  new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: HexColor("#F9E79F"),
                    child: new MaterialButton(
                      child: new Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // new Icon(
                            //   Icons.attach_money,
                            //   color: Colors.white,
                            //   size: 35,
                            // ),
                            new Text(
                              "4123",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            new Text("Bills",
                                style: new TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new BillsActivity(null, null)),
                        );
                      },
                    ),
                  ),
                  new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: HexColor("#A2D9CE"),
                    child: new MaterialButton(
                      child: new Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // new Icon(
                            //   Icons.format_list_numbered,
                            //   color: Colors.white,
                            //   size: 35,
                            // ),
                            new Text(
                              "44",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            new Text("Notes",
                                style: new TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new NotesActivity()),
                        );
                      },
                    ),
                  ),
                  new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: HexColor("#AED6F1"),
                    child: new MaterialButton(
                      child: new Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // new Icon(
                            //   Icons.account_box,
                            //   color: Colors.white,
                            //   size: 35,
                            // ),
                            new Text(
                              "12",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            new Text("Employees",
                                style: new TextStyle(
                                    fontSize: 20, color: Colors.black)),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new EmployeesActivity()),
                        );
                      },
                    ),
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
                  new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: HexColor("#F5B7B1"),
                    child: new MaterialButton(
                      child: new Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              Icons.track_changes,
                              color: Colors.white,
                              size: 35,
                            ),
                            new Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5)),
                            new Text("Logs",
                                style: new TextStyle(
                                    fontSize: 20, color: Colors.black)),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new LogsActivity()),
                        );
                      },
                    ),
                  ),
                  new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: HexColor("#ABB2B9"),
                    child: new MaterialButton(
                      child: new Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              Icons.show_chart,
                              color: Colors.white,
                              size: 35,
                            ),
                            new Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5)),
                            new Text("Reports",
                                style: new TextStyle(
                                    fontSize: 20, color: Colors.black)),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new ReportActivity()),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
