import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:http/http.dart' as http;

import './models.dart';
import './config.dart';

// admin

Future<Admins> getAdmins(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.ADMIN, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Admins.fromJson(json.decode(response.body));
}

// bill

Future<Bills> getBills(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.BILL, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Bills.fromJson(json.decode(response.body));
}

// dashboard

Future<Dashboards> getDashboards(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.DASHBOARD, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Dashboards.fromJson(json.decode(response.body));
}

// employee

Future<Employees> getEmployees(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.EMPLOYEE, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Employees.fromJson(json.decode(response.body));
}

// food

Future<Foods> getFoods(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.FOOD, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Foods.fromJson(json.decode(response.body));
}

// invoice

Future<Invoices> getInvoices(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.INVOICE, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Invoices.fromJson(json.decode(response.body));
}

// issue

Future<Issues> getIssues(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.ISSUE, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Issues.fromJson(json.decode(response.body));
}

// log

Future<Logs> getLogs(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.LOG, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Logs.fromJson(json.decode(response.body));
}

// note

Future<Notes> getNotes(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.NOTE, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Notes.fromJson(json.decode(response.body));
}

// notice

Future<Notices> getNotices(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.NOTICE, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Notices.fromJson(json.decode(response.body));
}

// report

Future<Charts> getReports(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.REPORT, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Charts.fromJson(json.decode(response.body));
}

// room

Future<Rooms> getRooms(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.ROOM, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Rooms.fromJson(json.decode(response.body));
}

// user

Future<Users> getUsers(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.USER, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Users.fromJson(json.decode(response.body));
}

// hostels

Future<Hostels> getHostels(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.HOSTEL, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Hostels.fromJson(json.decode(response.body));
}


// status

Future<Admins> getStatus(Map<String, String> query) async {
  final response = await http
      .get(Uri.http(API.URL, API.STATUS, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  return Admins.fromJson(json.decode(response.body));
}


// add and update
Future<bool> add(String endpoint, Map<String, String> body) async {
  if (body["status"] != null) {
    body["status"] = "1";
  }
  var request = new http.MultipartRequest(
    "POST",
    Uri.http(
      API.URL,
      endpoint,
    ),
  );
  request.headers.addAll(headers);
  request.fields["admin_name"] = adminName;
  body.forEach((k, v) => {request.fields[k] = v});

  var response = await request.send();
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> update(String endpoint, Map<String, String> body,
    Map<String, String> query) async {
  var request = new http.MultipartRequest(
    "PUT",
    Uri.http(API.URL, endpoint, query),
  );
  request.headers.addAll(headers);
  request.fields["admin_name"] = adminName;
  body.forEach((k, v) => {request.fields[k] = v});

  var response = await request.send();
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> delete(String endpoint, Map<String, String> query) async {
  var request = new http.MultipartRequest(
    "DELETE",
    Uri.http(API.URL, endpoint, query),
  );
  request.fields["admin_name"] = adminName;

  request.headers.addAll(headers);

  var response = await request.send();
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<String> upload(File file) async {
  var request = new http.MultipartRequest(
    "POST",
    Uri.http(
      API.URL,
      "upload",
    ),
  );
  request.headers.addAll(headers);
  request.fields["admin_name"] = adminName;

  var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
  // get file length
  var length = await file.length();
  // multipart that takes file
  var multipartFile = new http.MultipartFile('photo', stream, length,
      filename: basename(file.path));

  // add file to multipart
  request.files.add(multipartFile);

  var response = await request.send();

  if (response.statusCode == 200) {
    String responseData = await response.stream.transform(utf8.decoder).join();
    Map data = json.decode(responseData);
    if (data["data"] != null) {
      return data["data"][0]["image"];
    }
  }
  return "";
}
