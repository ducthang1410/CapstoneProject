import 'package:flutter/material.dart';

class ToyPage extends StatefulWidget {
  const ToyPage({Key? key}) : super(key: key);

  @override
  _ToyPageState createState() => _ToyPageState();
}

class _ToyPageState extends State<ToyPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("This is toy"),
    );
  }
}
