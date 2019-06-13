import 'package:flutter/material.dart';

import './room.dart';
import './roomFilter.dart';
import './user.dart';
import './roomUsers.dart';
import '../utils/api.dart';
import '../utils/models.dart';
import '../utils/config.dart';
import '../utils/utils.dart';

class RoomsActivity extends StatefulWidget {
  @override
  RoomsActivityState createState() {
    return new RoomsActivityState();
  }
}

class RoomsActivityState extends State<RoomsActivity> {
  Map<String, String> filter = new Map();

  @override
  void initState() {
    super.initState();
    filter["status"] = "1";
    filter["hostel_id"] = hostelID;
  }

  Widget fillData() => new FutureBuilder<Rooms>(
        future: getRooms(filter),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.meta.messageType == "4") {
              return new Center(
                  child: popDialog(context, "App Update Required", true));
            }
            return bodyData(snapshot.data.rooms);
          } else if (snapshot.hasError) {
            return new Center(child: popDialog(context, "Network Error", true));
          }
          return new Center(child: showProgress("loading..."));
        },
      );

  Widget bodyData(List<Room> rooms) => new DataTable(
      onSelectAll: (b) {},
      sortAscending: true,
      columns: <DataColumn>[
        new DataColumn(
          label: new Text("Room No."),
        ),
        new DataColumn(
          label: new Text("Occupancy"),
        ),
        new DataColumn(
          label: new Text("Rent"),
        ),
        new DataColumn(
          label: new Text(""),
        ),
      ],
      rows: rooms
          .map(
            (room) => new DataRow(
                  cells: [
                    new DataCell(Text(room.roomno), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new RoomActivity(room)),
                      );
                    }),
                    new DataCell(Text(room.filled + "/" + room.capacity),
                        onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => (room.filled == "0")
                                ? new UserActivity(null, room)
                                : new RoomUsersActivity(room)),
                      );
                    }),
                    new DataCell(Text(room.rent), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new RoomActivity(room)),
                      );
                    }),
                    new DataCell(
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[],
                      ),
                      showEditIcon: false,
                      placeholder: false,
                    )
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
      data["status"] = "1";
      data["hostel_id"] = hostelID;
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
        title: new Text("Rooms"),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              filterPage(context, new RoomFilterActivity());
            },
            icon: new Icon(Icons.filter_list),
          ),
          new IconButton(
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new RoomActivity(null)),
              );
            },
            icon: new Icon(Icons.add),
          ),
        ],
      ),
      body: new SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: new SizedBox(
          width: MediaQuery.of(context).size.width * 1.2,
          child: new ListView(
            children: <Widget>[fillData()],
          ),
        ),
      ),
    );
  }
}
