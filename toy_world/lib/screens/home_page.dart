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
  String _name = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString('name') ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawerMenu(context, widget.role, widget.token, _name),
      body: Builder(
        builder: (context) => Column(
          children: [
            defaultAppBar(context),
            menuHome(context, widget.role, widget.token),
          ],
        ),
      ),
    );
  }
}
