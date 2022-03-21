import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class NewPost {
  newPost(
      {token,
      int? groupId,
      String? content,
      List<String>? imgLink}) async {
    final response = await http.post(
      Uri.https('$urlMain', '$urlNewPost'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        "groupId": "$groupId",
        "content": "$content",
        "imagesLink": "$imgLink",
      }),
    );
    print("Status postApi New Post:${response.statusCode}");

    return response.statusCode;
  }
}
