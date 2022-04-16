import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class FeedbackPost {
  feedbackPost({token, int? postId, content}) async {
    final response = await http.post(
      Uri.https('$urlMain', '$urlFeedbackPost/$postId/feedback'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "content": "$content",
      }),
    );
    print("Status postApi Feedback Post:${response.statusCode}");

    return response.statusCode;
  }
}
