import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_trading_post_detail.dart';

import 'package:toy_world/utils/url.dart';

class TradingPostDetailData {
  getTradingPostDetail({token, tradingPostId}) async {
    var response = await http.get(Uri.https("$urlMain", "$urlGetTradingPostDetail/$tradingPostId/detail/mobile"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Trading Post Detail:${response.statusCode}");
    if (response.statusCode == 200) {
      return tradingPostDetailFromJson(response.body);
    } else {
      return null;
    }
  }
}