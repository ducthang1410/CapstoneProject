import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class NewTradingPost {
  newTradingPost(
      {token,
        int? groupId,
        title,
        toyName,
        address,
        exchange,
        value,
        phone,
        String? content,
        List<String>? imgLink}) async {
    final response = await http.post(
      Uri.https('$urlMain', '$urlNewTradingPost/$groupId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "title": "$title",
        "toyName": "$toyName",
        "content": "$content",
        "address": "$address",
        "exchange": exchange,
        "value":  value,
        "phone": "$phone",
        "imagesLink": imgLink,
      }),
    );
    print("Status postApi New Trading Post:${response.statusCode}");

    return response.statusCode;
  }
}
