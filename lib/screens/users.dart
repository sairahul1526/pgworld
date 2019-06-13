import 'package:flutter/material.dart';

import './user.dart';
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
  Widget fillData() => new FutureBuilder<Users>(
        future: getUsers(Map.from({'hostel_id': hostelID, "status": "1"})),
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
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              users.sort((a, b) => a.name.compareTo(b.name));
            });
          },
        ),
        new DataColumn(
          label: new Text("Room"),
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              users.sort((a, b) => a.roomno.compareTo(b.roomno));
            });
          },
        ),
        new DataColumn(
          label: new Text("Rent"),
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              users.sort((a, b) => a.rent.compareTo(b.expiryDateTime));
            });
          },
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
                    new DataCell(Text(user.roomno), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new UserActivity(user, null)),
                      );
                    }),
                    new DataCell(Text(user.expiryDateTime), onTap: () {
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Users"),
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
