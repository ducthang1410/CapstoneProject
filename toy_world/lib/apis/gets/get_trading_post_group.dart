import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_trading_post_group.dart';

import 'package:toy_world/utils/url.dart';

class TradingPostGroupList {
  getTradingPostGroup({token, groupId, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };
    var response = await http.get(Uri.https("$urlMain", "$urlTradingPostByGroup/$groupId/mobile", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Trading Post Of Group:${response.statusCode}");
    if (response.statusCode == 200) {
      return tradingPostGroupFromJson(response.body);
    } else {
      return null;
    }
  }
}