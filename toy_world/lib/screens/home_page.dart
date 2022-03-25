import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/components/component.dart';

class HomePage extends StatefulWidget {
  int role;
  String token;

  HomePage({required this.role, required this.token});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: const [
            Center(
              child: Text("Hello"),
            )
          ],
        ),
    );
  }
}
