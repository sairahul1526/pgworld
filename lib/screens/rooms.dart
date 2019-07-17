import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import './room.dart';
import './roomFilter.dart';
import './users.dart';
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
    Future<Rooms> data = getRooms(filter);
    data.then((response) {
      if (response.rooms != null && response.rooms.length > 0) {
        offset = (int.parse(response.pagination.offset) + response.rooms.length)
            .toString();
        rooms.addAll(response.rooms);
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

  filterPage(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as Map<String, String>;

    if (data != null) {
      data["status"] = "1";
      data["hostel_id"] = hostelID;
      data["limit"] = defaultLimit;
      data["offset"] = defaultOffset;
      offset = defaultOffset;
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
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: new Text(
            "Rooms",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                filterPage(context, new RoomFilterActivity());
              },
              icon: new Icon(
                Icons.filter_list,
              ),
            ),
            new IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new RoomActivity(null)),
                );
              },
              icon: new Icon(
                Icons.add,
              ),
            ),
          ],
        ),
        body: ModalProgressHUD(
          child: rooms.length == 0
              ? new Center(
                  child: new Text(loading ? "" : "No rooms"),
                )
              : new ListView.separated(
                  controller: _controller,
                  itemCount: rooms.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (itemContext, i) {
                    return new ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new UsersActivity(rooms[i])),
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
                                    new Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      height: 50,
                                      // width: 3,
                                      color:
                                          rooms[i].filled == rooms[i].capacity
                                              ? HexColor("#F5B7B1")
                                              : HexColor("#A2D9CE"),
                                      child: new Text(
                                        rooms[i].roomno,
                                        style: TextStyle(
                                          fontSize: 20,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    new Expanded(
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              // new Text(
                                              //   rooms[i].roomno,
                                              //   style: TextStyle(
                                              //     fontSize: 24,
                                              //     fontWeight: FontWeight.bold,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          // new Text(getAmenitiesNames(
                                          //     rooms[i].amenities)),
                                          new Row(
                                            // scrollDirection: Axis.horizontal,
                                            children: <Widget>[
                                              new Column(
                                                children: <Widget>[
                                                  new Icon(
                                                    Icons.wifi,
                                                    size: 15,
                                                  ),
                                                  new Text(
                                                    "Wifi",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                              new Container(
                                                width: 15,
                                              ),
                                              new Column(
                                                children: <Widget>[
                                                  new Icon(
                                                    Icons.tv,
                                                    size: 15,
                                                  ),
                                                  new Text(
                                                    "TV",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                              new Container(
                                                width: 15,
                                              ),
                                              new Column(
                                                children: <Widget>[
                                                  new Icon(
                                                    Icons.ac_unit,
                                                    size: 15,
                                                  ),
                                                  new Text(
                                                    "AC",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                              new Container(
                                                width: 15,
                                              ),
                                              new Column(
                                                children: <Widget>[
                                                  new Icon(
                                                    Icons.power,
                                                    size: 15,
                                                  ),
                                                  new Text(
                                                    "Power\nBackup",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                              new Container(
                                                width: 5,
                                              ),
                                              new Column(
                                                children: <Widget>[
                                                  new Text(
                                                    i == 1 ? "+1" : "+2",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    new Column(
                                      children: <Widget>[
                                        new Text(
                                          i == 3
                                              ? "10/10"
                                              : rooms[i].filled +
                                                  "/" +
                                                  rooms[i].capacity,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w100,
                                            color: rooms[i].filled ==
                                                    rooms[i].capacity
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                        new Text(
                                          "₹" + rooms[i].rent,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black),
                                        )
                                      ],
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
                                          new RoomActivity(rooms[i])),
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
        ));
  }
}
