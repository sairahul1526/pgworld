import 'package:flutter/material.dart';

import './user.dart';
import './bills.dart';
import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';

class RoomUsersActivity extends StatefulWidget {
  final Room room;

  RoomUsersActivity(this.room);
  @override
  RoomUsersActivityState createState() {
    return new RoomUsersActivityState(room);
  }
}

class RoomUsersActivityState extends State<RoomUsersActivity> {
  bool loading = false;

  Room room;

  RoomUsersActivityState(this.room);

  Widget fillData() => new FutureBuilder<Users>(
        future: getUsers(Map.from(
            {'room_id': room.id, 'hostel_id': hostelID, 'status': '1'})),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return bodyData(snapshot.data.users);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return new Center(
            child: CircularProgressIndicator(),
          );
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
              users.sort((a, b) => a.roomno.compareTo(b.roomID));
            });
          },
        ),
        new DataColumn(
          label: new Text("Rent"),
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              users.sort((a, b) => a.rent.compareTo(b.rent));
            });
          },
        ),
        new DataColumn(
          label: new Text(""),
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
                    }),
                    new DataCell(new Icon(Icons.delete), onTap: () {
                      setState(() {
                        loading = true;
                      });
                      Future<bool> load = delete(
                        API.USER,
                        Map.from({
                          'hostel_id': hostelID,
                          'id': user.id,
                          "room_id": room.id
                        }),
                      );
                      load.then((onValue) {
                        setState(() {
                          loading = false;
                        });
                        Navigator.pop(context);
                      });
                    })
                  ],
                ),
          )
          .toList());

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(room.roomno + " users"),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new UserActivity(null, room)),
              );
            },
            icon: new Icon(Icons.add),
          ),
        ],
      ),
      body: loading
          ? CircularProgressIndicator()
          : new SingleChildScrollView(
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
