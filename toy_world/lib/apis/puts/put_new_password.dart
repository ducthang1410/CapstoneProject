import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:toy_world/utils/url.dart';

class NewPassword {
  newPassword({token, newPassword}) async {
    final queryParameters = {'new_password': "$newPassword"};

    final response = await http.put(
      Uri.https('$urlMain', '$urlNewPassword', queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );
    print("Status putApi New Password:${response.statusCode}");

    return response.statusCode;
  }
}
