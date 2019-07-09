import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:intl/intl.dart';

DateFormat dateFormat = new DateFormat('yyyy-MM-dd');
DateFormat headingDateFormat = new DateFormat("EEE, MMM d, ''yy");

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

void sendMail(String mail) async {
  var url = 'mailto:' + mail;
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

Widget getAmenityIcon(String id) {
  switch (id) {
    case "1": // wifi
      return new Icon(Icons.wifi);
      break;
    case "2": // bathroom
      return new Icon(Icons.smoking_rooms);
      break;
    case "3": // tv
      return new Icon(Icons.tv);
      break;
    case "4": // ac
      return new Icon(Icons.ac_unit);
      break;
    case "5": // power backup
      return new Icon(Icons.power);
      break;
    default:
      return null;
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

String getAmenitiesNames(String amenities) {
  List<String> names = new List();
  amenities.split(",").forEach((amenity) {
    String name = getAmenityName(amenity);
    if (name.length > 0) {
      names.add(name);
    }
  });
  return names.join(",");
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
