import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_follower_account.dart';

import 'package:toy_world/utils/url.dart';

class FollowerAccountList {
  getFollowerAccount({token, accountId}) async {
    var response = await http.get(Uri.https("$urlMain", "$urlGetFollowerAccount/$accountId"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Following Account:${response.statusCode}");

    if (response.statusCode == 200) {
      return followerAccountFromJson(response.body);
    } else {
      return null;
    }
  }
}
