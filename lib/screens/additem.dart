//// Reference this page using 'writedatapage.dart'
//// This screen is for adding an item for donation into Firebase Database
//
/* What do we need for an item listing:
  1. Name of item
  2. Quantity
  3. Location of pick-up
  4. Category of item (Drop-down list)
  5. Photo(s) of item
*/



import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';

import '../auth.dart' as fbAuth;
import '../database.dart' as fbDatabase;


class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _autovalidate = false;
  String itemName, quantity, location, category;
  List<DropdownMenuItem<String>> categoryItems = [
    new DropdownMenuItem(
      child: new Text('Electronics'),
      value: 'Electronics',
    ),
    new DropdownMenuItem(
      child: new Text('Consumables'),
      value: 'Consumables',
    ),
    new DropdownMenuItem(
      child: new Text('Household'),
      value: 'Household',
    ),
  ];

  String _username;

  @override
  void initState() {
    super.initState();
    _signIn();
  }

  void _signIn() async {
    if (await fbAuth.signInGoogle() == true) {
      _username = await fbAuth.username();
    }
  }

  // Category == null   error pop-up dialog
  void _categoryEmpty() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Error'),
            content: new Text('No category selected'),
            actions: <Widget>[
              new FlatButton(onPressed: (){ Navigator.of(context).pop();}, child: new Text('Close'),)
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add an Item'),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          padding: new EdgeInsets.all(15.0),
          child: new Form(
            key: _key,
            autovalidate: _autovalidate,
            child: FormUI(),
          ),
        ),
      ),
    );
  }

  Widget FormUI() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Flexible(
              child: new TextFormField(
                decoration: new InputDecoration(hintText: 'Item Name'),
                validator: validateItemName,
                onSaved: (val) {
                  itemName = val;
                },
                maxLength: 50,
              ),
            ),

          ],
        ),
        new Row(
          children: <Widget>[
            new Flexible(
              child: new TextFormField(
                decoration: new InputDecoration(hintText: 'Quantity'),
                validator: validateQty,
                onSaved: (val) {
                  quantity = val;
                },
                maxLength: 3,
              ),
            ),
          ],
        ),
        new Row(
          children: <Widget>[
            new Flexible(
              child: new TextFormField(
                decoration: new InputDecoration(hintText: 'Location'),
                validator: null,
                onSaved: (val) {
                  location = val;
                },
                maxLength: 100,
              ),
            ),
          ],
        ),
        new Row(
          children: <Widget>[
            new Text('Pick a Category: '),
            new SizedBox(width: 10.0),
            Spacer(),
            new DropdownButtonHideUnderline(
                child: new DropdownButton(
                    items: categoryItems,
                    hint: new Text('Categories'),
                    value: category,
                    onChanged: (String val) {
                      setState(() {
                        category = val;
                      });
                    },
                )),
          ],
        ),
        new Row(
          children: <Widget>[
            new RaisedButton(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0),),
              elevation: 10.0,
              onPressed: category == null ? _categoryEmpty : _sendToServer,   // if category entry != null, _sendToServer
              child: new Text('Add', style: new TextStyle(fontSize: 18.0, color: Colors.white)),
              color: Colors.blueAccent,
            )
          ],
        ),
      ],
    );
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      DatabaseReference ref = FirebaseDatabase.instance.reference();
      var data = {
        "itemName" : itemName,
        "quantity" : quantity,
        "location" : location,
        "category" : category,
      };
      ref.child('itemsListing/${_username}/').push().set(data).then((v) {
        _key.currentState.reset();
      });
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }


  // Validation of Entries
  String validateItemName(String val) {
    return val.length == 0 ? "Enter an Item Name" : null;
  }

  String validateQty(String val) {
    return val.length == 0 ? "Enter a Quantity" : null;
  }

  String validateLocation(String val) {
    return val.length == 0 ? "Enter a location" : null;
  }


}