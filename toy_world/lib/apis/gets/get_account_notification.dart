import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_notification.dart';

import 'package:toy_world/utils/url.dart';

class AccountNotificationList {
  getAccountNotificationList({token, accountId, size}) async {
    final queryParameters = {
      'ownerId': "$accountId",
      'PageNumber': "1",
      'PageSize': "$size",
    };
    var response = await http.get(Uri.https("$urlMain", "$urlGetAccountNotification", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Account Notification:${response.statusCode}");
    if (response.statusCode == 200) {
      return accountNotificationsFromJson(response.body);
    } else {
      return null;
    }
  }
}