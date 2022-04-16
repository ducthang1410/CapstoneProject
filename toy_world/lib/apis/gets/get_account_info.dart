import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_account_info.dart';

import 'package:toy_world/utils/url.dart';

class AccountInfoData {
  getAccountInfo({token, accountId}) async {
    var response = await http
        .get(Uri.https("$urlMain", "$urlAccountInfo/$accountId/profile"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Account Info:${response.statusCode}");
    if (response.statusCode == 200) {
      return accountInfoFromJson(response.body);
    } else {
      return null;
    }
  }
}
