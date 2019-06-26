import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

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
      if (response.users.length > 0) {
        offset = (int.parse(response.pagination.offset) + response.users.length)
            .toString();
        users.addAll(response.users);
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
      if (room != null) {
        filter["room_id"] = room.id;
      }
      data["hostel_id"] = hostelID;
      data["status"] = "1";
      filter["limit"] = defaultLimit;
      filter["offset"] = defaultOffset;
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
        title: new Text(room != null ? room.roomno : "" + " Users"),
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
                                new UserActivity(users[i], room)),
                      );
                    },
                    title: new Container(
                      child: new Slidable(
                        actionPane: new SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              child: new Text(
                                users[i].name,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            new Container(
                              margin: new EdgeInsets.all(13),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Flexible(
                                    child: new Column(
                                      children: <Widget>[
                                        new RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: users[i].phone,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.blue,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        makePhone(
                                                            users[i].phone);
                                                      }),
                                          ]),
                                        ),
                                        new RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: users[i].email,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        sendMail(
                                                            users[i].email);
                                                      }),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Container(
                                      margin: EdgeInsets.only(left: 10),
                                      width: width * 0.3,
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          new Column(
                                            children: <Widget>[
                                              new Text(
                                                users[i].roomID,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              new Text(
                                                "₹" + users[i].rent,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w100,
                                                    color: Colors.green),
                                              )
                                            ],
                                          ),
                                          new Column(
                                            children: <Widget>[
                                              new Text(
                                                users[i].food == "1"
                                                    ? "Veg"
                                                    : "Non",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w500,
                                                    color: users[i].food == "1"
                                                        ? Colors.green
                                                        : Colors.red),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        secondaryActions: <Widget>[
                          new IconSlideAction(
                            caption: 'Rent',
                            color: Colors.green,
                            icon: Icons.attach_money,
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        new BillsActivity(users[i], null)),
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
