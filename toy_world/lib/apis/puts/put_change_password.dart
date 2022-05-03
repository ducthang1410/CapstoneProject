import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:toy_world/utils/url.dart';

class ChangePassword {
  changePassword({token, oldPassword, newPassword}) async {
    final response = await http.put(
      Uri.https('$urlMain', '$urlChangePassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        "old_password": "$oldPassword",
        "new_password": "$newPassword"
      }),
    );
    print("Status putApi Change Password:${response.statusCode}");

    return response.statusCode;
  }
}