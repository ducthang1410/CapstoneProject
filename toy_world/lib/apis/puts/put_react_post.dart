import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class ReactPost {
  reactPost({token, postId}) async {
    final response = await http.put(
      Uri.https('$urlMain', '$urlPutReactPost/$postId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );
    print("Status putApi React Post:${response.statusCode}");

    return response.statusCode;
  }
}