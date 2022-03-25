import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_user_chat.dart';

import 'package:toy_world/utils/url.dart';

class UsersChat {
  getUsersChat({token, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };

    var response = await http.get(
        Uri.https("$urlMain", "$urlGetUserChat", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Users Chat:${response.statusCode}");
    if (response.statusCode == 200) {
      return userChatFromJson(response.body);
    } else {
      return null;
    }
  }
}