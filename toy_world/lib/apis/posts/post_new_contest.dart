import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class NewContest {
  newContest(
      {token,
      groupId,
      title,
      description,
      coverImage,
      slogan,
      rule,
      startRegistration,
      endRegistration,
      startDate,
      endDate,
      typeName}) async {
    final response = await http.post(
      Uri.https('$urlMain', '$urlNewContest/$groupId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "title": "$title",
        "description": "$description",
        "coverImage": "$coverImage",
        "slogan": "$slogan",
        "rule": "$rule",
        "startRegistration": "$startRegistration",
        "endRegistration": "$endRegistration",
        "startDate": "$startDate",
        "endDate": "$endDate",
        "typeName": "$typeName",
      }),
    );

    print(startRegistration);
    print(coverImage);

    print("Status postApi New Contest:${response.statusCode}");
    print("Status postApi New Contest:${response.body}");

    return response.statusCode;
  }
}
