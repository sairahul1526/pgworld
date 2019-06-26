import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utils/utils.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/models.dart';

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

  String joiningDate = '';

  User user;
  Room room;

  bool loading = false;
  List<String> fileNames = new List();
  List<Widget> fileWidgets = new List();

  UserActivityState(this.user, this.room);

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
      loadDocuments();
    } else {
      rent.text = room.rent;
      joiningDate = dateFormat.format(new DateTime.now());
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Future<String> uploadResponse = upload(image);
      uploadResponse.then((fileName) {
        if (fileName.isNotEmpty) {
          setState(() {
            fileNames.add(fileName);
            loadDocuments();
          });
        }
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
              icon: new Image.network(mediaURL + file),
              onPressed: () => getImage(),
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
    if (picked != null) setState(() => joiningDate = dateFormat.format(picked));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: room != null ? new Text(room.roomno) : new Text("User"),
        elevation: 4.0,
        actions: <Widget>[
          new MaterialButton(
            textColor: Colors.white,
            child: user != null ? new Text("SAVE") : new Text("ADD"),
            onPressed: () {
              setState(() {
                loading = true;
              });
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
                    'room_id': room.id,
                    'rent': rent.text,
                    'room_id': room.id,
                    'document': fileNames.join(","),
                    'joining_date_time': joiningDate
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
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: new Text("Name"),
                  ),
                  new Expanded(
                    child: new Container(
                      margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: new TextField(
                          controller: name,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(hintText: 'Name'),
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
                      child: new Text("Rent"),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: new TextField(
                          controller: rent,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: room != null ? room.rent : 'Rent'),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: new Text("Phone"),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: new TextField(
                          controller: phone,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Phone'),
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
                      child: new Text("Email"),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: new TextField(
                          controller: email,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(hintText: 'Email'),
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
                      child: new Text("Address"),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: new TextField(
                          controller: address,
                          maxLines: 5,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(hintText: 'Address'),
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
                      child: new Text("Emergency Contact Name"),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: new TextField(
                          controller: emergencyName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: 'Emergency Contact Name'),
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
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: new Text("Emergency Contact Number"),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: new TextField(
                          controller: emergencyPhone,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: 'Emergency Contact Number'),
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              user != null
                  ? new Text("")
                  : new Container(
                      margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: new Text("Joining Date"),
                          ),
                          new Expanded(
                            child: new Container(
                              margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new FlatButton(
                                      onPressed: () => _selectDate(context),
                                      child: new Text(joiningDate),
                                    ),
                                  ),
                                  new FlatButton.icon(
                                      onPressed: () => _selectDate(context),
                                      icon: new Icon(Icons.date_range),
                                      label: new Text(""))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
            ],
          ),
        ),
        inAsyncCall: loading,
      ),
    );
  }
}
