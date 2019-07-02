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
        body: ModalProgressHUD(
          child: rooms.length == 0
              ? new Center(
                  child: new Text("No rooms"),
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
                                margin: new EdgeInsets.all(13),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10),
                                          child: new Text(
                                            rooms[i].filled +
                                                "/" +
                                                rooms[i].capacity,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w100),
                                          ),
                                        ),
                                        new Text(getAmenitiesNames(
                                            rooms[i].amenities)),
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
