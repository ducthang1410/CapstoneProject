import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/gets/get_account_profile.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_account_profile.dart';

class ProfilePage extends StatefulWidget {
  int role;
  String token;

  ProfilePage({required this.role, required this.token});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _id = 0;
  String _avatar = "";
  String _name = "";
  String _biography = "";
  String _email = "";
  String _phoneNumber = "";
  String _gender = "";
  Profile? _data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _id = (prefs.getInt('accountId') ?? 0);
      _avatar = (prefs.getString('avatar') ?? "");
      _name = (prefs.getString('name') ?? "");
      _biography = (prefs.getString('biography') ?? "");
      _email = (prefs.getString('email') ?? "");
      _phoneNumber = (prefs.getString('phoneNumber') ?? "");
      _gender = (prefs.getString('gender') ?? "");
      getData();
    });
  }

  getData() async {
    AccountProfile profile = AccountProfile();
    _data =
        await profile.getAccountProfile(token: widget.token, accountId: _id);
    if (!mounted) return;
    setState(() {});
    return _data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          sideAppBar(context),
          _avatarContent(context),
          _informationContent(context),
        ],
      ),
    );
  }

  Widget _avatarContent(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double coverHeight = size.height * 0.2;
    final top = coverHeight - size.height * 0.09;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: size.width,
          height: coverHeight,
          margin: EdgeInsets.only(bottom: size.height * 0.09),
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
        ),
        Positioned(top: top, child: _profileImage(size))
      ],
    );
  }

  Widget _profileImage(Size size) {
    return CircleAvatar(
        radius: size.height * 0.09,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: size.height * 0.085, backgroundColor: Colors.grey.shade300,
          backgroundImage: NetworkImage(
              _avatar),
        ));
  }

  Widget _informationContent(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          _name,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(thickness: 0.5,),
        const SizedBox(
          height: 5,
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNumber(size,
                  value: "${_data?.noOfPost ?? "0"}", text: "Post"),
              _buildNumber(size,
                  value: "${_data?.noOfFollowing ?? "0"}", text: "Following"),
              _buildNumber(size,
                  value: "${_data?.noOfFollower ?? "0"}", text: "Follower"),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(thickness: 0.5,),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: const Text("About me", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 20,
        ),
        containerProfile(size, title: "Gender", content: _gender),
        containerProfile(size, title: "Email", content: _email),
        containerProfile(size, title: "Phone", content: _phoneNumber),
        const Divider(thickness: 0.5,),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: const Text("Biography", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
        ),
        Container(margin: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: Text(_biography, style: const TextStyle(color: Colors.black54, fontSize: 20),))
      ],
    );
  }

  Widget _buildNumber(size, {String? value, String? text}) {
    return SizedBox(
      width: size.width * 0.3,
      child: MaterialButton(
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "$value",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "$text",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountInfo(size, {String? label, String? info}) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width * 0.2,
            child: Text("$label",style: const TextStyle(fontSize: 20),),
          ),
          Expanded(
            child: SizedBox(
              width: size.width * 0.65,
              child: Text("$info",style: const TextStyle(fontSize: 20, color: Colors.grey),),
            ),
          )
        ],
      ),
    );
  }

  Widget containerProfile(size, {String? title, String? content}) {
    return SizedBox(
      height: size.height * 0.07,
      width: size.width,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: size.width * 0.2,
                    child: Text("$title", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                Expanded(child: Text("$content", style: const TextStyle(color: Colors.black54, fontSize: 20),)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
