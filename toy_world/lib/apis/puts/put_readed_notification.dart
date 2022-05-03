import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class ReadNotification {
  readNotification({token, notificationId}) async {
    final queryParameters = {'id': "$notificationId"};
    final response = await http.put(
      Uri.https('$urlMain', '$urlReadNotification', queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );
    print("Status putApi Read Notification:${response.statusCode}");

    return response.statusCode;
  }
}
