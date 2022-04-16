import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_waiting_post.dart';

import 'package:toy_world/utils/url.dart';

class WaitingPostList {
  getWaitingPosts({token, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };
    var response = await http.get(Uri.https("$urlMain", "$urlGetWaitingPost/mobile", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Waiting Post:${response.statusCode}");
    if (response.statusCode == 200) {
      return waitingPostsFromJson(response.body);
    } else {
      return null;
    }
  }
}