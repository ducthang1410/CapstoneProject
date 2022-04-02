
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class AcceptDenyBill {
  acceptOrDenyBill({token, billId, choice}) async {
    final queryParameters = {
      'accept_or_deny': "$choice"
    };
    final response = await http.put(
      Uri.https('$urlMain', '$urlPutAcceptDenyBill/$billId/accept_or_deny', queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );
    print("Status putApi Accept Or Deny Bill:${response.statusCode}");

    return response.statusCode;
  }
}