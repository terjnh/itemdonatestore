import 'dart:ui';

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

import '../data/global.dart' as global;


class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  _HomeState({this.app, this.database, this.storage});
  final FirebaseApp app;
  final FirebaseDatabase database;
  final FirebaseStorage storage;

  String _status;
  String _location;
  StreamSubscription<Event> _counterSubscription;

  String _username;

  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _status = "Not Authenticated";
    _signIn();
  }


  // TODO: During _signIn, add unique user to Realtime Database, under child('users')
  void _signIn() async {
    if(await fbAuth.signInGoogle() == true) {
      _username = await fbAuth.username();
      setState(() {
        print('Welcome ${_username}');  // TODO: store uid into database
        _status = 'Welcome ${fbAuth.currentDisplayName}';
        _isLoggedIn = true;
        global.username = _username;  // current user is assigned to global.username
      });
//      _initDatabase();
    } else {
      setState(() {
        _status = 'Could not sign in with Google!';
        _isLoggedIn = false;
      });
    }
  }
  void _signOut() async {
    if(await fbAuth.signOut() == true) {
      setState(() {
        _status = 'Signed out\nPlease Sign In First!';
        _isLoggedIn = false;
      });
    } else {
      setState(() {
        _status = 'Signed in';
      });
    }
  }

//  Not Utilized Anymore: Consider Deleting!
//  void _addData() async {
//    await fbDatabase.addData(_username);
//    setState(() {
//      _status = 'Data Added';
//    });
//  }

  void _removeData() async {
    await fbDatabase.removeData(_username);
    setState(() {
      _status = 'Data Removed';
    });
  }

  void _setData(String key, String value) async {
    await fbDatabase.setData(_username, key, value);
    setState(() {
      _status = 'Data Set';
    });
  }
  void _updateData(String key, String value) async {
    await fbDatabase.updateData(_username, key, value);
    setState(() {
      _status = 'Data Updated';
    });
  }

  void _addUser(String value) async {
    await fbDatabase.addUser(value);
//    print('User ${value} added to Database..');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Items Donation'),
      ),
      body: new SingleChildScrollView(
        padding: new EdgeInsets.all(20.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(child: Container(
                child: Text('Status: ${_status}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                padding: EdgeInsets.all(20.0),
                ),
              ),
              Center(child: Container(
                padding: EdgeInsets.all(40.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: _isLoggedIn ? null : _signIn,
                      child: new Text( _isLoggedIn ? 'Signed In!' : 'Sign-In with\nGOOGLE', textAlign: TextAlign.center,),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      color: Colors.lightBlueAccent,
                    ),
                    new RaisedButton(
                      onPressed: _isLoggedIn ? _signOut : null,
                      child: new Text('Sign Out'),
                      color: Colors.yellowAccent,
                    ),
                  ],
                ),
              ),),
              Center(child: Container(
                padding: EdgeInsets.all(32.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: (){Navigator.of(context).pushNamed('/AddItem');},
                      child: new Text('Add an Item!'),
                    ),
                  ],
                ),
              ),),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('/RetrieveItems');
                      _addUser(global.username);
                      },
                    child: new Text('My Items'),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}