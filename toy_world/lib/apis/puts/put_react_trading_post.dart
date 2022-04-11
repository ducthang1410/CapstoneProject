import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class ReactTradingPost {
  reactTradingPost({token, tradingPostId}) async {
    final response = await http.put(
      Uri.https('$urlMain', '$urlPutReactTradingPost/$tradingPostId/react'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );

    print("Status putApi React Trading Post:${response.statusCode}");

    return response.statusCode;
  }
}