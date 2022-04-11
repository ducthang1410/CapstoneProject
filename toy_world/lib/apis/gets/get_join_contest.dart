import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_check_join_contest.dart';

import 'package:toy_world/utils/url.dart';

class HasJoinedContest {
  getHasJoinedContest({token, contestId}) async {
    var response = await http.get(Uri.https("$urlMain", "$urlGetJoinContest/$contestId/attended"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Has Joined Contest:${response.statusCode}");
    if (response.statusCode == 200) {
      return checkJoinContestFromJson(response.body);
    } else {
      return null;
    }
  }
}