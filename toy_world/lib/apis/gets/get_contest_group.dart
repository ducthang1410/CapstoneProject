import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_contest_group.dart';

import 'package:toy_world/utils/url.dart';

class ContestGroupList {
  getContestGroup({token, groupId, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };
    var response = await http.get(Uri.https("$urlMain", "$urlContestByGroup/$groupId", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Contest Of Group:${response.statusCode}");
    if (response.statusCode == 200) {
      return contestGroupFromJson(response.body);
    } else {
      return null;
    }
  }
}