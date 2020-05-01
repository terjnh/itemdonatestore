import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:itemdonatestore/data/global.dart' as global;
import './screens/itemlisting.dart' as itemListing;

// itemlisting.dart -> add an item for listing
// What do we need for an item listing:
//  1. Name of item
//  2. Quantity
//  3. Location of pick-up
//  TODO: 4. Category of item (Drop-down list)
//  TODO: 5. Photo(s) of item
//Future<Null> addItem(String user, String itemName, int qty, String location, String category) async {
//  DatabaseReference _addItemRef;
//  _addItemRef = FirebaseDatabase.instance.reference().child('items/${user}');
//
//}


// Add user into database (itemdonatestore-alpha -> users)
// DO NOT add user if it already exists
Future<Null> manageUser(String user) async {
  List<String> rawExistingUsersList = [];

  DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");

  // Populate global.usersList first [get existing users from (itemdonatestore-alpha -> users)]
  dynamic retrieveExistingUsers = await usersRef.orderByChild("username").once();
  Map<dynamic, dynamic> existingUsersMap = retrieveExistingUsers.value;

  // 1st index in usersList and 1st entry in (itemdonatestore-alpha -> users)
  if(existingUsersMap?.isEmpty ?? true) {
    print('No users, creating database "users" ...');
    usersRef.push().set({
      "username" : "$user",
    });
    global.usersList.add(user);
    return;
  }

  // (itemdonatestore-alpha -> users) has existing users
  // retrieve users from (itemdonatestore-alpha -> users) and populate global.usersList
  if(existingUsersMap.isNotEmpty) {
    print('Retrieving current existing database "users" ...');
    existingUsersMap.forEach((key, value) =>
        rawExistingUsersList.add(value.toString()));

    for (var existingUsername in rawExistingUsersList) {
      if(global.usersList.contains(user) == false) {
        global.usersList.add(
            existingUsername.substring(11, existingUsername.length - 1));
      }
    }
    print('Global usersList = ${global.usersList}');
  }

  // Add user only if it does not exist in (itemdonatestore-alpha -> users)
  if(global.usersList.contains(user)) {
    print('User exists in database "users", will not proceed to add ...');
    return;
  }
  else {
    print('Adding user to database "users" ...');
    usersRef.push().set({
      "username" : "$user",
    });
  }
}


// Retrieve item based on Key-Value pair
Future<String> readItems(String user) async {
//  String result = (await FirebaseDatabase.instance.reference().child("itemsListing/${user}/Item1/Item Name").once()).value;
//  return result;
  DatabaseReference _dbRef;
  _dbRef = FirebaseDatabase.instance.reference().child("itemsListing/${user}");

  dynamic retrievedItems;
  retrievedItems = _dbRef.orderByChild("Item Name").once();
  print(retrievedItems);
}

Future<Null> removeData(String user) async {
  DatabaseReference _messageRef;
  _messageRef = FirebaseDatabase.instance.reference().child('messages/${user}');
  await _messageRef.remove();
}

Future<Null> setData(String user, String key, String value) async {
  DatabaseReference _messageRef;
  _messageRef = FirebaseDatabase.instance.reference().child('messages/${user}');
  _messageRef.set(<String, String>{key : value});
}

Future<Null> updateData(String user, String key, String value) async {
  DatabaseReference _messageRef;
  _messageRef = FirebaseDatabase.instance.reference().child('messages/${user}');
  _messageRef.update(<String, String>{key : value});
}

// Add items with unique id generated by Firebase
Future<Null> addUniqueItem(String user) async {
  DatabaseReference _dbRef;

  _dbRef = FirebaseDatabase.instance.reference().child("itemsListing/${user}");

  _dbRef.push().set({
    "Item Name" : "IPad Pro 10",
    "Qty" : 2,
    "Location" : "Jurong West",
    "Category" : "Electronics",
    "Status" : "Not Available",
  });
}