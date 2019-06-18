import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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

  List<Room> rooms = new List();
  bool end = false;
  bool ongoing = false;

  @override
  void initState() {
    super.initState();
    filter["status"] = "1";
    filter["hostel_id"] = hostelID;

    fillData();
  }

  void fillData() {
    if (!end && !ongoing) {
      ongoing = true;
      Future<Rooms> data = getRooms(filter);
      data.then((response) {
        if (response.rooms.length > 0) {
          setState(() {
            rooms.addAll(response.rooms);
          });
        } else {
          end = true;
        }
        ongoing = false;
      });
    }
  }

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
        rooms.clear();
        fillData();
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
      body: new ListView.separated(
        itemCount: rooms.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (itemContext, i) {
          return new Container(
            child: new Slidable(
              actionPane: new SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: new Column(
                children: <Widget>[
                  new Container(
                    margin: new EdgeInsets.all(13),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          rooms[i].roomno,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        new Column(
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: new Text(
                                rooms[i].filled + "/" + rooms[i].capacity,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w100),
                              ),
                            ),
                            new Text(getAmenitiesNames(rooms[i].amenities)),
                          ],
                        ),
                        new Column(
                          children: <Widget>[
                            new Text(
                              "₹" + rooms[i].rent,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              secondaryActions: <Widget>[
                new IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    if (rooms[i].filled != "0") {
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        style: AlertStyle(
                          isCloseButton: false,
                          isOverlayTapDismiss: true,
                        ),
                        title: "RFLUTTER ALERT",
                        desc: "Flutter is more awesome with RFlutter Alert.",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "COOL",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              // Navigator.pop(itemContext);
                            },
                            width: 120,
                          )
                        ],
                      ).show();
                    } else {
                      print(rooms[i].roomno + " deleted");
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
