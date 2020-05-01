/* Notes */
/*
1: To get debug certificate fingerprint (SHA-1):
keytool -list -v \
-alias androiddebugkey -keystore ~/.android/debug.keystore
PASSWORD: android

2. Testing Gmail account(s):
tt0620395@gmail.com
pw: 5tgbyh^%$uJ
BD: 24 June 1987
Gender: Rather not say
 */

// TODO: to store a database of users in realtime database to read from
//   TODO: (1May20) now able to store users, need to read back users list and display all items in database


import 'package:flutter/material.dart';
import 'package:itemdonatestore/screens/additem.dart';
import 'dart:async';
import 'dart:io';
//import 'storage.dart' as fbStorage;
import 'auth.dart' as fbAuth;
import 'database.dart' as fbDatabase;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';  // needed for basename

// Screens
import 'package:itemdonatestore/screens/home.dart';
import 'package:itemdonatestore/screens/itemlisting.dart';
import 'package:itemdonatestore/screens/retrieveitems.dart';

void main() async {

  runApp(new MyApp());
  WidgetsFlutterBinding.ensureInitialized();

  // ********* Setup required for Firebase Storage ********* //
  final FirebaseApp app = await FirebaseApp.configure(
      name: 'itemdonatestore',
      options: new FirebaseOptions(
        googleAppID: '1:705744044005:android:19db1d0ba72895aeb0390c',  // "mobilesdk_app_id" from google-services.json
        gcmSenderID: '705744044005',  // "project_number" from google-services.json
        apiKey: 'AIzaSyD4q6Ui3G86bY080ev4FTnYhk87vScdGX0',  // "current_key" from google-services.json
        projectID: 'itemdonatestore-alpha',  // "project_id" from google-services.json
        databaseURL: 'https://itemdonatestore-alpha.firebaseio.com/',  // URL gotten from console.firebase.google.com -> Database
      )
  );

  // storageBucket url from Firebase Console -> Storage
  final FirebaseStorage storage = new FirebaseStorage(app: app, storageBucket: 'gs://itemdonatestore-alpha.appspot.com');
  final FirebaseDatabase database = new FirebaseDatabase(app: app);

  runApp(new MaterialApp(
    home: new MyApp(app: app, database: database, storage: storage),
  ));
} // void main()


class MyApp extends StatelessWidget {
  MyApp({this.app, this.database, this.storage});
  final FirebaseApp app;
  final FirebaseDatabase database;
  final FirebaseStorage storage;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Navigation',
      routes: <String, WidgetBuilder>{
        // List of all available pages
        '/Home': (BuildContext context) => new Home(),
        '/AddItem': (BuildContext context) => new AddItem(),
        '/ItemListing': (BuildContext context) => new ItemListing(),
        '/RetrieveItems': (BuildContext context) => new RetrieveItems(),
      },
      home: new Home(),  // first page displayed
    );
  }





//  @override
//  _State createState() => new _State(app: app, database: database, storage: storage);

}

//class _State extends State<MyApp> {
//  _State({this.app, this.database, this.storage});
//  final FirebaseApp app;
//  final FirebaseDatabase database;
//  final FirebaseStorage storage;
//
//  String _status;
//  String _location;
//  StreamSubscription<Event> _counterSubscription;
//
//  String _username;
//
//  bool _isLoggedIn;
//
//  @override
//  void initState() {
//    super.initState();
//    _status = "Not Authenticated";
//    _signIn();
//  }
//
//  void _signIn() async {
//    if(await fbAuth.signInGoogle() == true) {
//      _username = await fbAuth.username();
//      setState(() {
//        _status = 'Welcome ${fbAuth.currentDisplayName}';
//        _isLoggedIn = true;
//      });
////      _initDatabase();
//    } else {
//      setState(() {
//        _status = 'Could not sign in with Google!';
//        _isLoggedIn = false;
//      });
//    }
//  }
//  void _signOut() async {
//    if(await fbAuth.signOut() == true) {
//      setState(() {
//        _status = 'Signed out';
//        _isLoggedIn = false;
//      });
//    } else {
//      setState(() {
//        _status = 'Signed in';
//      });
//    }
//  }
//
//
//  void _addData() async {
//    await fbDatabase.addData(_username);
//    setState(() {
//      _status = 'Data Added';
//    });
//  }
//
//  void _removeData() async {
//    await fbDatabase.removeData(_username);
//    setState(() {
//      _status = 'Data Removed';
//    });
//  }
//
//  void _setData(String key, String value) async {
//    await fbDatabase.setData(_username, key, value);
//    setState(() {
//      _status = 'Data Set';
//    });
//  }
//  void _updateData(String key, String value) async {
//    await fbDatabase.updateData(_username, key, value);
//    setState(() {
//      _status = 'Data Updated';
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text('Items Donation'),
//      ),
//      body: new SingleChildScrollView(
//        padding: new EdgeInsets.all(20.0),
//        child: new Center(
//          child: new Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              new Text('Status: ${_status}'),
//              new Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  new RaisedButton(onPressed: _signIn, child: new Text('Google Sign-In'),),
//                  new RaisedButton(onPressed: _signOut, child: new Text('Sign Out'),),
//                ],
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}