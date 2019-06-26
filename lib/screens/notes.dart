import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

import './note.dart';
import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';

class NotesActivity extends StatefulWidget {
  @override
  NotesActivityState createState() {
    return new NotesActivityState();
  }
}

class NotesActivityState extends State<NotesActivity> {
  bool checked = false;
  Map<String, String> filter = new Map();

  List<Note> notes = new List();
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
    Future<Notes> data = getNotes(filter);
    data.then((response) {
      if (response.notes.length > 0) {
        offset = (int.parse(response.pagination.offset) + response.notes.length)
            .toString();
        notes.addAll(response.notes);
      } else {
        end = true;
      }
      setState(() {
        ongoing = false;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Notes"),
        actions: <Widget>[
          new Checkbox(
            value: checked,
            onChanged: (bool value) {
              filter["status"] = checked ? "1" : "0";
              filter["hostel_id"] = hostelID;
              filter["limit"] = defaultLimit;
              offset = defaultOffset;
              filter["offset"] = defaultOffset;
              setState(() {
                checked = value;
                notes.clear();
                setState(() {
                  loading = true;
                });
                fillData();
              });
            },
          ),
          new IconButton(
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new NoteActivity(null)),
              );
            },
            icon: new Icon(Icons.add),
          ),
        ],
      ),
      body: ModalProgressHUD(
        child: notes.length == 0
            ? new Center(
                child: new Text("No notes"),
              )
            : new ListView.separated(
                controller: _controller,
                itemCount: notes.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, i) {
                  return new ListTile(
                    onTap: () {
                      setState(() {
                        update(
                          API.NOTE,
                          Map.from({
                            "status": notes[i].status == "1" ? "0" : "1",
                          }),
                          Map.from({'hostel_id': hostelID, 'id': notes[i].id}),
                        );
                      });
                    },
                    title: new Container(
                      margin: new EdgeInsets.all(13),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Checkbox(
                              value: notes[i].status == "0" ? true : false,
                              onChanged: (bool value) {
                                setState(() {
                                  update(
                                    API.NOTE,
                                    Map.from({
                                      "status":
                                          notes[i].status == "1" ? "0" : "1",
                                    }),
                                    Map.from({
                                      'hostel_id': hostelID,
                                      'id': notes[i].id
                                    }),
                                  );
                                });
                              }),
                          new Flexible(
                            child: new Column(
                              children: <Widget>[
                                new Text(
                                  notes[i].note,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
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
