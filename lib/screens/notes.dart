import 'package:flutter/material.dart';

import './note.dart';
import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/utils.dart';

class NotesActivity extends StatefulWidget {
  @override
  NotesActivityState createState() {
    return new NotesActivityState();
  }
}

class NotesActivityState extends State<NotesActivity> {
  bool checked = false;
  Widget data;

  Widget fillData() => new FutureBuilder<Notes>(
        future: getNotes(
            Map.from({'hostel_id': hostelID, 'status': checked ? '1' : '0'})),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.meta.messageType == "4") {
              return new Center(
                  child: popDialog(context, "App Update Required", true));
            }
            return bodyData(snapshot.data.notes);
          } else if (snapshot.hasError) {
            return new Center(child: popDialog(context, "Network Error", true));
          }
          return new Center(child: showProgress("loading..."));
        },
      );

  Widget bodyData(List<Note> notes) => new DataTable(
      onSelectAll: (b) {},
      sortAscending: true,
      columns: <DataColumn>[
        new DataColumn(
          label: new Text(""),
        ),
        new DataColumn(
          label: new Text("Note"),
        ),
      ],
      rows: notes
          .map(
            (note) => new DataRow(
                  cells: [
                    new DataCell(
                        new Checkbox(
                          value: note.status == "1" ? true : false,
                          onChanged: (bool value) {
                            setState(() {
                              update(
                                API.NOTE,
                                Map.from({
                                  "status": note.status == "1" ? "0" : "1",
                                }),
                                Map.from(
                                    {'hostel_id': hostelID, 'id': note.id}),
                              );
                            });
                          },
                        ), onTap: () {
                      setState(() {
                        update(
                          API.NOTE,
                          Map.from({
                            "status": note.status == "1" ? "0" : "1",
                          }),
                          Map.from({'hostel_id': hostelID, 'id': note.id}),
                        );
                      });
                    }),
                    new DataCell(Text(note.note), onTap: () {
                      setState(() {
                        update(
                          API.NOTE,
                          Map.from({
                            "status": note.status == "1" ? "0" : "1",
                          }),
                          Map.from({'hostel_id': hostelID, 'id': note.id}),
                        );
                      });
                    }),
                  ],
                ),
          )
          .toList());

  @override
  Widget build(BuildContext context) {
    data = fillData();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Notes"),
        actions: <Widget>[
          new Checkbox(
            value: checked,
            onChanged: (bool value) {
              setState(() {
                checked = value;
                data = fillData();
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
      body: new SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: new SizedBox(
          width: MediaQuery.of(context).size.width,
          child: new ListView(
            children: <Widget>[data],
          ),
        ),
      ),
    );
  }
}
