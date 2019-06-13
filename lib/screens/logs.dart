import 'package:flutter/material.dart';

import '../utils/models.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/utils.dart';

class LogsActivity extends StatefulWidget {
  LogsActivity();
  @override
  LogsActivityState createState() {
    return new LogsActivityState();
  }
}

class LogsActivityState extends State<LogsActivity> {
  LogsActivityState();

  Widget fillData() => new FutureBuilder<Logs>(
        future: getLogs(Map.from({'hostel_id': hostelID, 'status': '1'})),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.meta.messageType == "4") {
              return new Center(
                  child: popDialog(context, "App Update Required", true));
            }
            return bodyData(snapshot.data.logs);
          } else if (snapshot.hasError) {
            return new Center(child: popDialog(context, "Network Error", true));
          }
          return new Center(child: showProgress("loading..."));
        },
      );

  Widget bodyData(List<Log> logs) => new DataTable(
      onSelectAll: (b) {},
      sortAscending: true,
      columns: <DataColumn>[
        new DataColumn(
          label: new Text("Log"),
        ),
        new DataColumn(
          label: new Text("Date"),
        ),
      ],
      rows: logs
          .map(
            (log) => new DataRow(
                  cells: [
                    new DataCell(Text(log.log), onTap: () {}),
                    new DataCell(Text(log.createdDateTime), onTap: () {})
                  ],
                ),
          )
          .toList());

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Logs"),
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
