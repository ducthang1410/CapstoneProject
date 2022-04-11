
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class ApproveWaitingPost {
  approveWaitingPost({token, postId}) async {
    final response = await http.put(
      Uri.https('$urlMain', '$urlPutApproveWaitingPost/$postId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );
    print("Status putApi Approve Waiting Post:${response.statusCode}");

    return response.statusCode;
  }
}