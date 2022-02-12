import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/screens/login_page.dart';

Future<String?> signIn() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
  final User? user = userCredential.user;

  print('Google sign in successful');

  String? token;

  await user!.getIdToken().then((value) {
    token = value;
  });

  return token;
}

void signOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await googleSignIn.signOut();
  await _auth.signOut();

  /// Demo
  prefs.remove("accountId");
  prefs.remove("avatar");
  prefs.remove("name");
  prefs.remove("role");
  prefs.remove("status");
  prefs.remove("token");
  prefs.clear();
  print('All data cleared - accountId, avatar, role, status, token !!!');

  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false);
}
