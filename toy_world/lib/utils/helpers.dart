import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/screens/expand_photo_page.dart';

import 'package:toy_world/screens/following_account_page.dart';
import 'package:toy_world/screens/full_photo_page.dart';

import 'package:toy_world/screens/management_page.dart';
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

selectedDrawerItem(BuildContext context, item, role, token, {currentUserId}) {
  switch (item) {
    case 0:
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FollowingPage(
                role: role,
                token: token,
                currentUserId: currentUserId,
              )));
      break;
    case 1:
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ManagementPage(
                role: role,
                token: token,
              )));
      break;
    case 2:
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ToyPage(
                role: role,
                token: token,
              )));
      break;
    case 3:
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

onImageClicked(BuildContext context, String url, int role, String token) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FullPhotoPage(
        url: url,
        role: role,
        token: token,
      ),
    ),
  );
}

onExpandClicked(
    BuildContext context, List<ImagePost> images, int role, String token) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) =>
            ExpandPhotoPage(role: role, token: token, images: images)),
  );
}

Future<String> postImage(Asset asset, String directory) async {
  String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  ByteData byteData = await asset.getByteData();
  List<int> imageData = byteData.buffer.asUint8List();
  print(imageData);
  Reference ref =
      FirebaseStorage.instance.ref().child("$directory/" + fileName);
  print(ref);
  UploadTask uploadTask = ref.putData(Uint8List.fromList(imageData));
  print(uploadTask);
  TaskSnapshot snapshot = await uploadTask;
  print(snapshot);
  print(snapshot.ref.getDownloadURL());
  return snapshot.ref.getDownloadURL();
}

uploadImages(List<Asset> images, String directory) async {
  final imageUrls = <String>[];
  for (var image in images) {
    String url = await postImage(image, directory);
    imageUrls.add(url);
  }
  return imageUrls;
}

imageShow(List<ImagePost> images, Size size) {
  if (images.length == 1) {
    return size.width;
  } else if (images.length == 3) {
    return size.width * 0.35;
  } else {
    return size.width * 0.5;
  }
}

showStatusTradingPost(int? status) {
  if (status == 0) {
    return const Text(
      "Open",
      style: TextStyle(
          color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
    );
  } else if (status == 1) {
    return const Text(
      "Exchanging",
      style: TextStyle(
          color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 18),
    );
  } else if (status == 2) {
    return const Text(
      "Closed",
      style: TextStyle(
          color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18),
    );
  } else {
    return const Text(
      "Unknown",
      style: TextStyle(fontSize: 18),
    );
  }
}

Color showPrize(String? name) {
  if (name == "First prize") {
    return Colors.amber;
  } else if (name == "Second prize") {
    return Colors.grey;
  } else if (name == "Third prize") {
    return Colors.brown;
  } else {
    return Colors.black87;
  }
}
