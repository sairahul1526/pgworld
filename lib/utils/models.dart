// post

import 'package:flutter/material.dart';

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class Post {
  final String id;
  final Meta meta;

  Post({this.id, this.meta});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      meta: Meta.fromJson(json['meta']),
    );
  }
}

// admin

class Admins {
  final List<Admin> admins;
  final Meta meta;
  final Pagination pagination;

  Admins({this.admins, this.meta, this.pagination});

  factory Admins.fromJson(Map<String, dynamic> json) {
    return Admins(
      admins: json['data'] != null
          ? List<Admin>.from(json['data'].map((i) => Admin.fromJson(i)))
          : new List<Admin>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Admin {
  final String id;
  final String username;
  final String password;
  final String email;
  final String hostels;
  final String amenities;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  Admin(
      {this.id,
      this.username,
      this.password,
      this.email,
      this.hostels,
      this.amenities,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      hostels: json['hostels'],
      amenities: json['amenities'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// bill

class Bills {
  final List<Bill> bills;
  final Meta meta;
  final Pagination pagination;

  Bills({this.bills, this.meta, this.pagination});

  factory Bills.fromJson(Map<String, dynamic> json) {
    return Bills(
      bills: json['data'] != null
          ? List<Bill>.from(json['data'].map((i) => Bill.fromJson(i)))
          : new List<Bill>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

abstract class ListItem {}

class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);
}

class Bill implements ListItem {
  final String id;
  final String hostelID;
  final String title;
  final String userID;
  final String employeeID;
  final String description;
  final String type;
  final String document;
  final String amount;
  final String paid;
  final String paidDateTime;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  Bill(
      {this.id,
      this.hostelID,
      this.title,
      this.userID,
      this.employeeID,
      this.description,
      this.type,
      this.document,
      this.amount,
      this.paid,
      this.paidDateTime,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      hostelID: json['hostel_id'],
      title: json['title'],
      userID: json['user_id'],
      employeeID: json['employee_id'],
      description: json['description'],
      type: json['type'],
      document: json['document'],
      amount: json['amount'],
      paid: json['paid'],
      paidDateTime: json['paid_date_time'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// dashboard

class Dashboards {
  final List<Graph> graphs;
  final List<Dashboard> dashboards;
  final Meta meta;

  Dashboards({this.graphs, this.dashboards, this.meta});

  factory Dashboards.fromJson(Map<String, dynamic> json) {
    return Dashboards(
      graphs: json['graphs'] != null
          ? List<Graph>.from(json['graphs'].map((i) => Graph.fromJson(i)))
          : new List<Graph>(),
      dashboards: json['data'] != null
          ? List<Dashboard>.from(json['data'].map((i) => Dashboard.fromJson(i)))
          : new List<Dashboard>(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class Dashboard {
  final String user;
  final String room;
  final String bill;
  final String note;
  final String employee;

  Dashboard({
    this.user,
    this.room,
    this.bill,
    this.note,
    this.employee,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      user: json['user'],
      room: json['room'],
      bill: json['bill'],
      note: json['note'],
      employee: json['employee'],
    );
  }
}

// employee

class Employees {
  final List<Employee> employees;
  final Meta meta;
  final Pagination pagination;

  Employees({this.employees, this.meta, this.pagination});

  factory Employees.fromJson(Map<String, dynamic> json) {
    return Employees(
      employees: json['data'] != null
          ? List<Employee>.from(json['data'].map((i) => Employee.fromJson(i)))
          : new List<Employee>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Employee {
  final String id;
  final String name;
  final String designation;
  final String phone;
  final String email;
  final String address;
  final String document;
  final String salary;
  final String joiningDateTime;
  final String lastPaidDateTime;
  final String expiryDateTime;
  final String leaveDateTime;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  Employee(
      {this.id,
      this.name,
      this.designation,
      this.phone,
      this.email,
      this.address,
      this.document,
      this.salary,
      this.joiningDateTime,
      this.lastPaidDateTime,
      this.expiryDateTime,
      this.leaveDateTime,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      designation: json['designation'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      document: json['document'],
      salary: json['salary'],
      joiningDateTime: json['joining_date_time'],
      lastPaidDateTime: json['last_paid_date_time'],
      expiryDateTime: json['expiry_date_time'],
      leaveDateTime: json['leave_date_time'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// hostel

class Hostels {
  final List<Hostel> hostels;
  final Meta meta;
  final Pagination pagination;

  Hostels({this.hostels, this.meta, this.pagination});

  factory Hostels.fromJson(Map<String, dynamic> json) {
    return Hostels(
      hostels: json['data'] != null
          ? List<Hostel>.from(json['data'].map((i) => Hostel.fromJson(i)))
          : new List<Hostel>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Hostel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String amenities;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String expiryDateTime;
  final String createdDateTime;
  final String modifiedDateTime;

  Hostel(
      {this.id,
      this.name,
      this.phone,
      this.email,
      this.address,
      this.amenities,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.expiryDateTime,
      this.createdDateTime,
      this.modifiedDateTime});

  factory Hostel.fromJson(Map<String, dynamic> json) {
    return Hostel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      amenities: json['amenities'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      expiryDateTime: json['expiry_date_time'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// log

class Logs {
  final List<Log> logs;
  final Meta meta;
  final Pagination pagination;

  Logs({this.logs, this.meta, this.pagination});

  factory Logs.fromJson(Map<String, dynamic> json) {
    return Logs(
      logs: json['data'] != null
          ? List<Log>.from(json['data'].map((i) => Log.fromJson(i)))
          : new List<Log>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Log implements ListItem {
  final String id;
  final String log;
  final String by;
  final String type;
  String color;
  IconData icon;
  String title;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  Log(
      {this.id,
      this.log,
      this.by,
      this.type,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      log: json['log'],
      by: json['by'],
      type: json['type'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// note

class Notes {
  final List<Note> notes;
  final Meta meta;
  final Pagination pagination;

  Notes({this.notes, this.meta, this.pagination});

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      notes: json['data'] != null
          ? List<Note>.from(json['data'].map((i) => Note.fromJson(i)))
          : new List<Note>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Note implements ListItem {
  final String id;
  final String note;
  String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  Note(
      {this.id,
      this.note,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      note: json['note'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// room

class Rooms {
  final List<Room> rooms;
  final Meta meta;
  final Pagination pagination;

  Rooms({this.rooms, this.meta, this.pagination});

  factory Rooms.fromJson(Map<String, dynamic> json) {
    return Rooms(
      rooms: json['data'] != null
          ? List<Room>.from(json['data'].map((i) => Room.fromJson(i)))
          : new List<Room>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Room {
  final String id;
  final String hostelID;
  final String roomno;
  final String rent;
  final String floor;
  final String filled;
  final String capacity;
  final String amenities;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  Room(
      {this.id,
      this.hostelID,
      this.roomno,
      this.rent,
      this.floor,
      this.filled,
      this.capacity,
      this.amenities,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      hostelID: json['hostel_id'],
      roomno: json['roomno'],
      rent: json['rent'],
      floor: json['floor'],
      filled: json['filled'],
      capacity: json['capacity'],
      amenities: json['amenities'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// user

class Users {
  final List<User> users;
  final Meta meta;
  final Pagination pagination;

  Users({this.users, this.meta, this.pagination});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      users: json['data'] != null
          ? List<User>.from(json['data'].map((i) => User.fromJson(i)))
          : new List<User>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class User {
  final String id;
  final String hostelID;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String roomID;
  final String roomno;
  final String rent;
  final String emerContact;
  final String emerPhone;
  final String food;
  final String document;
  final String paymentStatus;
  final String joiningDateTime;
  final String lastPaidDateTime;
  final String expiryDateTime;
  final String leaveDateTime;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  User(
      {this.id,
      this.hostelID,
      this.name,
      this.phone,
      this.email,
      this.address,
      this.roomID,
      this.roomno,
      this.rent,
      this.emerContact,
      this.emerPhone,
      this.food,
      this.document,
      this.paymentStatus,
      this.joiningDateTime,
      this.lastPaidDateTime,
      this.expiryDateTime,
      this.leaveDateTime,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      hostelID: json['hostel_id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      roomID: json['room_id'],
      roomno: json['roomno'],
      rent: json['rent'],
      emerContact: json['emer_contact'],
      emerPhone: json['emer_phone'],
      food: json['food'],
      document: json['document'],
      paymentStatus: json['payment_status'],
      joiningDateTime: json['joining_date_time'],
      lastPaidDateTime: json['last_paid_date_time'],
      expiryDateTime: json['expiry_date_time'],
      leaveDateTime: json['leave_date_time'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

class Meta {
  final String status;
  final String message;
  final String messageType;

  Meta({this.status, this.message, this.messageType});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      status: json['status'],
      message: json['message'],
      messageType: json['message_type'],
    );
  }
}

class Pagination {
  final String count;
  final String offset;
  final String totalCount;

  Pagination({this.count, this.offset, this.totalCount});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      count: json['count'],
      offset: json['offset'],
      totalCount: json['total_count'],
    );
  }
}

// reports
class Charts {
  final List<Graph> graphs;
  final Meta meta;

  Charts({this.graphs, this.meta});

  factory Charts.fromJson(Map<String, dynamic> json) {
    return Charts(
      graphs: json['graphs'] != null
          ? List<Graph>.from(json['graphs'].map((i) => Graph.fromJson(i)))
          : new List<Graph>(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class Graph {
  final String title;
  final String color;
  final String dataTitle;
  final String type;
  final String steps;
  final List<ChartType2> data;

  Graph(
      {this.title,
      this.color,
      this.dataTitle,
      this.type,
      this.steps,
      this.data});

  factory Graph.fromJson(Map<String, dynamic> json) {
    return Graph(
      title: json['title'],
      color: json['color'],
      dataTitle: json['data_title'],
      type: json['type'],
      steps: json['steps'],
      data: json['data'] != null
          ? List<ChartType2>.from(
              json['data'].map((i) => ChartType2.fromJson(i)))
          : new List<ChartType2>(),
    );
  }
}

class ChartType2 {
  final String title;
  final String color;
  final List<ChartData> data;

  ChartType2({this.title, this.color, this.data});

  factory ChartType2.fromJson(Map<String, dynamic> json) {
    return ChartType2(
      title: json['title'],
      color: json['color'],
      data: json['data'] != null
          ? List<ChartData>.from(json['data'].map((i) => ChartData.fromJson(i)))
          : new List<ChartData>(),
    );
  }
}

class ChartData {
  String title;
  String value;
  String color;
  String shown;

  ChartData({
    this.title,
    this.value,
    this.color,
    this.shown,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) => new ChartData(
        title: json["title"],
        value: json["value"],
        color: json["color"],
        shown: json["shown"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "color": color,
        "shown": shown,
      };
}
