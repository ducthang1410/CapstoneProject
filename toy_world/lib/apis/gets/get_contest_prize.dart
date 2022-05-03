import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_prize.dart';

import 'package:toy_world/utils/url.dart';

class ContestPrizeApi {
  getContestPrize({token, contestId}) async {
    var response = await http.get(Uri.https("$urlMain", "$urlGetContestPrize/$contestId/prizes"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Contest Prize:${response.statusCode}");

    if (response.statusCode == 200) {
      return prizeFromJson(response.body);
    } else {
      return null;
    }
  }
}