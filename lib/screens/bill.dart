import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/models.dart';
import '../utils/utils.dart';

class BillActivity extends StatefulWidget {
  final Bill bill;
  final User user;
  final Employee employee;

  BillActivity(this.bill, this.user, this.employee);

  @override
  State<StatefulWidget> createState() {
    return new BillActivityState(bill, user, employee);
  }
}

class BillActivityState extends State<BillActivity> {
  int paid = 0;

  TextEditingController item = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController amount = new TextEditingController();
  TextEditingController paidDate = new TextEditingController();
  TextEditingController expiryDate = new TextEditingController();

  String pickedPaidDate = '';
  String pickedExpiryDate = '';

  Bill bill;
  User user;
  Employee employee;

  bool loading = false;

  BillActivityState(this.bill, this.user, this.employee);

  @override
  void initState() {
    super.initState();
    expiryDate.text = headingDateFormat
        .format(new DateTime.now().add(new Duration(days: 30)));
    pickedExpiryDate =
        dateFormat.format(new DateTime.now().add(new Duration(days: 30)));
    if (user != null) {
      amount.text = user.rent;
      paidDate.text = headingDateFormat.format(new DateTime.now());
      pickedPaidDate = dateFormat.format(new DateTime.now());
      if (bill != null) {
        amount.text = bill.amount;
        paidDate.text =
            headingDateFormat.format(DateTime.parse(bill.paidDateTime));
        pickedPaidDate = dateFormat.format(DateTime.parse(bill.paidDateTime));
      }
    } else if (employee != null) {
      amount.text = employee.salary;
      paidDate.text = headingDateFormat.format(new DateTime.now());
      pickedPaidDate = dateFormat.format(new DateTime.now());
      dateFormat.format(new DateTime.now());
      if (bill != null) {
        amount.text = bill.amount;
        paidDate.text =
            headingDateFormat.format(DateTime.parse(bill.paidDateTime));
        pickedPaidDate = dateFormat.format(DateTime.parse(bill.paidDateTime));
      }
    } else if (bill != null) {
      item.text = bill.title;
      paidDate.text =
          headingDateFormat.format(DateTime.parse(bill.paidDateTime));
      pickedPaidDate = dateFormat.format(DateTime.parse(bill.paidDateTime));
      description.text = bill.description;
      amount.text = bill.amount;
      paid = int.parse(bill.paid);
    } else {
      paidDate.text = dateFormat.format(new DateTime.now());
      pickedPaidDate = dateFormat.format(new DateTime.now());
    }
  }

  Future _selectDate(BuildContext context, String type) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().subtract(new Duration(days: 365)),
        lastDate: new DateTime.now().add(new Duration(days: 365)));
    if (picked != null)
      setState(() {
        if (type == '1') {
          paidDate.text = headingDateFormat.format(picked);
          pickedPaidDate = dateFormat.format(picked);
        } else {
          expiryDate.text = headingDateFormat.format(picked);
          pickedExpiryDate = dateFormat.format(picked);
        }
      });
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
          user != null ? "Rent" : (employee != null ? "Salary" : "Bill"),
          style: TextStyle(color: Colors.black),
        ),
        elevation: 4.0,
        actions: <Widget>[
          new MaterialButton(
            textColor: Colors.white,
            child: new Text(
              bill != null
                  ? "SAVE"
                  : (user != null
                      ? "RECEIVE"
                      : (employee != null ? "PAY" : "ADD")),
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              setState(() {
                loading = true;
              });

              Future<bool> load;
              if (user != null) {
                load = add(
                  API.RENT,
                  Map.from({
                    'paid_date_time': pickedPaidDate,
                    'amount': amount.text,
                    'title': 'Rent',
                    'name': user.name,
                    'description':
                        user.name + ' paid rent for room ' + user.roomID,
                    'hostel_id': hostelID,
                    'user_id': user.id,
                    'bill_id': bill != null ? bill.id : "",
                    'paid': '0'
                  }),
                );
              } else if (employee != null) {
                load = add(
                  API.SALARY,
                  Map.from({
                    'paid_date_time': pickedPaidDate,
                    'amount': amount.text,
                    'title': 'Salary',
                    'name': employee.name,
                    'description': employee.name + ' salary paid',
                    'hostel_id': hostelID,
                    'employee_id': employee.id,
                    'bill_id': bill != null ? bill.id : "",
                    'paid': '1'
                  }),
                );
              } else if (bill != null) {
                load = update(
                  API.BILL,
                  Map.from({
                    'paid_date_time': pickedPaidDate,
                    "title": item.text,
                    "description": description.text,
                    "amount": amount.text,
                    "paid": paid.toString(),
                  }),
                  Map.from({'hostel_id': hostelID, 'id': bill.id}),
                );
              } else {
                load = add(
                  API.BILL,
                  Map.from({
                    'hostel_id': hostelID,
                    'title': item.text,
                    'paid_date_time': pickedPaidDate,
                    'description': description.text,
                    'amount': amount.text,
                    'paid': paid.toString()
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
              (bill == null
                      ? (user == null && employee == null)
                      : (bill.userID == "" && bill.employeeID == ""))
                  ? new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Container(
                            height: 50,
                            child: new TextField(
                                controller: item,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: Icon(Icons.label),
                                  border: OutlineInputBorder(),
                                  labelText: 'Title',
                                ),
                                onSubmitted: (String value) {}),
                          ),
                        ),
                      ],
                    )
                  : new Text(""),
              (bill == null
                      ? (user == null && employee == null)
                      : (bill.userID == "" && bill.employeeID == ""))
                  ? new Container(
                      height: 50,
                      margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Flexible(
                            child: new Container(
                              child: new TextField(
                                controller: description,
                                maxLines: 5,
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: Icon(Icons.description),
                                  border: OutlineInputBorder(),
                                  labelText: 'Description',
                                ),
                                onSubmitted: (String value) {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : new Text(""),
              new Container(
                height: 50,
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Flexible(
                      child: new Container(
                        child: new TextField(
                          controller: amount,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Icon(Icons.attach_money),
                            border: OutlineInputBorder(),
                            labelText: 'Amount',
                          ),
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new GestureDetector(
                onTap: () {
                  _selectDate(context, '1');
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
                            controller: paidDate,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                              labelText: 'Payment Date',
                            ),
                            onSubmitted: (String value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (bill == null && (user != null || employee != null))
                  ? new GestureDetector(
                      onTap: () {
                        _selectDate(context, '2');
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
                                  controller: expiryDate,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    prefixIcon: Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(),
                                    labelText: 'Next Payment Date',
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
              (bill == null
                      ? (user == null && employee == null)
                      : (bill.userID == "" && bill.employeeID == ""))
                  ? new Container(
                      margin: new EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Radio(
                            value: 1,
                            groupValue: paid,
                            onChanged: (value) {
                              setState(() {
                                paid = value;
                              });
                            },
                          ),
                          new Text("Paid"),
                          new Radio(
                            value: 0,
                            groupValue: paid,
                            onChanged: (value) {
                              setState(() {
                                paid = value;
                              });
                            },
                          ),
                          new Text("Received"),
                        ],
                      ),
                    )
                  : new Text(""),
              new Container(
                margin: new EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new FlatButton(
                      child: new Text(
                        (bill == null) ? "" : "DELETE",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Future<bool> dialog = twoButtonDialog(
                            context, "Do you want to delete the bill?", "");
                        dialog.then((onValue) {
                          if (onValue) {
                            setState(() {
                              loading = true;
                            });
                            Future<bool> delete = update(
                                API.BILL,
                                Map.from({'status': '0'}),
                                Map.from({
                                  'hostel_id': hostelID,
                                  'id': bill.id,
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
