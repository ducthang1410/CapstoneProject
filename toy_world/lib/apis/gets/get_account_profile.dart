import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_account_profile.dart';

import 'package:toy_world/utils/url.dart';

class AccountProfile {
  getAccountProfile({token, accountId}) async {
    var response = await http
        .get(Uri.https("$urlMain", "$urlAccountProfile/$accountId"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Account Profile:${response.statusCode}");
    if (response.statusCode == 200) {
      return profileFromJson(response.body);
    } else {
      return null;
    }
  }
}
