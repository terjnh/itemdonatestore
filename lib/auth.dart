import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();
String currentDisplayName;

Future<bool> signOut() async {
  await _auth.signOut();
  return true;
}

Future<Null> ensureLoggedIn() async {
  FirebaseUser firebaseUser = await _auth.currentUser();
  assert(firebaseUser != null);
  assert(firebaseUser.isAnonymous == false);
  print('We are logged into Firebase');
}

Future<bool> signInGoogle() async {
  GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    idToken: googleAuth.idToken,
    accessToken: googleAuth.accessToken,
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

  if(user != null && user.isAnonymous == false) {
    return true;
  }

  return false;
}

// Get username
Future<String> username() async {
  await ensureLoggedIn();
  FirebaseUser firebaseUser = await _auth.currentUser();
  currentDisplayName = firebaseUser.displayName;
  return firebaseUser.uid; // User UID in firebase -> authentication
}