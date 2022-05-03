import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class NewAccount {
  newAccount({
    name,
    email,
    password,
  }) async {
    final response = await http.post(
      Uri.https('$urlMain', '$urlNewAccount'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
      body: jsonEncode(<dynamic, dynamic>{
        "name": "$name",
        "email": "$email",
        "password": "$password",
      }),
    );
    print("Status postApi New Account:${response.statusCode}");

    return response.statusCode;
  }
}
