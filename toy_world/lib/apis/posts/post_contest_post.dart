import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class NewContestPost {
  newContestPost(
      {token,
        int? contestId,
        String? content,
        List<String>? imagesUrl}) async {
    final response = await http.post(
      Uri.https('$urlMain', '$urlNewContestPost/$contestId/post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "content": "$content",
        "imagesUrl": imagesUrl,
      }),
    );
    print("Status postApi New Contest Post:${response.statusCode}");

    return response.statusCode;
  }
}
