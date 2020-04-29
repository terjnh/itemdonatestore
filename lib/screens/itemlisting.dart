import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
//import 'storage.dart' as fbStorage;
import '../auth.dart' as fbAuth;
import '../database.dart' as fbDatabase;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';  // needed for basename

class ItemListing extends StatefulWidget {
  @override
  _ItemListingState createState() => new _ItemListingState();
}

class _ItemListingState extends State<ItemListing> {

  String _username;
  String _itemNameList;  // example to try

  @override
  void initState() {
    super.initState();
    _signIn();
  }

  void _signIn() async {
    if(await fbAuth.signInGoogle() == true) {
      _username = await fbAuth.username();
    }
  }


  void _addUniqueItem() async {
    await fbDatabase.addUniqueItem(_username);
  }



//  void _readItems() async {
//    await fbDatabase.readItems(_username);
//    fbDatabase.readItems(_username).then((String result){
//      setState(() {
//        _itemNameList = result;
//        print(_itemNameList);
//      });
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Put up an Item Listing'),
      ),
      body: new SingleChildScrollView(
        padding: new EdgeInsets.all(30.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                onPressed: (){Navigator.of(context).pushNamed('/RetrieveItems');},
                child: new Text('Retrieve Items Page'),
              ),
              new Text(
                _itemNameList.toString(),
              ),

              Padding(padding: EdgeInsets.all(40.0)),

              Center(child: Container(
                padding: EdgeInsets.all(10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: _addUniqueItem,
                      child: new Text('Add Unique Item'),
                    ),
                  ],
                )
              ),),

              Center(child: Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text('This button adds hard-coded data info\nDatabase.dart, refer to addUniqueItem()'),
                  ],
                )
              ),),

            ],
          ),
        ),
      ),
    );
  }
}