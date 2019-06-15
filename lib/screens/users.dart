import 'package:flutter/material.dart';

import './user.dart';
import './userFilter.dart';
import './bills.dart';
import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/utils.dart';

class UsersActivity extends StatefulWidget {
  @override
  UsersActivityState createState() {
    return new UsersActivityState();
  }
}

class UsersActivityState extends State<UsersActivity> {
  Map<String, String> filter = new Map();

  @override
  void initState() {
    super.initState();
    filter["hostel_id"] = hostelID;
    filter["status"] = "1";
  }

  Widget fillData() => new FutureBuilder<Users>(
        future: getUsers(filter),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.meta.messageType == "4") {
              return new Center(
                  child: popDialog(context, "App Update Required", true));
            }
            return bodyData(snapshot.data.users);
          } else if (snapshot.hasError) {
            return new Center(child: popDialog(context, "Network Error", true));
          }
          return new Center(child: showProgress("loading..."));
        },
      );

  Widget bodyData(List<User> users) => new DataTable(
      onSelectAll: (b) {},
      sortAscending: true,
      columns: <DataColumn>[
        new DataColumn(
          label: new Text("Name"),
        ),
        new DataColumn(
          label: new Text("Room"),
        ),
        new DataColumn(
          label: new Text("Rent"),
        ),
      ],
      rows: users
          .map(
            (user) => new DataRow(
                  cells: [
                    new DataCell(Text(user.name), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new UserActivity(user, null)),
                      );
                    }),
                    new DataCell(Text(user.roomID), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new UserActivity(user, null)),
                      );
                    }),
                    new DataCell(Text(user.rent), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new BillsActivity(user, null)),
                      );
                    })
                  ],
                ),
          )
          .toList());

  filterPage(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as Map<String, String>;

    if (data != null) {
      data["hostel_id"] = hostelID;
      data["status"] = "1";
      print(data);
      setState(() {
        filter = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Users"),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              filterPage(context, new UserFilterActivity());
            },
            icon: new Icon(Icons.filter_list),
          ),
        ],
      ),
      body: new SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: new SizedBox(
          width: MediaQuery.of(context).size.width,
          child: new ListView(
            children: <Widget>[fillData()],
          ),
        ),
      ),
    );
  }
}
