import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_subscriber.dart';

import 'package:toy_world/utils/url.dart';

class SubscribersContest {
  getSubscribersContest({token, contestId}) async {
    var response = await http
        .get(Uri.https("$urlMain", "$urlGetSubscribersContest/$contestId/subscribers"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Subscribers Contest:${response.statusCode}");
    if (response.statusCode == 200) {
      return subscriberFromJson(response.body);
    } else {
      return null;
    }
  }
}
