import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:pgworld/utils/models.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:pie_chart/pie_chart.dart';

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

  DateTime fromDate = DateTime(2017, 11, 22);
  DateTime toDate = DateTime.now();

  List<DateTime> billDates = new List();

  String billDatesRange = "Pick date range";

  @override
  void initState() {
    super.initState();
    fillData();
  }

  void fillData() {
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
          setState(() {
            charts = response;
          });
          updateCharts();
        });
      }
    });
  }

  void updateCharts() {
    setState(() {
      widgets.clear();
    });
    widgets.add(new Container(
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
                            initialFirstDate: new DateTime.now(),
                            initialLastDate:
                                (new DateTime.now()).add(new Duration(days: 7)),
                            firstDate: new DateTime.now()
                                .subtract(new Duration(days: 10 * 365)),
                            lastDate: new DateTime.now()
                                .add(new Duration(days: 10 * 365)));
                    if (picked != null && picked.length == 2) {
                      billDates = picked;
                      setState(() {
                        fromDate = billDates[0];
                        toDate = billDates[1];
                        billDatesRange =
                            headingDateFormat.format(billDates[0]) +
                                " to " +
                                headingDateFormat.format(billDates[1]);
                        fillData();
                      });
                    }
                  },
                  child: new Text(billDatesRange)),
            ),
          ),
        ],
      ),
    ));
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
        if (graph.type == "1") {
          List<Color> colorList = new List();
          Map<String, double> dataMap = new Map();
          graph.data.forEach((data) {
            colorList.add(HexColor(data.color));
            dataMap.putIfAbsent(data.title, () => double.parse(data.value));
          });
          widgets.add(new PieChart(
            dataMap: dataMap,
            legendFontColor: Colors.blueGrey[900],
            legendFontSize: 14.0,
            legendFontWeight: FontWeight.w500,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32.0,
            chartRadius: MediaQuery.of(context).size.width / 2.7,
            showChartValuesInPercentage: true,
            showChartValues: true,
            showChartValuesOutside: true,
            chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
            colorList: colorList,
            showLegends: true,
          ));
        } else {
          List<DataPoint<dynamic>> datapoints = new List();
          graph.data.forEach((data) {
            datapoints.add(DataPoint<DateTime>(
                value: double.parse(data.value),
                xAxis: DateTime.parse(data.title)));
          });
          widgets.add(new Center(
            child: Container(
              color: HexColor(graph.color),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: BezierChart(
                bezierChartScale: BezierChartScale.MONTHLY,
                fromDate: fromDate,
                toDate: toDate,
                selectedDate: toDate,
                series: [
                  BezierLine(
                    label: graph.dataTitle,
                    onMissingValue: (dateTime) {
                      return 0;
                    },
                    data: datapoints,
                  ),
                ],
                config: BezierChartConfig(
                  displayYAxis: true,
                  stepsYAxis: int.parse(graph.steps),
                  verticalIndicatorStrokeWidth: 3.0,
                  verticalIndicatorColor: Colors.black26,
                  showVerticalIndicator: true,
                  verticalIndicatorFixedPosition: true,
                  backgroundColor: HexColor(graph.color),
                  footerHeight: 30.0,
                ),
              ),
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
          // margin: new EdgeInsets.fromLTRB(
          //     MediaQuery.of(context).size.width * 0.1,
          //     25,
          //     MediaQuery.of(context).size.width * 0.1,
          //     0),
          child: loading ? new Container() : new ListView(children: widgets),
        ),
        inAsyncCall: loading,
      ),
    );
  }
}
