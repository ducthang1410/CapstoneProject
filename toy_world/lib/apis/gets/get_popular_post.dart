import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_post_group.dart';

import 'package:toy_world/utils/url.dart';

class PopularPostList {
  getPopularPost({token, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };
    var response = await http.get(Uri.https("$urlMain", "$urlGetPopularPost/mobile", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Popular Post:${response.statusCode}");


    if (response.statusCode == 200) {
      return postGroupFromJson(response.body);
    } else {
      return null;
    }
  }
}