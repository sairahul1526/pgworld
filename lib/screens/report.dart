import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import '../utils/models.dart';
import 'package:charts_flutter/flutter.dart' as charty;

import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utils/config.dart';
import '../utils/api.dart';
import '../utils/utils.dart';

class ReportActivity extends StatefulWidget {
  ReportActivity();
  @override
  State<StatefulWidget> createState() {
    return new ReportActivityState();
  }
}

class ReportActivityState extends State<ReportActivity> {
  Charts charts = new Charts();

  List<Widget> widgets = new List();

  bool loading = true;

  DateTime fromDate = new DateTime.now().add(new Duration(days: -6*30));
  DateTime toDate = DateTime.now();

  List<DateTime> billDates = new List();

  String billDatesRange = "Pick date range";

  @override
  void initState() {
    super.initState();
    fillData();
  }

  void fillData() {
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
        Map<String, String> filter = new Map();
        filter["hostel_id"] = hostelID;
        filter["from"] = dateFormat.format(fromDate);
        filter["to"] = dateFormat.format(toDate);
        Future<Charts> data = getReports(filter);
        data.then((response) {
          if (response.meta != null && response.meta.messageType == "1") {
            oneButtonDialog(context, "", response.meta.message,
                !(response.meta.status == STATUS_403));
          }
          setState(() {
            charts = response;
          });
          updateCharts();
        });
      }
    });
  }

  void updateCharts() {
    widgets.clear();
    if (charts.graphs != null) {
      charts.graphs.forEach((graph) {
        widgets.add(new Container(
          margin: EdgeInsets.only(top: 50),
          child: new Text(
            graph.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));

        widgets.add(new Container(
          child: new Container(
            height: 20,
          ),
        ));

        List<charty.Series<OrdinalSales, String>> seriesList = [];
        graph.data.forEach((d2) {
          List<OrdinalSales> data = [];

          d2.data.forEach((f) {
            data.add(new OrdinalSales(f.title, int.parse(f.value)));
          });

          seriesList.add(new charty.Series<OrdinalSales, String>(
            id: d2.title,
            // colorFn: (_, __) => HexColor(""),
            domainFn: (OrdinalSales sales, _) => sales.year,
            measureFn: (OrdinalSales sales, _) => sales.sales,
            data: data,
            labelAccessorFn: (OrdinalSales row, _) => '${row.sales}',
          ));
        });

        if (graph.type == "1") {
          // pie
          widgets.add(new Container(
            height: 250,
            child: new charty.PieChart(seriesList,
                animate: true,
                behaviors: [new charty.DatumLegend()],
                defaultRenderer: new charty.ArcRendererConfig(
                    arcWidth: 60,
                    arcRendererDecorators: [new charty.ArcLabelDecorator()])),
          ));
        } else if (graph.type == "2") {
          // stacked
          widgets.add(new Container(
            height: 300,
            child: new charty.BarChart(
              seriesList,
              animate: true,
              barGroupingType: charty.BarGroupingType.grouped,
              behaviors: [new charty.SeriesLegend()],
            ),
          ));
        }
      });
    }
    setState(() {
      loading = false;
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
          "REPORTS",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 4.0,
      ),
      body: ModalProgressHUD(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.1,
              0,
              MediaQuery.of(context).size.width * 0.1,
              0),
          child: loading
              ? new Container()
              : new Column(
                  children: <Widget>[
                    new Container(
                      height: 50,
                      margin: new EdgeInsets.fromLTRB(15, 15, 0, 0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: new Text("Bill Date"),
                          ),
                          new Flexible(
                            child: new Container(
                              margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: new FlatButton(
                                  onPressed: () async {
                                    final List<DateTime> picked =
                                        await DateRagePicker.showDatePicker(
                                            context: context,
                                            initialFirstDate:
                                                (new DateTime.now())
                                                    .add(new Duration(days: -6*30)),
                                            initialLastDate:
                                                (new DateTime.now())
                                                    .add(new Duration(days: 1)),
                                            firstDate: new DateTime.now()
                                                .subtract(new Duration(
                                                    days: 10 * 365)),
                                            lastDate: new DateTime.now().add(
                                                new Duration(days: 10 * 365)));
                                    if (picked != null && picked.length == 2) {
                                      billDates = picked;
                                      setState(() {
                                        fromDate = billDates[0];
                                        toDate = billDates[1];
                                        billDatesRange = headingDateFormat
                                                .format(billDates[0]) +
                                            " to " +
                                            headingDateFormat
                                                .format(billDates[1]);
                                      });
                                      fillData();
                                    }
                                  },
                                  child: new Text(billDatesRange)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Expanded(
                      child: new ListView(
                        children: widgets,
                      ),
                    )
                  ],
                ),
        ),
        inAsyncCall: loading,
      ),
    );
  }
}
