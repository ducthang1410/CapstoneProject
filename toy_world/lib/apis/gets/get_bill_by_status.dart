import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_bill_status.dart';

import 'package:toy_world/utils/url.dart';

class BillByStatus {
  getBillByStatus({token, status, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };

    var response = await http.get(Uri.https("$urlMain", "$urlGetBillByStatus/$status/mobile", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Bill By Status:${response.statusCode}");
    if (response.statusCode == 200) {
      return billsStatusFromJson(response.body);
    } else {
      return null;
    }
  }
}