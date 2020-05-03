/* This class is for retrieving all items from all users */

// flutter / firebase imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../database.dart' as fbDatabase;

// lib imports
import '../database.dart';

// data imports
import 'package:itemdonatestore/data/itemdata.dart';
import '../data/global.dart' as global;



class RetrieveAllItems extends StatefulWidget {
  @override
  _RetrieveAllItemsState createState() => new _RetrieveAllItemsState();
}

class _RetrieveAllItemsState extends State<RetrieveAllItems> {
  List<ItemData> itemDataList = [];

  @override
  void initState() {
    super.initState();

    for(var user in global.usersList) {
      DatabaseReference ref = FirebaseDatabase.instance.reference();
      ref.child("itemsListing/${user}/").once().then((DataSnapshot snap) {
        var keys = snap.value.keys;
        var data = snap.value;
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
          print('${itemDataList}');
        });
      });
    }
  }


  void _manageUser(String value) async {
    await fbDatabase.manageUser(value);
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
              // Following Row is to debug global users list
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: (){
                      _manageUser(global.username);
                      print('Users List (global) : ${global.usersList}');
                    },
                    child: new Text('Retrieve Global Users List')  ,
                  ),
                ],
              ),
              Center(child: Container(
                padding: new EdgeInsets.all(20.0),
                child: itemDataList.length == 0
                  ? new Text(' No Data is Available')
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