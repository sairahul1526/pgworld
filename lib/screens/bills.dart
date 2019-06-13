import 'package:flutter/material.dart';

import './bill.dart';
import './billFilter.dart';
import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/utils.dart';

class BillsActivity extends StatefulWidget {
  final Employee employee;
  final User user;

  BillsActivity(this.user, this.employee);
  @override
  BillsActivityState createState() {
    return new BillsActivityState(user, employee);
  }
}

class BillsActivityState extends State<BillsActivity> {
  User user;
  Employee employee;

  BillsActivityState(this.user, this.employee);

  List<Bill> bills = new List();

  Map<String, String> filter = new Map();

  @override
  void initState() {
    super.initState();

    if (user != null) {
      filter["user_id"] = user.id;
    } else if (employee != null) {
      filter["employee_id"] = employee.id;
    }
    filter["status"] = "1";
    filter["hostel_id"] = hostelID;

    // fillData2();
  }

  void fillData2() {
    Future<Bills> billsResponse = getBills(user != null
        ? Map.from({'hostel_id': hostelID, 'user_id': user.id, 'status': '1'})
        : (employee != null
            ? Map.from({
                'hostel_id': hostelID,
                'employee_id': employee.id,
                'status': '1'
              })
            : Map.from({'hostel_id': hostelID, 'status': '1'})));
    billsResponse.then((response) {
      setState(() {
        bills.addAll(response.bills);
      });
    });
  }

  Widget fillData() => new FutureBuilder<Bills>(
        future: getBills(filter),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.meta.messageType == "4") {
              return new Center(
                  child: popDialog(context, "App Update Required", true));
            }
            return bodyData(snapshot.data.bills);
          } else if (snapshot.hasError) {
            return new Center(child: popDialog(context, "Network Error", true));
          }
          return new Center(child: showProgress("loading..."));
        },
      );

  Widget bodyData(List<Bill> bills) => new DataTable(
      onSelectAll: (b) {},
      sortAscending: true,
      columns: <DataColumn>[
        new DataColumn(
          label: new Text(""),
        ),
        new DataColumn(
          label: new Text("Item"),
        ),
        new DataColumn(
          label: new Text("Amount"),
          // onSort: (i, b) {
          //   print("$i $b");
          //   setState(() {
          //     bills.sort((a, b) => a.amount.compareTo(b.amount));
          //   });
          // },
        ),
        new DataColumn(
          label: new Text("Date"),
        ),
      ],
      rows: bills
          .map(
            (bill) => new DataRow(
                  cells: [
                    new DataCell(
                        new Radio(
                          value: 0,
                          groupValue: 1,
                          onChanged: (value) => {},
                        ), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => user != null
                                ? new BillActivity(bill, user, null)
                                : (employee != null
                                    ? new BillActivity(bill, null, employee)
                                    : new BillActivity(bill, null, null))),
                      );
                    }),
                    new DataCell(new Text(bill.title), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => user != null
                                ? new BillActivity(bill, user, null)
                                : (employee != null
                                    ? new BillActivity(bill, null, employee)
                                    : new BillActivity(bill, null, null))),
                      );
                    }),
                    new DataCell(Text(bill.amount), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => user != null
                                ? new BillActivity(bill, user, null)
                                : (employee != null
                                    ? new BillActivity(bill, null, employee)
                                    : new BillActivity(bill, null, null))),
                      );
                    }),
                    new DataCell(Text(bill.amount), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => user != null
                                ? new BillActivity(bill, user, null)
                                : (employee != null
                                    ? new BillActivity(bill, null, employee)
                                    : new BillActivity(bill, null, null))),
                      );
                    })
                  ],
                ),
          )
          .toList());

  filterPage(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as Map<String, String>;

    if (data != null) {
      if (user != null) {
        filter = Map.from(
            {'hostel_id': hostelID, 'user_id': user.id, 'status': '1'});
      } else if (employee != null) {
        Map.from(
            {'hostel_id': hostelID, 'employee_id': employee.id, 'status': '1'});
      } else {
        Map.from({'hostel_id': hostelID, 'status': '1'});
      }

      if (user != null) {
        data["user_id"] = user.id;
      } else if (employee != null) {
        data["employee_id"] = employee.id;
      }
      data["status"] = "1";
      data["hostel_id"] = hostelID;
      print(data);
      setState(() {
        filter = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
              user != null ? "Rents" : (employee != null ? "Salary" : "Bills")),
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                filterPage(context, new BillFilterActivity());
              },
              icon: new Icon(Icons.filter_list),
            ),
            new IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => user != null
                          ? new BillActivity(null, user, null)
                          : (employee != null
                              ? new BillActivity(null, null, employee)
                              : new BillActivity(null, null, null))),
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
              children: <Widget>[fillData()],
            ),
          ),
        ));
  }
}
