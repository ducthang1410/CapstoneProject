import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_reward_contest.dart';

import 'package:toy_world/utils/url.dart';

class RewardContestList {
  getRewardContest({token, contestId}) async {
    var response = await http.get(Uri.https("$urlMain", "$urlRewardByContest/$contestId/rewards"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Reward Of Contest:${response.statusCode}");
    if (response.statusCode == 200) {
      return rewardContestFromJson(response.body);
    } else {
      return null;
    }
  }
}