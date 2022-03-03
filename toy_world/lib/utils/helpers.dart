import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/screens/contest_list_page.dart';
import 'package:toy_world/screens/following_account_page.dart';
import 'package:toy_world/screens/list_group_page.dart';
import 'package:toy_world/screens/home_page.dart';
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
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ProposalPage()));
      break;
    case 2:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ContestPage()));
      break;
    case 3:
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ListGroupPage(role: role, token: token)));
      break;
    case 4:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const FollowingPage()));
      break;
    case 5:
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ToyPage(
                role: role,
                token: token,
              )));
      break;
    case 6:
      signOut(context);
      break;
  }
}

timeControl(Duration duration) {
  if (duration.inMinutes < 1) {
    return "<1 minutes ago";
  } else if (duration.inMinutes < 60) {
    return duration.inMinutes.toString() + " minutes ago";
  } else if (duration.inMinutes < 1440) {
    return duration.inHours.toString() + " hours ago";
  } else if (duration.inMinutes >= 1440) {
    return duration.inDays.toString() + " days ago";
  }
}
