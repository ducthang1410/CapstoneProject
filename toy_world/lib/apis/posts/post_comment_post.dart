import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class CommentPost {
  commentPost({token, int? postId, String? content}) async {
    final response = await http.post(
      Uri.https('$urlMain', '$urlCommentPost'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
          <String, dynamic>{"postId": "$postId", "content": "$content"}),
    );
    print("Status postApi Login User/Pass:${response.statusCode}");

    return response.statusCode;
  }
}