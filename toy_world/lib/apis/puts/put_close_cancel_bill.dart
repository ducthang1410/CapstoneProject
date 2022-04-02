
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class CloseCancelBill {
  closeOrCancelBill({token, billId, choice}) async {
    final queryParameters = {
      'update_status': "$choice"
    };
    final response = await http.put(
      Uri.https('$urlMain', '$urlPutCloseCancelBill/$billId/status', queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );
    print("Status putApi Close Cancel Bill:${response.statusCode}");

    return response.statusCode;
  }
}