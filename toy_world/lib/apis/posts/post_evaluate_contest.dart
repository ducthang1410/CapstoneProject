import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class EvaluateContest {
  evaluateContest({token, contestId, numOfStar, comment}) async {

    final response = await http.post(
      Uri.https('$urlMain', '$urlEvaluateContest/$contestId/evaluate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "numOfStar": "$numOfStar",
        "comment": "$comment",
      }),
    );

    print("Status postApi Evaluate Contest:${response.statusCode}");

    return response.statusCode;
  }
}