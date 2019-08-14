class API {
  static const URL = "test-pgworld.ap-south-1.elasticbeanstalk.com";
  static const ADMIN = "admin";
  static const BILL = "bill";
  static const DASHBOARD = "dashboard";
  static const EMPLOYEE = "employee";
  static const LOG = "log";
  static const NOTE = "note";
  static const REPORT = "report";
  static const ROOM = "room";
  static const USER = "user";
  static const SIGNUP = "signup";
  static const SUPPORT = "support";
  static const HOSTEL = "hostel";

  static const RENT = "rent";
  static const SALARY = "salary";
}

const ONESIGNAL_APP_ID = "47916c74-a7c2-4819-bb65-911776d5b814";

class COLORS {
  static const RED = "#E1A1AD";
  static const GREEN = "#9AD7CB";
}

class CONTACT {
  static const TERMS_URL = "http://cloudpg.in/terms.html";
  static const PRIVACY_URL = "http://cloudpg.in/privacy.html";
  static const ABOUT_URL = "http://cloudpg.in/about";
  static const SUPPORT_MAIL = "support@cloudpg.in";
}

String mediaURL = "https://test-pgworld.s3.ap-south-1.amazonaws.com/";

class APPVERSION {
  static const ANDROID = "1.8";
  static const IOS = "1.1";
}

class APIKEY {
  static const ANDROID_LIVE = "T9h9P6j2N6y9M3Q8";
  static const ANDROID_TEST = "K7b3V4h3C7t6g6M7";
  static const IOS_LIVE = "b4E6U9K8j6b5E9W3";
  static const IOS_TEST = "R4n7N8G4m9B4S5n2";
}

String adminName = "";
String adminEmailID = "";
String hostelID = "";
List<String> amenities = new List();

Map<String, String> headers = {
  "pkgname": "com.saikrishna.cloudpg",
  "Accept-Encoding": "gzip"
};

const timeout = 10;

const defaultLimit = "25";
const defaultOffset = "0";

// status
const STATUS_400 = "400";
const STATUS_403 = "403"; // forbidden
const STATUS_500 = "500";

List<List<String>> billTypes = [
  ["Cable Bill", "1"],
  ["Water Bill", "2"],
  ["Electricity Bill", "3"],
  ["Food Expense", "4"],
  ["Internet Bill", "5"],
  ["Maintainance", "6"],
  ["Property Rent/Tax", "7"],
  ["Others", "8"],
];
