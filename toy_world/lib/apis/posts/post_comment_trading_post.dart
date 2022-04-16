import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class CommentTradingPost {
  commentTradingPost({token, int? tradingPostId, String? content}) async {
    final response = await http.post(
      Uri.https('$urlMain', '$urlCommentTradingPost'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
          <String, dynamic>{"postId": "$tradingPostId", "content": "$content"}),
    );
    print("Status postApi Comment Trading Post:${response.statusCode}");

    return response.statusCode;
  }
}