class API {
  static const URL = "localhost:5000";
  static const ADMIN = "admin";
  static const BILL = "bill";
  static const EMPLOYEE = "employee";
  static const LOG = "log";
  static const NOTE = "note";
  static const ROOM = "room";
  static const USER = "user";
  static const HOSTEL = "hostel";

  static const RENT = "rent";
  static const SALARY = "salary";
}

class APPVERSION {
  static const ANDROID = "1";
  static const IOS = "1";
}

class APIKEY {
  static const ANDROID_LIVE = "T9h9P6j2N6y9M3Q8";
  static const ANDROID_TEST = "K7b3V4h3C7t6g6M7";
  static const IOS_LIVE = "b4E6U9K8j6b5E9W3";
  static const IOS_TEST = "R4n7N8G4m9B4S5n2";
}

String adminName;
String hostelID;
List<String> amenities = ["1", "2", "5"];

Map<String, String> headers = {};

const timeout = 10;
