import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_contest_group.dart';

import 'package:toy_world/utils/url.dart';

class HighlightContestList {
  getHighlightContestList({token, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };

    var response = await http.get(Uri.https("$urlMain", "$urlGetHighlightContest/mobile", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Highlight Contest:${response.statusCode}");
    if (response.statusCode == 200) {
      return contestGroupFromJson(response.body);
    } else {
      return null;
    }
  }
}