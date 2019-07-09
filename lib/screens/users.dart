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
          new IconButton(
            onPressed: () {
              filterPage(context, new UserFilterActivity());
            },
            icon: new Icon(Icons.filter_list),
          ),
        ],
      ),
      body: ModalProgressHUD(
        child: users.length == 0
            ? new Center(
                child: new Text("No users"),
              )
            : new ListView.separated(
                controller: _controller,
                itemCount: users.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (itemContext, i) {
                  return new ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new BillsActivity(users[i], null)),
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
                                  new Expanded(
                                    child: new Column(
                                      children: <Widget>[
                                        new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new Text(
                                              users[i].name[0].toUpperCase() +
                                                  users[i].name.substring(1),
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            new Text(
                                              "₹" + users[i].rent,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black),
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
                                                  ",  ",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w100,
                                              ),
                                            ),
                                            new Text(
                                                users[i].food == "1"
                                                    ? "Veg"
                                                    : "Non",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w100,
                                                ))
                                          ],
                                        ),
                                        new Row(
                                          children: <Widget>[
                                            users[i].phone != ""
                                                ? new ButtonTheme(
                                                    height: 25,
                                                    child: new FlatButton.icon(
                                                      shape: new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  15.0)),
                                                      color:
                                                          HexColor("#AED6F1"),
                                                      label: new Text(
                                                        users[i].phone,
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                      icon: new Icon(
                                                        Icons.phone,
                                                        size: 15,
                                                      ),
                                                      onPressed: () {
                                                        makePhone(
                                                            users[i].phone);
                                                      },
                                                    ),
                                                  )
                                                : new Container(),
                                            users[i].phone != ""
                                                ? new Container(
                                                    height: 50,
                                                    width: 10,
                                                  )
                                                : new Container(),
                                            new Flexible(
                                              child: users[i].email != ""
                                                  ? new ButtonTheme(
                                                      height: 25,
                                                      child:
                                                          new FlatButton.icon(
                                                        shape: new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    15.0)),
                                                        color:
                                                            HexColor("#AED6F1"),
                                                        label: new Flexible(
                                                          child: new Text(
                                                            users[i].email,
                                                            softWrap: false,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                        icon: new Icon(
                                                          Icons.email,
                                                          size: 15,
                                                        ),
                                                        onPressed: () {
                                                          sendMail(
                                                              users[i].email);
                                                        },
                                                      ),
                                                    )
                                                  : new Container(),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
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
