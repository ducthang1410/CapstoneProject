import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_prize.dart';

import 'package:toy_world/utils/url.dart';

class PrizeContestList {
  getPrizeContest({token, contestId}) async {
    var response = await http.get(Uri.https("$urlMain", "$urlPrizeByContest/$contestId/prizes"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Prize Of Contest:${response.statusCode}");
    if (response.statusCode == 200) {
      return prizeFromJson(response.body);
    } else {
      return null;
    }
  }
}