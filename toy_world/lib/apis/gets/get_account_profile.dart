import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_account_profile.dart';

import 'package:toy_world/utils/url.dart';

class AccountDetailData {
  getAccountDetail({token, accountId}) async {
    var response = await http
        .get(Uri.https("$urlMain", "$urlAccountDetail/$accountId"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Account Detail:${response.statusCode}");
    if (response.statusCode == 200) {
      return accountDetailFromJson(response.body);
    } else {
      return null;
    }
  }
}
