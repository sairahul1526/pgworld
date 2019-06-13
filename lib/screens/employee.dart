import 'package:flutter/material.dart';

import '../utils/utils.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/models.dart';

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
    } else {
      joiningDate = dateFormat.format(new DateTime.now());
    }
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
              if (employee != null) {
                Future<bool> load = update(
                  API.EMPLOYEE,
                  Map.from({
                    'name': name.text,
                    'designation': designation.text,
                    'phone': phone.text,
                    'email': email.text,
                    'address': address.text,
                    'salary': salary.text
                  }),
                  Map.from({'hostel_id': hostelID, 'id': employee.id}),
                );
                load.then((onValue) {
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                });
              } else {
                Future<bool> load = add(
                  API.EMPLOYEE,
                  Map.from({
                    'hostel_id': hostelID,
                    'name': name.text,
                    'designation': designation.text,
                    'phone': phone.text,
                    'email': email.text,
                    'address': address.text,
                    'salary': salary.text,
                    'joining_date_time': joiningDate
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
                              decoration:
                                  InputDecoration(hintText: 'Designation'),
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
                ],
              ),
            ),
    );
  }
}
