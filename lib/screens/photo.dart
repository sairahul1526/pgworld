import 'package:flutter/material.dart';

class PhotoActivity extends StatefulWidget {
  final String url;

  PhotoActivity(this.url);

  @override
  State<StatefulWidget> createState() {
    return new PhotoActivityState(url);
  }
}

class PhotoActivityState extends State<PhotoActivity> {
  String url;

  PhotoActivityState(this.url);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 4.0,
      ),
      body: new Image.network(url),
    );
  }
}