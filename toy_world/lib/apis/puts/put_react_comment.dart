import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class ReactComment {
  reactComment({token, commentId}) async {
    final response = await http.put(
      Uri.https('$urlMain', '$urlPutReactComment/$commentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );
    print("Status putApi React Comment:${response.statusCode}");

    return response.statusCode;
  }
}