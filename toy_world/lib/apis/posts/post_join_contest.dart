import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class JoinContest {
  joinContest({token, contestId}) async {

    final response = await http.post(
      Uri.https('$urlMain', '$urlJoinContest/$contestId/join'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );

    print("Status postApi Join Contest:${response.statusCode}");
    print("Status postApi Join Contest:${response.body}");

    return response.statusCode;
  }
}
