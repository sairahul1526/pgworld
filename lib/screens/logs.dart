import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pgworld/utils/utils.dart';

import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';

class LogsActivity extends StatefulWidget {
  LogsActivity();
  @override
  LogsActivityState createState() {
    return new LogsActivityState();
  }
}

class LogsActivityState extends State<LogsActivity> {
  Map<String, String> filter = new Map();

  List<ListItem> logs = new List();
  bool end = false;
  bool ongoing = false;

  double width = 0;

  String offset = defaultOffset;
  bool loading = true;

  ScrollController _controller;

  String previousDate = "";

  @override
  void initState() {
    super.initState();

    filter["status"] = "1";
    filter["hostel_id"] = hostelID;

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
    Future<Logs> data = getLogs(filter);
    data.then((response) {
      if (response.logs != null && response.logs.length > 0) {
        offset = (int.parse(response.pagination.offset) + response.logs.length)
            .toString();
        response.logs.forEach((log) {
          if (log is Log) {
            if (previousDate.compareTo(log.createdDateTime.split(" ")[0]) !=
                0) {
              previousDate = log.createdDateTime.split(" ")[0];
              logs.add(HeadingItem(previousDate));
            }
          }
          if (log.type == "2") {
            // bill
            log.color = "#F9E79F";
            log.icon = Icons.attach_money;
          } else if (log.type == "3") {
            // employee
            log.color = "#AED6F1";
            log.icon = Icons.account_box;
          } else if (log.type == "5") {
            // note
            log.color = "#A2D9CE";
            log.icon = Icons.format_list_numbered;
          } else if (log.type == "6") {
            // room
            log.color = "#F5CBA7";
            log.icon = Icons.local_hotel;
          } else if (log.type == "7") {
            // rent
            log.color = "#F9E79F";
            log.icon = Icons.attach_money;
          } else if (log.type == "8") {
            // salary
            log.color = "#F9E79F";
            log.icon = Icons.attach_money;
          } else if (log.type == "9") {
            // user
            log.color = "#D7BDE2";
            log.icon = Icons.supervisor_account;
          } else {
            log.color = "#F5B7B1";
            log.icon = Icons.track_changes;
          }
          logs.add(log);
        });
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
          "Activity",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ModalProgressHUD(
        child: logs.length == 0
            ? new Center(
                child: new Text("No activity"),
              )
            : new ListView.builder(
                controller: _controller,
                itemCount: logs.length,
                itemBuilder: (context, i) {
                  final item = logs[i];
                  if (item is HeadingItem) {
                    return new Container(
                      decoration: i != 0
                          ? new BoxDecoration(
                              border: new Border(
                              top: BorderSide(
                                color: HexColor("#dedfe0"),
                              ),
                            ))
                          : null,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, i != 0 ? 10 : 0, 0, 0),
                      child: new Text(
                        headingDateFormat.format(DateTime.parse(item.heading)),
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    );
                  } else if (item is Log) {
                    return new ListTile(
                      dense: true,
                      title: new Container(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                padding: EdgeInsets.all(7),
                                color: HexColor(item.color),
                                child: new Icon(
                                  item.icon,
                                  color: Colors.white,
                                )),
                            new Expanded(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        item.by + " ",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      new Text(
                                        item.log,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Container(
                                    width: width * 0.7,
                                    child: new Text(
                                      timeFormat.format(
                                          DateTime.parse(item.createdDateTime)
                                              .add(new Duration(
                                                  hours: 5, minutes: 30))),
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w100,
                                          color: Colors.grey),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
        inAsyncCall: loading,
      ),
    );
  }
}
