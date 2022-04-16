
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class FollowUnfollowAccount {
  followUnfollowAccount({token, int? accountId}) async {
    final response = await http.post(
      Uri.https('$urlMain', '$urlFollowUnfollowAccount/$accountId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );
    print("Status postApi Follow/Unfollow Account:${response.statusCode}");

    return response.statusCode;
  }
}
