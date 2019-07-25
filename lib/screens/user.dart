import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utils/utils.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/models.dart';
import './photo.dart';

class UserActivity extends StatefulWidget {
  final User user;
  final Room room;

  UserActivity(this.user, this.room);

  @override
  State<StatefulWidget> createState() {
    return new UserActivityState(user, room);
  }
}

class UserActivityState extends State<UserActivity> {
  int eating = 0;

  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController emergencyName = new TextEditingController();
  TextEditingController emergencyPhone = new TextEditingController();
  TextEditingController rent = new TextEditingController();
  TextEditingController joiningDate = new TextEditingController();
  TextEditingController roomNo = new TextEditingController();

  String pickedJoiningDate = '';

  User user;
  Room room;

  String roomID;

  bool loading = false;
  List<String> fileNames = new List();
  List<Widget> fileWidgets = new List();
  List<Room> rooms = new List();

  UserActivityState(this.user, this.room);

  bool nameCheck = false;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      name.text = user.name;
      phone.text = user.phone;
      email.text = user.email;
      address.text = user.address;
      emergencyName.text = user.emerContact;
      emergencyPhone.text = user.emerPhone;
      rent.text = user.rent;
      eating = int.parse(user.food);
      if (user.document != null) {
        fileNames = user.document.split(",");
      }
      roomID = user.roomID;
    } else if (room != null) {
      roomID = room.id;
      roomNo.text = room.roomno;
      rent.text = room.rent;
    } else {
      roomID = "";
      roomNo.text = "";
      rent.text = "";
    }
    joiningDate.text = headingDateFormat.format(new DateTime.now());
    pickedJoiningDate = dateFormat.format(new DateTime.now());
    loadDocuments();
    getRoomsIDs();
  }

  void getRoomsIDs() {
    checkInternet().then((internet) {
      if (internet == null || !internet) {
        oneButtonDialog(context, "No Internet connection", "", true);
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = true;
        });
        Map<String, String> filter = new Map();
        filter["limit"] = "10000";
        filter["hostel_id"] = hostelID;
        filter["status"] = "1";
        filter["resp"] = "roomno,id";
        Future<Rooms> data = getRooms(filter);
        data.then((response) {
          if (response.rooms != null) {
            rooms.addAll(response.rooms);
          }
          rooms.forEach((room) {
            if (room.id == roomID) {
              roomNo.text = room.roomno;
            }
          });
          print(rooms.length);
          if (response.meta == null) {
            oneButtonDialog(context, "", "No Internet connection", true);
          } else if (response.meta != null &&
              response.meta.messageType == "1") {
            oneButtonDialog(context, "", response.meta.message,
                !(response.meta.status == STATUS_403));
          }
          setState(() {
            loading = false;
          });
        });
      }
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        loading = true;
      });
      Future<String> uploadResponse = upload(image);
      uploadResponse.then((fileName) {
        if (fileName.isNotEmpty) {
          setState(() {
            fileNames.add(fileName);
            loadDocuments();
          });
        }
        setState(() {
          loading = false;
        });
      });
    }
  }

  void loadDocuments() {
    print(fileNames);
    fileWidgets.clear();
    fileNames.forEach((file) {
      if (file.length > 0) {
        fileWidgets.add(new Row(
          children: <Widget>[
            new IconButton(
              icon: FadeInImage.assetNetwork(
                placeholder: 'assets/image_placeholder.png',
                image: mediaURL + file,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new PhotoActivity(mediaURL + file)),
                );
              },
            ),
            new Expanded(
              child: new IconButton(
                onPressed: () {
                  setState(() {
                    fileNames.remove(file);
                    loadDocuments();
                  });
                },
                icon: new Icon(Icons.delete),
              ),
            )
          ],
        ));
      }
    });
    fileWidgets.add(new Row(
      children: <Widget>[
        new Expanded(
          child: new FlatButton(
            onPressed: () => getImage(),
            child: new Text("Add Document"),
          ),
        )
      ],
    ));
  }

  Future _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().subtract(new Duration(days: 365)),
        lastDate: new DateTime.now().add(new Duration(days: 365)));
    if (picked != null)
      setState(() {
        joiningDate.text = headingDateFormat.format(picked);
        pickedJoiningDate = dateFormat.format(picked);
      });
  }

  Future<String> selectRoom(BuildContext context, List<Room> rooms) async {
    String returned = "";

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Select room"),
          content: new Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: new ListView.builder(
              shrinkWrap: true,
              itemCount: rooms.length,
              itemBuilder: (context, i) {
                return new FlatButton(
                  child: new Text(rooms[i].roomno),
                  onPressed: () {
                    Navigator.of(context).pop();
                    returned = rooms[i].id;

                    roomID = rooms[i].id;
                    roomNo.text = rooms[i].roomno;
                  },
                );
              },
            ),
          ),
        );
      },
    );
    return returned;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: room != null
            ? new Text(
                room.roomno,
                style: TextStyle(color: Colors.black),
              )
            : new Text(
                "User",
                style: TextStyle(color: Colors.black),
              ),
        elevation: 4.0,
        actions: <Widget>[
          new MaterialButton(
            textColor: Colors.white,
            child: user != null
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
              checkInternet().then((internet) {
                if (internet == null || !internet) {
                  oneButtonDialog(context, "No Internet connection", "", true);
                  setState(() {
                    loading = false;
                  });
                } else {
                  if (name.text.length == 0) {
                    setState(() {
                      nameCheck = true;
                      loading = false;
                    });
                    return;
                  } else {
                    setState(() {
                      nameCheck = false;
                    });
                  }

                  Future<bool> load;
                  if (user != null) {
                    load = update(
                      API.USER,
                      Map.from({
                        'name': name.text,
                        'phone': phone.text,
                        'email': email.text,
                        'address': address.text,
                        'emer_contact': emergencyName.text,
                        'emer_phone': emergencyPhone.text,
                        'food': eating.toString(),
                        'rent': rent.text,
                        'document': fileNames.join(","),
                        'room_id': roomID,
                        'prev_room_id': user.roomID,
                      }),
                      Map.from({'hostel_id': hostelID, 'id': user.id}),
                    );
                  } else {
                    load = add(
                      API.USER,
                      Map.from({
                        'hostel_id': hostelID,
                        'name': name.text,
                        'phone': phone.text,
                        'email': email.text,
                        'address': address.text,
                        'emer_contact': emergencyName.text,
                        'emer_phone': emergencyPhone.text,
                        'food': eating.toString(),
                        'room_id': roomID,
                        'rent': rent.text,
                        'document': fileNames.join(","),
                        'joining_date_time': pickedJoiningDate
                      }),
                    );
                  }
                  load.then((onValue) {
                    setState(() {
                      loading = false;
                    });
                    if (user != null) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context, "");
                    }
                  });
                }
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
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      height: nameCheck ? null : 50,
                      child: new TextField(
                          controller: name,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: nameCheck
                                ? IconButton(
                                    icon: Icon(Icons.error, color: Colors.red),
                                    onPressed: () {},
                                  )
                                : null,
                            errorText: nameCheck ? "Name required" : null,
                            isDense: true,
                            prefixIcon: Icon(Icons.account_circle),
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                          ),
                          onSubmitted: (String value) {}),
                    ),
                  ),
                ],
              ),
              // rooms.length > 0
              //     ? new Container(
              //         color: Colors.transparent,
              //         height: 50,
              //         margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
              //         child: new Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: <Widget>[
              //             new Expanded(
              //               child: new DropdownButton(
              //                 isExpanded: true,
              //                 items: rooms.map((room) {
              //                   return new DropdownMenuItem(
              //                       child: new Container(
              //                         constraints:
              //                             BoxConstraints(maxWidth: 200),
              //                         child: new Text(
              //                           room.roomno,
              //                           overflow: TextOverflow.clip,
              //                         ),
              //                       ),
              //                       value: room.id);
              //                 }).toList(),
              //                 onChanged: (value) {
              //                   setState(() {
              //                     roomID = room.id;
              //                     roomNo.text = room.roomno;
              //                   });
              //                 },
              //                 value: room.id,
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     : new Container(),
              new GestureDetector(
                onTap: () {
                  selectRoom(context, rooms);
                },
                child: new Container(
                  color: Colors.transparent,
                  height: 50,
                  margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Expanded(
                        child: new Container(
                          child: new TextField(
                            enabled: false,
                            controller: roomNo,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                              labelText: 'Room No.',
                            ),
                            onSubmitted: (String value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new Container(
                height: 50,
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        child: new TextField(
                          controller: rent,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Icon(Icons.attach_money),
                            border: OutlineInputBorder(),
                            labelText: 'Rent',
                          ),
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                height: 50,
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        child: new TextField(
                          controller: phone,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                            labelText: 'Phone',
                          ),
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                height: 50,
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        child: new TextField(
                          controller: email,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                // height: 50,
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        child: new TextField(
                          controller: address,
                          maxLines: 5,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Icon(Icons.location_on),
                            border: OutlineInputBorder(),
                            labelText: 'Address',
                          ),
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
                      child: new Text("Document"),
                    ),
                    new Expanded(
                      child: new Container(
                          margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: new Column(
                            children: fileWidgets,
                          )),
                    ),
                  ],
                ),
              ),
              new Container(
                height: 50,
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        child: new TextField(
                          controller: emergencyName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Icon(Icons.account_circle),
                            border: OutlineInputBorder(),
                            labelText: 'Emergency Contact Name',
                          ),
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                height: 50,
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        child: new TextField(
                          controller: emergencyPhone,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Icon(Icons.contact_phone),
                            border: OutlineInputBorder(),
                            labelText: 'Emergency Contact Number',
                          ),
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              user == null
                  ? new GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: new Container(
                        color: Colors.transparent,
                        height: 50,
                        margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Expanded(
                              child: new Container(
                                child: new TextField(
                                  enabled: false,
                                  controller: joiningDate,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    prefixIcon: Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(),
                                    labelText: 'Joining Date',
                                  ),
                                  onSubmitted: (String value) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : new Container(),
              new Container(
                margin: new EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Radio(
                      value: 0,
                      groupValue: eating,
                      onChanged: (value) {
                        setState(() {
                          eating = value;
                        });
                      },
                    ),
                    new Text("Veg"),
                    new Radio(
                      value: 1,
                      groupValue: eating,
                      onChanged: (value) {
                        setState(() {
                          eating = value;
                        });
                      },
                    ),
                    new Text("Non Veg"),
                  ],
                ),
              ),
              user != null
                  ? new Container(
                      margin: new EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new FlatButton(
                            child: new Text(
                              "DELETE",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Future<bool> dialog = twoButtonDialog(
                                  context,
                                  "Do you want to remove the user from hostel?",
                                  "");
                              dialog.then((onValue) {
                                if (onValue) {
                                  setState(() {
                                    loading = true;
                                  });
                                  Future<bool> deleteResquest = delete(
                                      API.USER,
                                      Map.from({
                                        'hostel_id': hostelID,
                                        'id': user.id,
                                        'room_id': user.roomID,
                                      }));
                                  deleteResquest.then((response) {
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
                    )
                  : new Container(),
            ],
          ),
        ),
        inAsyncCall: loading,
      ),
    );
  }
}
