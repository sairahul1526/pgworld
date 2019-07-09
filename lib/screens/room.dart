import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/models.dart';
import '../utils/utils.dart';

class RoomActivity extends StatefulWidget {
  final Room room;

  RoomActivity(this.room);
  @override
  State<StatefulWidget> createState() {
    return new RoomActivityState(room);
  }
}

class RoomActivityState extends State<RoomActivity> {
  bool wifi = false;
  bool bathroom = false;
  bool tv = false;
  bool ac = false;

  TextEditingController roomno = new TextEditingController();
  TextEditingController rent = new TextEditingController();
  TextEditingController capacity = new TextEditingController();

  Room room;

  Map<String, bool> avaiableAmenities = new Map<String, bool>();

  bool loading = false;

  RoomActivityState(this.room);

  @override
  void initState() {
    super.initState();
    amenities.forEach((amenity) => avaiableAmenities[amenity] = false);
    if (room != null) {
      roomno.text = room.roomno;
      rent.text = room.rent;
      capacity.text = room.capacity;
      if (room.amenities != null) {
        room.amenities.split(",").forEach((amenity) =>
            amenity.length > 0 ? avaiableAmenities[amenity] = true : null);
      }
    }
  }

  List<Widget> amenitiesWidget() {
    List<Widget> widgets = new List();
    avaiableAmenities.forEach((k, v) => widgets.add(new Row(
          children: <Widget>[
            new Checkbox(
              value: v,
              onChanged: (bool value) {
                setState(() {
                  avaiableAmenities[k] = value;
                });
              },
            ),
            new Text(getAmenityName(k))
          ],
        )));
    return widgets;
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
          "Room",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 4.0,
        actions: <Widget>[
          new MaterialButton(
            textColor: Colors.white,
            child: room != null
                ? new Text(
                    "SAVE",
                    style: TextStyle(color: Colors.black),
                  )
                : new Text(
                    "ADD",
                    style: TextStyle(color: Colors.black),
                  ),
            onPressed: () {
              setState(() {
                loading = true;
              });
              List<String> savedAmenities = new List();
              avaiableAmenities.forEach((k, v) {
                if (v) {
                  savedAmenities.add(k);
                }
              });
              Future<bool> load;
              if (room != null) {
                load = update(
                  API.ROOM,
                  Map.from({
                    "rent": rent.text,
                    "capacity": capacity.text,
                    "amenities": savedAmenities.length > 0
                        ? "," + savedAmenities.join(",") + ","
                        : ""
                  }),
                  Map.from({'hostel_id': hostelID, 'id': room.id}),
                );
              } else {
                load = add(
                  API.ROOM,
                  Map.from({
                    'hostel_id': hostelID,
                    'roomno': roomno.text,
                    'rent': rent.text,
                    'capacity': capacity.text,
                    'filled': "0",
                    "amenities": savedAmenities.length > 0
                        ? "," + savedAmenities.join(",") + ","
                        : ""
                  }),
                );
              }
              load.then((onValue) {
                setState(() {
                  loading = false;
                });
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
      body: ModalProgressHUD(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.1,
              25,
              MediaQuery.of(context).size.width * 0.1,
              0),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: new Text("Room No."),
                  ),
                  new Expanded(
                    child: new Container(
                      margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: new TextField(
                          controller: roomno,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Room No.'),
                          onSubmitted: (String value) {}),
                    ),
                  ),
                ],
              ),
              new Container(
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: new Text("Capacity"),
                    ),
                    new Flexible(
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: new TextField(
                          controller: capacity,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Capacity'),
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: new Text("Rent"),
                    ),
                    new Flexible(
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: new TextField(
                          controller: rent,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Rent'),
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                margin: new EdgeInsets.fromLTRB(0, 30, 0, 0),
              ),
              new Expanded(
                child: new GridView.count(
                    childAspectRatio: 3,
                    primary: false,
                    crossAxisCount: 2,
                    children: amenitiesWidget()),
              ),
              new Container(
                margin: new EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new FlatButton(
                      child: new Text(
                        (room == null || room.filled != "0") ? "" : "DELETE",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Future<bool> dialog = twoButtonDialog(
                            context, "Do you want to delete the room?", "");
                        dialog.then((onValue) {
                          if (onValue) {
                            setState(() {
                              loading = true;
                            });
                            Future<bool> delete = update(
                                API.ROOM,
                                Map.from({'status': '0'}),
                                Map.from({
                                  'hostel_id': hostelID,
                                  'id': room.id,
                                }));
                            delete.then((response) {
                              setState(() {
                                loading = false;
                              });
                              Navigator.pop(context);
                            });
                          }
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        inAsyncCall: loading,
      ),
    );
  }
}
