import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class UpdateComment {
  updateComment({token, commentId, content}) async {
    final response = await http.put(
      Uri.https('$urlMain', '$urlPutUpdateComment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        "id": "$commentId",
        "content": "$content"
      }),
    );
    print("Status putApi Update Comment:${response.statusCode}");

    return response.statusCode;
  }
}