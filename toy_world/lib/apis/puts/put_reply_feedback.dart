import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class ReplyFeedback {
  replyFeedback({token, feedbackId, content}) async {
    final queryParameters = {
      'replyContent': "$content"
    };
    final response = await http.put(
      Uri.https('$urlMain', '$urlReplyFeedback/$feedbackId/reply', queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );
    print("Status putApi Reply Feedback:${response.statusCode}");

    return response.statusCode;
  }
}