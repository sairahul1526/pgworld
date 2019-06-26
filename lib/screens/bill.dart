import 'package:flutter/material.dart';

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

  String paidDate = '';
  String expiryDate = '';

  Bill bill;
  User user;
  Employee employee;

  bool loading = false;

  BillActivityState(this.bill, this.user, this.employee);

  @override
  void initState() {
    super.initState();
    if (user != null) {
      amount.text = user.rent;
      paidDate = dateFormat.format(new DateTime.now());
      expiryDate =
          dateFormat.format(new DateTime.now().add(new Duration(days: 30)));
      if (bill != null) {
        amount.text = bill.amount;
        paidDate = bill.paidDateTime;
        expiryDate = user.expiryDateTime;
      }
    } else if (employee != null) {
      amount.text = employee.salary;
      if (bill != null) {
        amount.text = bill.amount;
        paidDate = bill.paidDateTime;
        expiryDate = employee.expiryDateTime;
      }
    } else if (bill != null) {
      item.text = bill.title;
      paidDate = bill.paidDateTime;
      description.text = bill.description;
      amount.text = bill.amount;
      paid = int.parse(bill.paid);
    } else {
      paidDate = dateFormat.format(new DateTime.now());
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
          paidDate = dateFormat.format(picked);
        } else {
          expiryDate = dateFormat.format(picked);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            user != null ? "Rent" : (employee != null ? "Salary" : "Bill")),
        elevation: 4.0,
        actions: <Widget>[
          new MaterialButton(
            textColor: Colors.white,
            child: new Text(bill != null
                ? "SAVE"
                : (user != null
                    ? "RECEIVE"
                    : (employee != null ? "PAY" : "ADD"))),
            onPressed: () {
              setState(() {
                loading = true;
              });

              print("recieve clicked");

              Future<bool> load;
              if (user != null) {
                print("user not null");
                load = add(
                  API.RENT,
                  Map.from({
                    'paid_date_time': paidDate,
                    'amount': amount.text,
                    'title': 'Rent',
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
                    'paid_date_time': paidDate,
                    'amount': amount.text,
                    'title': 'Salary',
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
                    'paid_date_time': paidDate,
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
                    'paid_date_time': paidDate,
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
      body: new Container(
        margin: new EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1,
            25, MediaQuery.of(context).size.width * 0.1, 0),
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            (user == null && employee == null)
                ? new Row(
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: new Text("Item"),
                      ),
                      new Expanded(
                        child: new Container(
                          margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: new TextField(
                              controller: item,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: 'Item'),
                              onSubmitted: (String value) {}),
                        ),
                      ),
                    ],
                  )
                : new Text(""),
            (user == null && employee == null)
                ? new Container(
                    margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: new Text("Description"),
                        ),
                        new Flexible(
                          child: new Container(
                            margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: new TextField(
                              controller: description,
                              maxLines: 5,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              decoration:
                                  InputDecoration(hintText: 'Description'),
                              onSubmitted: (String value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : new Text(""),
            new Container(
              margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: new Text("Amount"),
                  ),
                  new Flexible(
                    child: new Container(
                      margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: new TextField(
                        controller: amount,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Amount'),
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
                    child: new Text("Payment Date"),
                  ),
                  new Expanded(
                    child: new Container(
                      margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new FlatButton(
                              onPressed: () => _selectDate(context, '1'),
                              child: new Text(paidDate),
                            ),
                          ),
                          new FlatButton.icon(
                              onPressed: () => _selectDate(context, '1'),
                              icon: new Icon(Icons.date_range),
                              label: new Text(""))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (user != null || employee != null)
                ? new Container(
                    margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: new Text("Next Payment Date"),
                        ),
                        new Expanded(
                          child: new Container(
                            margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new FlatButton(
                                    onPressed: () => _selectDate(context, '2'),
                                    child: new Text(expiryDate),
                                  ),
                                ),
                                new FlatButton.icon(
                                    onPressed: () => _selectDate(context, '2'),
                                    icon: new Icon(Icons.date_range),
                                    label: new Text(""))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : new Text(""),
            (user == null && employee == null)
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
    );
  }
}
