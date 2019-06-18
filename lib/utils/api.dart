import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:http/http.dart' as http;
import 'package:pgworld/utils/utils.dart';

import './models.dart';
import './config.dart';

// admin

Future<Admins> getAdmins(Map<String, String> query) async {
  checkInternet().then((internet) {
    if (internet == null || !internet) {
      return new Admins();
    }
  });
  final response = await http
      .get(Uri.http(API.URL, API.ADMIN, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  print(response.body);
  if (response.statusCode == 200) {
    return Admins.fromJson(json.decode(response.body));
  } else {
    return new Admins();
  }
}

// bill

Future<Bills> getBills(Map<String, String> query) async {
  checkInternet().then((internet) {
    if (internet == null || !internet) {
      return new Bills();
    }
  });
  final response = await http
      .get(Uri.http(API.URL, API.BILL, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  print(response.body);
  if (response.statusCode == 200) {
    return Bills.fromJson(json.decode(response.body));
  } else {
    return new Bills();
  }
}

// employee

Future<Employees> getEmployees(Map<String, String> query) async {
  checkInternet().then((internet) {
    if (internet == null || !internet) {
      return new Employees();
    }
  });
  final response = await http
      .get(Uri.http(API.URL, API.EMPLOYEE, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  if (response.statusCode == 200) {
    print(response.body);
    return Employees.fromJson(json.decode(response.body));
  } else {
    return Employees();
  }
}

// log

Future<Logs> getLogs(Map<String, String> query) async {
  checkInternet().then((internet) {
    if (internet == null || !internet) {
      return new Logs();
    }
  });
  final response = await http
      .get(Uri.http(API.URL, API.LOG, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  if (response.statusCode == 200) {
    return Logs.fromJson(json.decode(response.body));
  } else {
    return Logs();
  }
}

// note

Future<Notes> getNotes(Map<String, String> query) async {
  checkInternet().then((internet) {
    if (internet == null || !internet) {
      return new Notes();
    }
  });
  final response = await http
      .get(Uri.http(API.URL, API.NOTE, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  if (response.statusCode == 200) {
    return Notes.fromJson(json.decode(response.body));
  } else {
    return Notes();
  }
}

// room

Future<Rooms> getRooms(Map<String, String> query) async {
  checkInternet().then((internet) {
    if (internet == null || !internet) {
      return new Rooms();
    }
  });
  final response = await http
      .get(Uri.http(API.URL, API.ROOM, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  if (response.statusCode == 200) {
    return Rooms.fromJson(json.decode(response.body));
  } else {
    return Rooms();
  }
}

// user

Future<Users> getUsers(Map<String, String> query) async {
  checkInternet().then((internet) {
    if (internet == null || !internet) {
      return new Users();
    }
  });
  final response = await http
      .get(Uri.http(API.URL, API.USER, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  if (response.statusCode == 200) {
    return Users.fromJson(json.decode(response.body));
  } else {
    return Users();
  }
}

// hostels

Future<Hostels> getHostels(Map<String, String> query) async {
  checkInternet().then((internet) {
    if (internet == null || !internet) {
      return new Hostels();
    }
  });
  final response = await http
      .get(Uri.http(API.URL, API.HOSTEL, query), headers: headers)
      .timeout(Duration(seconds: timeout));

  if (response.statusCode == 200) {
    return Hostels.fromJson(json.decode(response.body));
  } else {
    return Hostels();
  }
}

// add and update
Future<bool> add(String endpoint, Map<String, String> body) async {
  checkInternet().then((internet) {
    if (internet == null || !internet) {
      return false;
    }
  });
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
  checkInternet().then((internet) {
    if (internet == null || !internet) {
      return false;
    }
  });
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
  checkInternet().then((internet) {
    if (internet == null || !internet) {
      return false;
    }
  });
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
  checkInternet().then((internet) {
    if (internet == null || !internet) {
      return "";
    }
  });
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
