import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:pgworld/utils/indicator.dart';
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
  final Color leftBarColor = Color(0xff53fdd7);
  final Color rightBarColor = Color(0xffff5182);
  double width = 7;

  Charts charts = new Charts();

  List<Widget> widgets = new List();

  bool loading = true;

  final fromDate = DateTime(2018, 11, 22);
  final toDate = DateTime.now();

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

  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  void updateCharts() {
    if (charts.graphs != null) {
      charts.graphs.forEach((graph) {
        widgets.add(new Container(
          child: new Text(graph.title),
        ));
        if (graph.type == "1") {
          Map<String, double> dataMap = new Map();
          graph.data.forEach((data) {
            dataMap.putIfAbsent(data.title, () => 5);
          });
          widgets.add(new PieChart(
            dataMap: dataMap, //Required parameter
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
            print(DateTime.parse(data.title));
            datapoints.add(DataPoint<DateTime>(
                value: double.parse(data.value),
                xAxis: DateTime.parse(data.title)));
          });
          widgets.add(new Center(
            child: Container(
              color: Colors.red,
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: BezierChart(
                bezierChartScale: BezierChartScale.MONTHLY,
                fromDate: fromDate,
                toDate: toDate,
                selectedDate: toDate,
                series: [
                  BezierLine(
                    label: "dasd",
                    onMissingValue: (dateTime) {
                      if (dateTime.month.isEven) {
                        return 10.0;
                      }
                      return 5.0;
                    },
                    data: datapoints,
                  ),
                ],
                config: BezierChartConfig(
                  verticalIndicatorStrokeWidth: 3.0,
                  verticalIndicatorColor: Colors.black26,
                  showVerticalIndicator: true,
                  verticalIndicatorFixedPosition: true,
                  backgroundColor: Colors.red,
                  footerHeight: 30.0,
                ),
              ),
            ),
          ));
        }
      });
    }
    // // pies
    // if (charts.pies != null) {
    //   charts.pies.forEach((pie) {
    //     List<PieChartSectionData> sections = [];
    //     List<Widget> titles = [];
    //     pie.forEach((data) {
    //       sections.add(PieChartSectionData(
    //         color: HexColor(data.color),
    //         value: double.parse(data.value),
    //         title: data.shown,
    //         radius: 50,
    //         titleStyle: TextStyle(color: Colors.black),
    //       ));
    //       titles.add(
    //         new Indicator(
    //           color: HexColor(data.color),
    //           text: data.title,
    //           isSquare: true,
    //         ),
    //       );
    //       titles.add(
    //         new SizedBox(
    //           height: 4,
    //         ),
    //       );
    //     });
    //     widgets.add(Container(
    //       child: Row(
    //         children: <Widget>[
    //           SizedBox(
    //             height: 18,
    //           ),
    //           Expanded(
    //             child: AspectRatio(
    //               aspectRatio: 1,
    //               child: FlChart(
    //                 chart: PieChart(
    //                   PieChartData(
    //                       borderData: FlBorderData(
    //                         show: false,
    //                       ),
    //                       sectionsSpace: 0,
    //                       centerSpaceRadius: 40,
    //                       sections: sections),
    //                 ),
    //               ),
    //             ),
    //           ),
    //           new Column(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: titles,
    //           ),
    //         ],
    //       ),
    //     ));
    //   });
    // }

    // // bars
    // if (charts.bars2 != null) {
    //   charts.bars2.forEach((bar) {
    //     List<DataPoint<dynamic>> datapoints = new List();
    //     bar.forEach((data) {
    //       print(DateTime.parse(data.title));
    //       datapoints.add(DataPoint<DateTime>(
    //           value: double.parse(data.value),
    //           xAxis: DateTime.parse(data.title)));
    //     });
    //     widgets.add(new Center(
    //       child: Container(
    //         color: Colors.red,
    //         height: MediaQuery.of(context).size.height / 2,
    //         width: MediaQuery.of(context).size.width,
    //         child: BezierChart(
    //           bezierChartScale: BezierChartScale.MONTHLY,
    //           fromDate: fromDate,
    //           toDate: toDate,
    //           selectedDate: toDate,
    //           series: [
    //             BezierLine(
    //               label: "dasd",
    //               onMissingValue: (dateTime) {
    //                 if (dateTime.month.isEven) {
    //                   return 10.0;
    //                 }
    //                 return 5.0;
    //               },
    //               data: datapoints,
    //             ),
    //           ],
    //           config: BezierChartConfig(
    //             verticalIndicatorStrokeWidth: 3.0,
    //             verticalIndicatorColor: Colors.black26,
    //             showVerticalIndicator: true,
    //             verticalIndicatorFixedPosition: true,
    //             backgroundColor: Colors.red,
    //             footerHeight: 30.0,
    //           ),
    //         ),
    //       ),
    //     ));
    //   });
    // }
    setState(() {
      loading = false;
    });
  }

  // BarChartGroupData makeGroupData(int x, double y1, double y2) {
  //   return BarChartGroupData(barsSpace: 4, x: x, barRods: [
  //     BarChartRodData(
  //       y: y1,
  //       color: leftBarColor,
  //       width: width,
  //       isRound: true,
  //     ),
  //     BarChartRodData(
  //       y: y2,
  //       color: rightBarColor,
  //       width: width,
  //       isRound: true,
  //     ),
  //   ]);
  // }

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
              25,
              MediaQuery.of(context).size.width * 0.1,
              0),
          child: loading ? new Container() : new ListView(children: widgets),
        ),
        inAsyncCall: loading,
      ),
    );
  }
}
