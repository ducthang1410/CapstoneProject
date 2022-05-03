import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class EditProfile {
  editProfile(
      {token, accountId, name, phone, avatar, biography, gender}) async {
    final response = await http.put(
      Uri.https('$urlMain', '$urlEditProfile/$accountId/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        "name": "$name",
        "phone": "$phone",
        "avatar": "$avatar",
        "biography": "$biography",
        "gender": "$gender",
      }),
    );
    print("Status putApi Edit Profile:${response.statusCode}");

    return response.statusCode;
  }
}
