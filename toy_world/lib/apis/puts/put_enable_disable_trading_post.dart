import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class EnableDisableTradingPost {
  enableOrDisableTradingPost({token, tradingPostId, choice}) async {
    final response = await http.put(
      Uri.https('$urlMain', '$urlPutEnableDisableTradingPost/$tradingPostId/$choice'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );
    print("Status putApi Enable or Disable Trading Post:${response.statusCode}");

    return response.statusCode;
  }
}