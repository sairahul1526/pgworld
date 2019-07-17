import 'package:flutter/material.dart';

import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/models.dart';

class NoteActivity extends StatefulWidget {
  final Note note;

  NoteActivity(this.note);
  @override
  State<StatefulWidget> createState() {
    return new NoteActivityState(note);
  }
}

class NoteActivityState extends State<NoteActivity> {
  TextEditingController item = new TextEditingController();
  Note note;

  bool loading = false;

  NoteActivityState(this.note);

  @override
  void initState() {
    super.initState();
    if (note != null) {
      item.text = note.note;
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
          "Note",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 4.0,
        actions: <Widget>[
          new MaterialButton(
            textColor: Colors.white,
            child: note != null
                ? new Text(
                    "SAVE",
                    style: TextStyle(color: Colors.black),
                  )
                : new Text(
                    "ADD",
                    style: TextStyle(color: Colors.black),
                  ),
            onPressed: () {
              if (item.text.length == 0) {
                return;
              }
              setState(() {
                loading = true;
              });
              if (note != null) {
                Future<bool> load = update(
                  API.NOTE,
                  Map.from({
                    "note": item.text,
                  }),
                  Map.from({'hostel_id': hostelID, 'id': note.id}),
                );
                load.then((onValue) {
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                });
              } else {
                Future<bool> load = add(
                  API.NOTE,
                  Map.from({
                    'hostel_id': hostelID,
                    'note': item.text,
                    'status': "1"
                  }),
                );
                load.then((onValue) {
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                });
              }
            },
          ),
        ],
      ),
      body: loading
          ? CircularProgressIndicator()
          : new Container(
              margin: new EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.1,
                  0,
                  MediaQuery.of(context).size.width * 0.1,
                  0),
              child: new ListView(
                children: <Widget>[
                  new Container(
                    height: 200,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Flexible(
                          child: new Container(
                            child: new TextField(
                              controller: item,
                              maxLines: 5,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                isDense: true,
                                prefixIcon: Icon(Icons.note),
                                border: OutlineInputBorder(),
                                labelText: 'Note',
                              ),
                              onSubmitted: (String value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
