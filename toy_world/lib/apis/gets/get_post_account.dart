import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_post_group.dart';

import 'package:toy_world/utils/url.dart';

class PostAccountList {
  getPostAccount({token, accountId, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };
    var response = await http.get(Uri.https("$urlMain", "$urlGetPostByAccount/$accountId", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Post Of Account:${response.statusCode}");
    if (response.statusCode == 200) {
      return postGroupFromJson(response.body);
    } else {
      return null;
    }
  }
}