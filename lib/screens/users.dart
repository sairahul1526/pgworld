import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import './user.dart';
import './userFilter.dart';
import './bills.dart';
import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/utils.dart';

class UsersActivity extends StatefulWidget {
  final Room room;

  UsersActivity(this.room);

  @override
  UsersActivityState createState() {
    return new UsersActivityState(room);
  }
}

class UsersActivityState extends State<UsersActivity> {
  Map<String, String> filter = new Map();

  List<User> users = new List();
  bool end = false;
  bool ongoing = false;

  double width = 0;

  Room room;
  String offset = defaultOffset;
  bool loading = true;

  ScrollController _controller;

  UsersActivityState(this.room);

  @override
  void initState() {
    super.initState();
    if (room != null) {
      filter["room_id"] = room.id;
    }
    filter["status"] = "1";
    filter["hostel_id"] = hostelID;
    filter["limit"] = defaultLimit;
    filter["offset"] = defaultOffset;

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
    Future<Users> data = getUsers(filter);
    data.then((response) {
      if (response.users != null && response.users.length > 0) {
        offset = (int.parse(response.pagination.offset) + response.users.length)
            .toString();
        users.addAll(response.users);
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
      if (room != null) {
        filter["room_id"] = room.id;
      }
      data["hostel_id"] = hostelID;
      data["status"] = "1";
      data["limit"] = defaultLimit;
      data["offset"] = defaultOffset;
      offset = defaultOffset;
      print(data);
      setState(() {
        filter = data;
        users.clear();
        fillData();
      });
    }
  }

  addPage(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as String;

    if (data != null) {
      if (room != null) {
        filter["room_id"] = room.id;
      }
      filter["status"] = "1";
      filter["hostel_id"] = hostelID;
      filter["limit"] = defaultLimit;
      filter["offset"] = defaultOffset;
      offset = defaultOffset;

      users.clear();
      fillData();
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: new Text(
          room != null ? room.roomno : "Users",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          room == null
              ? new IconButton(
                  onPressed: () {
                    filterPage(context, new UserFilterActivity());
                  },
                  icon: new Icon(Icons.filter_list),
                )
              : new Container(),
          new IconButton(
            onPressed: () {
              addPage(context, new UserActivity(null, room));
            },
            icon: new Icon(Icons.add),
          )
        ],
      ),
      body: ModalProgressHUD(
        child: users.length == 0
            ? new Center(
                child: new Text(loading ? "" : "No users"),
              )
            : new ListView.separated(
                controller: _controller,
                itemCount: users.length,
                separatorBuilder: (context, i) {
                  return new Divider();
                },
                itemBuilder: (itemContext, i) {
                  return new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new BillsActivity(users[i], null)),
                      );
                    },
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(10, i == 0 ? 10 : 0, 10, 0),
                      child: new Slidable(
                        actionPane: new SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    margin: EdgeInsets.fromLTRB(0, 3, 10, 10),
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: new BoxDecoration(
                                      color: i == 1
                                          ? HexColor(COLORS.GREEN)
                                          : HexColor(COLORS.RED),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: new Text(
                                      users[i].name[0].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                      child: new Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: new Column(
                                      children: <Widget>[
                                        new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new Flexible(
                                              child: new Text(
                                                users[i].name[0].toUpperCase() +
                                                    users[i].name.substring(1),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            new Text(
                                              "₹" + users[i].rent,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  color: i == 1
                                                      ? Colors.red
                                                      : Colors.green),
                                            )
                                          ],
                                        ),
                                        new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              "Room : " +
                                                  users[i].roomID +
                                                  "    Meal : " +
                                                  (users[i].food == "1"
                                                      ? ""
                                                      : "Non ") +
                                                  "Veg",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w100,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        new Container(
                                          height: 10,
                                        ),
                                        new Row(
                                          children: <Widget>[
                                            users[i].phone != ""
                                                ? new GestureDetector(
                                                    onTap: () {
                                                      makePhone(users[i].phone);
                                                    },
                                                    child: new Container(
                                                      child: new Row(
                                                        children: <Widget>[
                                                          new Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    2, 2, 0, 2),
                                                            child: new Icon(
                                                                Icons.phone,
                                                                size: 15,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          new Text(
                                                            "   " +
                                                                users[i].phone,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : new Container(),
                                            users[i].phone != ""
                                                ? new Container(
                                                    height: 0,
                                                    width: 10,
                                                  )
                                                : new Container(),
                                            users[i].email != ""
                                                ? new GestureDetector(
                                                    onTap: () {
                                                      sendMail(users[i].email,
                                                          "", "");
                                                    },
                                                    child: new Container(
                                                      child: new Row(
                                                        children: <Widget>[
                                                          new Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            child: new Icon(
                                                                Icons.email,
                                                                size: 15,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          new Text(
                                                            "   " +
                                                                users[i].email,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : new Container(),
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
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
                                        new UserActivity(users[i], room)),
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
      ),
    );
  }
}
