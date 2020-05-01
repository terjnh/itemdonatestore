import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
//import 'storage.dart' as fbStorage;
import '../auth.dart' as fbAuth;
import '../database.dart' as fbDatabase;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';  // needed for basename

//Data
import 'package:itemdonatestore/data/itemdata.dart';
import '../data/global.dart' as global;


class RetrieveItems extends StatefulWidget {
  @override
  _RetrieveItemsState createState() => new _RetrieveItemsState();
}

class _RetrieveItemsState extends State<RetrieveItems> {
  String username = global.username;
  List<ItemData> itemDataList = [];


  @override
  void initState() {
    super.initState();

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child("itemsListing/${username}/").once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      itemDataList.clear();  // clear List<ItemData>
      for (var key in keys) {
        ItemData singleData = new ItemData(
          data[key]['category'],
          data[key]['itemName'],
          data[key]['location'],
          data[key]['quantity'],
        );
        itemDataList.add(singleData);
      }
      setState(() {
        print('Length of items : ${itemDataList.length}');
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('My Listed Items')
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
                        'My listed items:',
                      style: new TextStyle(color: Colors.blueGrey, fontSize: 25.0),
                    ),
                  ],
                ),
                Center(child: Container(
                  padding: new EdgeInsets.all(20.0),
                  child: itemDataList.length == 0
                      ? new Text (' No Data is Available')
                      : new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: itemDataList.length,
                      itemBuilder: (_, index) {
                        return UI(
                          itemDataList[index].category,
                          itemDataList[index].itemName,
                          itemDataList[index].location,
                          itemDataList[index].quantity,
                        );
                      },
                  ),
                ),),
              ],
            ),
          ),
      ),
    );
  }

  Widget UI(String category, String itemName, String location, String quantity) {
    return new Card(
      elevation: 10.0,
      child: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text('Category : $category'),
            new Text('Item Name : $itemName'),
            new Text('Location : $location'),
            new Text('Quantity : $quantity'),
          ],
        ),
      ),
    );
  }
}


















//  void _retrieveItems() {
//    DatabaseReference ref = FirebaseDatabase.instance.reference();
//    ref.child('${_username}').once().then((DataSnapshot snap) {
//      var keys = snap.value.keys;
//      var data = snap.value;
//      itemDataList.clear();
//      for(var key in keys) {
//        itemDataList.add(new ItemData(
//        data[key]['category'],
//        data[key]['itemName'],
//        data[key]['location'],
//        data[key]['quantity'],
//        data[key]['status'],
//      ));
//        print('Length: ${itemDataList.length}');
//    }
//      setState(() {
//        print('Length: ${itemDataList.length}');
//      });
//    });
//
//  }
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text('Retriving Items'),
//      ),
//      body: new SingleChildScrollView(
//        padding: new EdgeInsets.all(20.0),
//        child: new Center(
//          child: new Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              new Text('Retriving Items'),
//              new RaisedButton(onPressed: _retrieveItems, child: new Text('Retrieve!'),),
//              new RaisedButton(onPressed: (){Navigator.of(context).pushNamed('/ShowDataPage');}, child: new Text('ShowDataPage'),),
//              new RaisedButton(onPressed: (){Navigator.of(context).pushNamed('/WriteDataPage');}, child: new Text('WriteDataPage'),),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//}
