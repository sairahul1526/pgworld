import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utils/utils.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/models.dart';
import './photo.dart';

class EmployeeActivity extends StatefulWidget {
  final Employee employee;

  EmployeeActivity(this.employee);

  @override
  State<StatefulWidget> createState() {
    return new EmployeeActivityState(employee);
  }
}

class EmployeeActivityState extends State<EmployeeActivity> {
  TextEditingController name = new TextEditingController();
  TextEditingController designation = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController salary = new TextEditingController();

  String joiningDate = '';

  Employee employee;

  bool loading = false;
  List<String> fileNames = new List();
  List<Widget> fileWidgets = new List();

  EmployeeActivityState(this.employee);

  @override
  void initState() {
    super.initState();
    if (employee != null) {
      name.text = employee.name;
      designation.text = employee.designation;
      phone.text = employee.phone;
      email.text = employee.email;
      address.text = employee.address;
      salary.text = employee.salary;
      if (employee.document != null) {
        fileNames = employee.document.split(",");
      }
      loadDocuments();
    } else {
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
    if (picked != null) setState(() => joiningDate = dateFormat.format(picked));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Employee"),
        elevation: 4.0,
        actions: <Widget>[
          new MaterialButton(
            textColor: Colors.white,
            child: employee != null ? new Text("SAVE") : new Text("ADD"),
            onPressed: () {
              setState(() {
                loading = true;
              });
              Future<bool> load;
              if (employee != null) {
                load = update(
                  API.EMPLOYEE,
                  Map.from({
                    'name': name.text,
                    'designation': designation.text,
                    'phone': phone.text,
                    'email': email.text,
                    'address': address.text,
                    'salary': salary.text,
                    'document': fileNames.join(","),
                  }),
                  Map.from({'hostel_id': hostelID, 'id': employee.id}),
                );
              } else {
                load = add(
                  API.EMPLOYEE,
                  Map.from({
                    'hostel_id': hostelID,
                    'name': name.text,
                    'designation': designation.text,
                    'phone': phone.text,
                    'email': email.text,
                    'address': address.text,
                    'salary': salary.text,
                    'joining_date_time': joiningDate,
                    'document': fileNames.join(","),
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
                      child: new Text("Designation"),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: new TextField(
                          controller: designation,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(hintText: 'Designation'),
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
                      child: new Text("Salary"),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: new TextField(
                          controller: salary,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Salary'),
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
              employee != null
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
                    new FlatButton(
                      child: new Text(
                        (employee == null) ? "" : "DELETE",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Future<bool> dialog = twoButtonDialog(
                            context, "Do you want to delete the employee?", "");
                        dialog.then((onValue) {
                          if (onValue) {
                            setState(() {
                              loading = true;
                            });
                            Future<bool> delete = update(
                                API.EMPLOYEE,
                                Map.from({'status': '0'}),
                                Map.from({
                                  'hostel_id': hostelID,
                                  'id': employee.id,
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
