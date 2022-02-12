import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/gets/get_group_list.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_group.dart';

class GroupPage extends StatefulWidget {
  int role;
  String token;

  GroupPage({required this.role, required this.token});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<Group>? data;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    GroupList groups = GroupList();
      data = await groups.getListGroup(token: widget.token);
      isLoading = false;
    if (data == null) return List.empty();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        defaultAppBar(context),
        menuHome(context, widget.role, widget.token),
        _content(context)
      ],
    );
  }

  Widget _content(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Group",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xffDB36A4)),
          ),
          GridView.builder(
            itemCount: data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0),
            itemBuilder: (BuildContext context, int index) {
              return _group(size, name: data![index].name);
            },
          ),
        ],
      ),
    );
  }

  Widget _group(Size size, {name}) {
    return Container(
      width: size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1.0, color: const Color(0xffDB36A4)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 1,
            offset: Offset(0, 0), // Shadow position
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images.toyType1.jpg",
            width: size.width * 0.4,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
