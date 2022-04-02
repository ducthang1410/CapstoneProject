import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class RateSeller {
  rateSeller({token, billId, numOfStar, content}) async {

    final response = await http.post(
      Uri.https('$urlMain', '$urlRateSeller/bill/$billId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "numOfStar": "$numOfStar",
        "content": "$content",
      }),
    );

    print("Status postApi Rate Seller:${response.statusCode}");

    return response.statusCode;
  }
}
