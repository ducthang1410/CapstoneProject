import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class NewProposal {
  newProposal({
    token,
    groupId,
    title,
    reason,
    description,
    slogan,
    rule,
  }) async {
    final response = await http.post(
      Uri.https('$urlMain', '$urlNewProposal'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "groupId": groupId,
        "title": "$title",
        "description": "$description",
        "reason": "$reason",
        "slogan": "$slogan",
        "rule": "$rule",
      }),
    );

    print("Status postApi New Proposal:${response.statusCode}");

    return response.statusCode;
  }
}
