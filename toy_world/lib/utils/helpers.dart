import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/screens/contest_list_page.dart';
import 'package:toy_world/screens/following_account_page.dart';
import 'package:toy_world/screens/group_page.dart';
import 'package:toy_world/screens/home_page.dart';
import 'package:toy_world/screens/profile_page.dart';
import 'package:toy_world/screens/proposal_contest_page.dart';
import 'package:toy_world/screens/toy_page.dart';
import 'package:toy_world/utils/google_login.dart';

getDataSession({required String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get(key);
}

setDataSession({required String key, required value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

colorHexa(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

selectedItem(BuildContext context, item, role, token) {
  switch (item) {
    case 0:
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(
                role: role,
                token: token,
              )));
      break;
    case 1:
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProposalPage()));
      break;
    case 2:
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ContestPage()));
      break;
    case 3:
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => GroupPage(role: role, token: token)));
      break;
    case 4:
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const FollowingPage()));
      break;
    case 5:
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ToyPage()));
      break;
    case 6:
      signOut(context);
      break;
  }
}
