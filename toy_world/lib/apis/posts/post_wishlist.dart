import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class PostWishlist {
  postWishlist({token, List<int>? groupIds}) async {
    final response = await http.post(
      Uri.https('$urlMain', '$urlPostWishlist'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "groupIds": groupIds,
      }),
    );

    print("Status postApi Post Wishlist:${response.statusCode}");

    return response.statusCode;
  }
}
