import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProActivity extends StatefulWidget {
  ProActivity();

  @override
  State<StatefulWidget> createState() {
    return new ProActivityState();
  }
}

class ProActivityState extends State<ProActivity> {
  bool loading = false;

  ProActivityState();

  @override
  void initState() {
    super.initState();
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
          "CloudPG PRO",
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
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              new SizedBox(
                width: 100,
                height: 100,
                child: new Image.asset('assets/appicon.png'),
              ),
              new Container(
                color: Colors.transparent,
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        "Reach further with CloudPG PRO",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                color: Colors.transparent,
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        "Become a CloudPG PRO and unlock the following features",
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                height: 20,
              ),
              new Container(
                color: Colors.transparent,
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        "1. Store Bills, Expenses and other documents\n\n2. Filter Bills, Users, Rooms\n\n3. Charts and graphs\n\n4. Manage multiple hostels\n\n5.Multiuser\n\n6. A totally ad-free experience\n\n7. Plus more goodies to come!",
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                height: 40,
              ),
              new Container(
                color: Colors.transparent,
                margin: new EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        "Coming soon",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        inAsyncCall: loading,
      ),
    );
  }
}
