import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class RateContestPost {
  rateContestPost({token, postId, contestId, numOfStar, note}) async {

    final response = await http.post(
      Uri.https('$urlMain', '$urlRateContestPost/$contestId/rate/$postId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "numOfStar": "$numOfStar",
        "note": "$note",
      }),
    );

    print("Status postApi Rate Contest Post:${response.statusCode}");

    return response.statusCode;
  }
}