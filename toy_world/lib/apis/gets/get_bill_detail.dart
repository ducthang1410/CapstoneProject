import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_bill.dart';

import 'package:toy_world/utils/url.dart';

class BillDetail {
  getBillDetail({token, billId}) async {
    var response = await http.get(Uri.https("$urlMain", "$urlGetBillDetail/$billId/details/mobile"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Bill Detail:${response.statusCode}");
    if (response.statusCode == 200) {
      return billFromJson(response.body);
    } else {
      return null;
    }
  }
}