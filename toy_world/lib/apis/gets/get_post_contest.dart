import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_contest_post.dart';

import 'package:toy_world/utils/url.dart';

class ContestPostList {
  getContestPost({token, contestId, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };
    var response = await http.get(Uri.https("$urlMain", "$urlGetPostOfContest/$contestId/posts", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Post Of Contest:${response.statusCode}");
    if (response.statusCode == 200) {
      return contestPostsFromJson(response.body);
    } else {
      return null;
    }
  }
}