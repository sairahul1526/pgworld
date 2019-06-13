import 'package:flutter/material.dart';

import './employee.dart';
import './bills.dart';
import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/utils.dart';

class EmployeesActivity extends StatefulWidget {
  @override
  EmployeesActivityState createState() {
    return new EmployeesActivityState();
  }
}

class EmployeesActivityState extends State<EmployeesActivity> {
  Widget fillData() => new FutureBuilder<Employees>(
        future: getEmployees(Map.from({'hostel_id': hostelID, 'status': '1'})),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.meta.messageType == "4") {
              return new Center(
                  child: popDialog(context, "App Update Required", true));
            }
            return bodyData(snapshot.data.employees);
          } else if (snapshot.hasError) {
            return new Center(child: popDialog(context, "Network Error", true));
          }
          return new Center(child: showProgress("loading..."));
        },
      );

  Widget bodyData(List<Employee> employees) => new DataTable(
      onSelectAll: (b) {},
      sortAscending: true,
      columns: <DataColumn>[
        new DataColumn(
          label: new Text("Name"),
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              employees.sort((a, b) => a.name.compareTo(b.name));
            });
          },
        ),
        new DataColumn(
          label: new Text("Salary"),
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              employees.sort((a, b) => a.salary.compareTo(b.salary));
            });
          },
        ),
        new DataColumn(
          label: new Text("Phone"),
        ),
      ],
      rows: employees
          .map(
            (employee) => new DataRow(
                  cells: [
                    new DataCell(Text(employee.name), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new EmployeeActivity(employee)),
                      );
                    }),
                    new DataCell(Text(employee.salary), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new BillsActivity(null, employee)),
                      );
                    }),
                    new DataCell(Text(employee.phone), onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new EmployeeActivity(employee)),
                      );
                    })
                  ],
                ),
          )
          .toList());

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Employees"),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new EmployeeActivity(null)),
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
      ),
    );
  }
}
