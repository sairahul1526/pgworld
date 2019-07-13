import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pgworld/utils/models.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utils/config.dart';
import '../utils/api.dart';

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

  @override
  void initState() {
    super.initState();
    fillData();
  }

  void fillData() {
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

  void updateCharts() {
    // pies
    if (charts.pies != null) {
      charts.pies.forEach((pie) {
        List<PieChartSectionData> sections = [];
        pie.forEach((data) {
          sections.add(PieChartSectionData(
            color: Color(0xff0293ee),
            value: double.parse(data.value),
            title: data.title,
            radius: 50,
            // titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
          ));
        });
        widgets.add(Container(
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: FlChart(
                    chart: PieChart(
                      PieChartData(
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: sections),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      });
    }

    // bars
    if (charts.bars != null) {
      charts.bars.forEach((bar) {
        List<BarChartGroupData> barGroups = new List();
        bar.barData.forEach((data) {
          barGroups.add(makeGroupData(
            int.parse(data.x),
            double.parse(data.y1),
            double.parse(data.y2),
          ));
        });
        widgets.add(Container(
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 18,
              ),
              Expanded(
                  child: AspectRatio(
                aspectRatio: 1,
                child: FlChart(
                  chart: BarChart(BarChartData(
                    titlesData: FlTitlesData(
                      show: true,
                      showHorizontalTitles: true,
                      showVerticalTitles: true,
                      verticalTitlesTextStyle: TextStyle(
                          color: Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      verticalTitleMargin: 32,
                      verticalTitlesReservedWidth: 14,
                      getVerticalTitles: (value) {
                        bar.yaxis.forEach((y) {
                          if (value.toString() == y.title) {
                            return y.value;
                          }
                        });
                        return "";
                      },
                      horizontalTitlesTextStyle: TextStyle(
                          color: Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      horizontalTitleMargin: 20,
                      getHorizontalTitles: (double value) {
                        bar.xaxis.forEach((x) {
                          if (value.toInt().toString() == x.title) {
                            return x.value;
                          }
                        });
                        return "";
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: barGroups,
                  )),
                ),
              ))
            ],
          ),
        ));
      });
    }
    setState(() {
      loading = false;
    });
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: leftBarColor,
        width: width,
        isRound: true,
      ),
      BarChartRodData(
        y: y2,
        color: rightBarColor,
        width: width,
        isRound: true,
      ),
    ]);
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
              25,
              MediaQuery.of(context).size.width * 0.1,
              0),
          child: new Column(children: widgets),
        ),
        inAsyncCall: loading,
      ),
    );
  }
}
