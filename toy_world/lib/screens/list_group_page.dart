import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:toy_world/apis/gets/get_group_list.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_group.dart';
import 'package:toy_world/screens/group_page.dart';

class ListGroupPage extends StatefulWidget {
  int role;
  String token;

  ListGroupPage({required this.role, required this.token});

  @override
  _ListGroupPageState createState() => _ListGroupPageState();
}

class _ListGroupPageState extends State<ListGroupPage> {
  String _avatar = "";
  String _name = "";
  List<Group>? data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCounter();
    getData();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString('name') ?? "");
      _avatar = (prefs.getString('avatar') ?? "");
      });
  }

  getData() async {
    GroupList groups = GroupList();
    data = await groups.getListGroup(token: widget.token);
    if (data == null) return List.empty();
    setState(() {});
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawerMenu(context, widget.role, widget.token, _name, _avatar),
      backgroundColor: Colors.grey[200],
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Column(
            children: [
              defaultAppBar(context),
              menuHome(context, widget.role, widget.token),
              _content(context)
            ],
          ),
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
            "Group",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Color(0xffDB36A4)),
          ),
          GridView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: data?.length ?? 0,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: size.width * 0.03,
                mainAxisSpacing: size.width * 0.03),
            itemBuilder: (BuildContext context, int index) {
              return _group(size, name: data?[index].name ?? "", groupID: data?[index].id ?? 0);
            },
          ),
        ],
      ),
    );
  }

  Widget _group(Size size, {name, groupID}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => GroupPage(
                  role: widget.role,
                  token: widget.token,
                  groupID: groupID,
                )));
      },
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
                  "assets/images/toyType3.jpg",
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
