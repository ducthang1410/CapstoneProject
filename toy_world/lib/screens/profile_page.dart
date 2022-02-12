import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  int role;
  String token;

  ProfilePage({required this.role, required this.token});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _id = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = (prefs.getInt('accountId') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("This is Profile"),
    );
  }
}
