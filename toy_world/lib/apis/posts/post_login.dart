import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/models/model_login.dart';

import 'package:toy_world/utils/url.dart';

class PostLogin {
  login({String? firebaseToken}) async {
    Map<String, String> qParams = {"firebaseToken": "$firebaseToken"};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.https(urlMain, "$urlLogin", qParams),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    );
    print("Status postApi Login:${response.statusCode}");

    ModelLogin data = ModelLogin();
    data = ModelLogin.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      prefs.setInt("accountId", data.accountId ?? 0);
      prefs.setString("avatar", "${data.avatar}");
      prefs.setString("name", "${data.name}");
      prefs.setInt("role", data.role ?? 0);
      prefs.setBool("status", data.status ?? false);
      prefs.setString("token", "${data.token}");
      print(
          'ID: ${data.accountId} - Name: ${data.name} - Role: ${data.role} - Status: ${data.status} - Token: ${data.token}');
    }

    return response.statusCode;
  }
}

class PostLoginSystemAccount {
  login({String? email, String? password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.https('$urlMain', '$urlLoginSystemAccount'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
      body: jsonEncode(
          <String, dynamic>{"email": "$email", "password": "$password"}),
    );
    print("Status postApi Login User/Pass:${response.statusCode}");
    ModelLogin data = ModelLogin();
    data = ModelLogin.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      prefs.setInt("accountId", data.accountId ?? 0);
      prefs.setString("avatar", "${data.avatar}");
      prefs.setString("name", "${data.name}");
      prefs.setInt("role", data.role ?? 0);
      prefs.setBool("status", data.status ?? false);
      prefs.setString("token", "${data.token}");
      print(
          'ID: ${data.accountId} - Name: ${data.name} - Role: ${data.role} - Status: ${data.status} - Token: ${data.token}');
    }

    return response.statusCode;
  }
}
