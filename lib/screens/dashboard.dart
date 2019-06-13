import 'package:flutter/material.dart';

import './rooms.dart';
import './logs.dart';
import './users.dart';
import './bills.dart';
import './notes.dart';
import './employees.dart';
import './settings.dart';

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
          title: new Text("DashBoard"),
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
            ),
          ],
        ),
        body: new Container(
          child: new GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20.0),
            crossAxisSpacing: 10.0,
            crossAxisCount: 2,
            children: <Widget>[
              new MaterialButton(
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.supervisor_account,
                        size: 70,
                      ),
                      new Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5)),
                      new Text("Users", style: new TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new UsersActivity()),
                  );
                },
              ),
              new MaterialButton(
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.local_hotel,
                        size: 70,
                      ),
                      new Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5)),
                      new Text("Rooms", style: new TextStyle(fontSize: 20)),
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
              new MaterialButton(
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.attach_money,
                        size: 70,
                      ),
                      new Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5)),
                      new Text("Bills", style: new TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new BillsActivity(null, null)),
                  );
                },
              ),
              new MaterialButton(
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.format_list_numbered,
                        size: 70,
                      ),
                      new Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5)),
                      new Text("Notes", style: new TextStyle(fontSize: 20)),
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
              new MaterialButton(
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.account_box,
                        size: 70,
                      ),
                      new Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5)),
                      new Text("Employees", style: new TextStyle(fontSize: 20)),
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
              new MaterialButton(
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.track_changes,
                        size: 70,
                      ),
                      new Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5)),
                      new Text("Logs", style: new TextStyle(fontSize: 20)),
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
              new MaterialButton(
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.show_chart,
                        size: 70,
                      ),
                      new Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5)),
                      new Text("Reports", style: new TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                onPressed: () {},
              )
            ],
          ),
        ));
  }
}
