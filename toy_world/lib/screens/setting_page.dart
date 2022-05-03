import 'package:flutter/material.dart';
import 'package:toy_world/screens/change_password_page.dart';
import 'package:toy_world/screens/edit_profile_page.dart';
import 'package:toy_world/utils/google_login.dart';

class SettingPage extends StatefulWidget {
  int role;
  String token;
  int accountId;
  bool isHasPassword;

  SettingPage(
      {required this.role,
      required this.token,
      required this.accountId,
      required this.isHasPassword});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDB36A4),
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: const [
                Icon(
                  Icons.person,
                  color: Color(0xffDB36A4),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            buildAccountOptionRow(context, "Edit Profile",
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => EditProfilePage(
                          role: widget.role,
                          token: widget.token,
                          accountId: widget.accountId,
                        )))),
            buildAccountOptionRow(
                context,
                widget.isHasPassword == true
                    ? "Change Password"
                    : "New Password",
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ChangePasswordPage(
                          role: widget.role,
                          token: widget.token,
                          isHasPassword: widget.isHasPassword,
                        )))),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: FlatButton(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                color: const Color(0xffDB36A4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  signOut(context);
                },
                child: const Text("SIGN OUT",
                    style: TextStyle(
                        fontSize: 16, letterSpacing: 2.2, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title,
      {onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
