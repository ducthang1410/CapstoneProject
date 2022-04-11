import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_contest_detail.dart';

import 'package:toy_world/utils/url.dart';

class ContestDetailApi {
  getContestDetail({token, contestId}) async {
    var response = await http.get(Uri.https("$urlMain", "$urlGetContestDetail/$contestId/details"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Contest Detail:${response.statusCode}");
    if (response.statusCode == 200) {
      return contestDetailFromJson(response.body);
    } else {
      return null;
    }
  }
}