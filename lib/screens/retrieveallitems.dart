/* This class is for retrieving all items from all users */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

import '../data/global.dart' as global;

class RetrieveAllItems extends StatefulWidget {
  @override
  _RetrieveAllItemsState createState() => new _RetrieveAllItemsState();
}

class _RetrieveAllItemsState extends State<RetrieveAllItems> {

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Items from All Users')
      ),
      body: new SingleChildScrollView(
        padding: new EdgeInsets.all(20.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'All Items Available',
                    style: new TextStyle(color: Colors.blueGrey, fontSize: 25.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}