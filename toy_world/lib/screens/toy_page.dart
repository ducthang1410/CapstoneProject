import 'package:flutter/material.dart';
import 'package:toy_world/components/component.dart';

class ToyPage extends StatefulWidget {
  int role;
  String token;

  ToyPage({required this.role, required this.token});

  @override
  _ToyPageState createState() => _ToyPageState();
}

class _ToyPageState extends State<ToyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [sideAppBar(context, widget.role, widget.token), _content(context)],
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.grey[200],
      child: Column(
        children: [
          const Text(
            "Toy",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Color(0xffDB36A4)),
          ),
          GridView(
            shrinkWrap: true,
            primary: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: size.width * 0.03,
                mainAxisSpacing: size.width * 0.03),
            children: <Widget>[
              _toy(size, "assets/images/toyType1.jpg", "Gundam"),
              _toy(size, "assets/images/toyType2.jpg", "Lego"),
              _toy(size, "assets/images/toyType3.jpg", "Figure Japan"),
              _toy(size, "assets/images/toyType4.jpg", "Artbook"),
            ],
          )
        ],
      ),
    );
  }

  Widget _toy(Size size, String urlImg, String name) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        width: size.width * 0.45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              width: 1, style: BorderStyle.solid, color: Colors.grey),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 1,
              offset: Offset(0, 0), // Shadow position
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  urlImg,
                  width: size.width * 0.45,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                name,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              )
            ],
          ),
        ),
      ),
    );
  }
}
