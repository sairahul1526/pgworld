import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:intl/intl.dart';
import "dart:math";

DateFormat dateFormat = new DateFormat('yyyy-MM-dd');
DateFormat headingDateFormat = new DateFormat("EEE, MMM d, ''yy");
DateFormat timeFormat = new DateFormat("h:mm a");

List<String> colors = [
  "#D7BDE2",
  "#F5CBA7",
  "#F9E79F",
  "#A2D9CE",
  "#AED6F1",
  "#F5B7B1",
  "#ABB2B9"
];

final random = new Random();

SharedPreferences prefs;
Future<bool> initSharedPreference() async {
  prefs = await SharedPreferences.getInstance();
  if (prefs != null) {
    return true;
  }
  return false;
}

void makePhone(String phone) async {
  var url = 'tel:' + phone;
  if (await canLaunch(url)) {
    await launch(url);
  }
}

void sendMail(String mail, String subject, String body) async {
  var url = 'mailto:' +
      mail +
      "?subject=" +
      subject +
      "&body=" +
      Uri.encodeComponent(body);
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  }
}

Future<bool> checkInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

Widget showProgress(String title) {
  return AlertDialog(
    title: new Container(
      padding: EdgeInsets.all(10),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(
              title,
            ),
          ),
          new Container(
            padding: new EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: new CircularProgressIndicator(),
          )
        ],
      ),
    ),
  );
}

Widget popDialog(BuildContext context, String title, bool pop) {
  return AlertDialog(
    title: new Text(title),
    actions: <Widget>[
      new FlatButton(
        child: new Text("ok"),
        onPressed: () {
          if (pop) {
            Navigator.of(context).pop();
          }
        },
      ),
    ],
  );
}

IconData getAmenityIcon(String id) {
  switch (id) {
    case "1": // wifi
      return Icons.wifi;
      break;
    case "2": // bathroom
      return Icons.smoking_rooms;
      break;
    case "3": // tv
      return Icons.tv;
      break;
    case "4": // ac
      return Icons.ac_unit;
      break;
    case "5": // power backup
      return Icons.power;
      break;
    default:
      return Icons.plus_one;
  }
}

String getAmenityName(String id) {
  switch (id) {
    case "1": // wifi
      return "Wifi";
      break;
    case "2": // bathroom
      return "Bathroom";
      break;
    case "3": // tv
      return "TV";
      break;
    case "4": // ac
      return "AC";
      break;
    case "5": // power backup
      return "Power Backup";
      break;
    default:
      return "";
  }
}

List<Widget> getAmenitiesNames(String amenities) {
  List<Widget> widgets = new List();
  amenities.split(",").forEach((amenity) {
    String name = getAmenityName(amenity);
    if (name.length > 0) {
      widgets.add(new Column(
        children: <Widget>[
          new Icon(
            getAmenityIcon(amenity),
            size: 15,
          ),
          new Text(
            name,
            style: TextStyle(fontSize: 10),
          )
        ],
      ));
      widgets.add(new Container(
        width: 15,
      ));
    }
  });

  // new Column(
  //   children: <Widget>[
  //     new Icon(
  //       Icons.wifi,
  //       size: 15,
  //     ),
  //     new Text(
  //       "Wifi",
  //       style: TextStyle(
  //           fontSize: 10),
  //     )
  //   ],
  // ),
  // new Container(
  //   width: 15,
  // )

  return widgets;
}

Future<bool> twoButtonDialog(
    BuildContext context, String title, String content) async {
  bool returned = false;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          new FlatButton(
            child: new Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
              returned = false;
            },
          ),
          new FlatButton(
            child: new Text(
              "Yes",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              returned = true;
            },
          ),
        ],
      );
    },
  );
  return returned;
}

void oneButtonDialog(
    BuildContext context, String title, String content, bool dismiss) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          new FlatButton(
            child: new Text("ok"),
            onPressed: () {
              if (dismiss) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
