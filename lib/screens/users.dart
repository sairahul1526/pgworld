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
    final theme = Theme.of(context).copyWith(
      dividerColor: Colors.transparent,
    );
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
            : new Container(
                color: Colors.black,
                child: new ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  controller: _controller,
                  itemCount: users.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (itemContext, i) {
                    return new Container(
                      child: new ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    new BillsActivity(users[i], null)),
                          );
                        },
                        title: Theme(
                          data: theme,
                          child: new ExpansionTile(
                            backgroundColor: Colors.yellow,
                            initiallyExpanded: i == 0,
                            title: new Container(
                              color: Colors.red,
                              child: new Slidable(
                                actionPane: new SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: new Column(
                                  children: <Widget>[
                                    new Container(
                                      child: new Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new Container(
                                            margin: EdgeInsets.only(right: 10),
                                            padding: EdgeInsets.all(15),
                                            decoration: new BoxDecoration(
                                              color: HexColor(
                                                colors[random
                                                    .nextInt(colors.length)],
                                              ),
                                              shape: BoxShape.circle,
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
                                            child: new Column(
                                              children: <Widget>[
                                                new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    i % 2 == 0
                                                        ? new Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              right: 10,
                                                            ),
                                                            child: new Icon(
                                                              Icons.label,
                                                              size: 15,
                                                              color: Colors.red,
                                                            ),
                                                          )
                                                        : new Container(),
                                                    new Text(
                                                      users[i]
                                                              .name[0]
                                                              .toUpperCase() +
                                                          users[i]
                                                              .name
                                                              .substring(1),
                                                      style: TextStyle(
                                                        fontSize: 19,
                                                        // fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Icon(
                                                      Icons.local_hotel,
                                                      size: 20,
                                                    ),
                                                    new Text(
                                                      "  " +
                                                          users[i].roomID +
                                                          ",  ",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                      ),
                                                    ),
                                                    new Icon(
                                                      Icons.center_focus_strong,
                                                      size: 20,
                                                      color:
                                                          users[i].food == "1"
                                                              ? Colors.green
                                                              : Colors.red,
                                                    ),
                                                  ],
                                                ),
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
                                                new UserActivity(
                                                    users[i], room)),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            children: <Widget>[
                              new SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: new Row(
                                  children: <Widget>[
                                    new ButtonTheme(
                                      height: 25,
                                      child: new RaisedButton.icon(
                                        color: Colors.white,
                                        label: new Text(
                                          users[i].rent,
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        icon: new Icon(
                                          Icons.attach_money,
                                          size: 15,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new BillsActivity(
                                                        users[i], null)),
                                          );
                                        },
                                      ),
                                    ),
                                    new Container(
                                      height: 50,
                                      width: 10,
                                    ),
                                    new ButtonTheme(
                                      height: 25,
                                      child: new RaisedButton.icon(
                                        color: Colors.white,
                                        label: new Text(
                                          "EDIT",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        icon: new Icon(
                                          Icons.edit,
                                          size: 15,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new UserActivity(
                                                        users[i], room)),
                                          );
                                        },
                                      ),
                                    ),
                                    new Container(
                                      height: 50,
                                      width: 10,
                                    ),
                                    users[i].phone != ""
                                        ? new ButtonTheme(
                                            height: 25,
                                            child: new RaisedButton.icon(
                                              color: Colors.white,
                                              label: new Text(
                                                "PHONE",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              icon: new Icon(
                                                Icons.phone,
                                                size: 15,
                                              ),
                                              onPressed: () {
                                                makePhone(users[i].phone);
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
                                    users[i].email != ""
                                        ? new ButtonTheme(
                                            height: 25,
                                            child: new RaisedButton.icon(
                                              color: Colors.white,
                                              label: new Text(
                                                "EMAIL",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              icon: new Icon(
                                                Icons.mail,
                                                size: 15,
                                              ),
                                              onPressed: () {
                                                sendMail(users[i].email);
                                              },
                                            ),
                                          )
                                        : new Container(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        inAsyncCall: loading,
      ),
    );
  }
}
