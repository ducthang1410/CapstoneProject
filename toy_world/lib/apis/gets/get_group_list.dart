import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_group.dart';

import 'package:toy_world/utils/url.dart';

class GroupList {
  getListGroup({token}) async {
    var response = await http.get(Uri.https("$urlMain", "$urlGroupList"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Group List:${response.statusCode}");
    if (response.statusCode == 200) {
      return groupsFromJson(response.body);
    } else {
      return null;
    }
  }
}
