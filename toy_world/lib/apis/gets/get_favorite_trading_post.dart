import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_trading_post_group.dart';

import 'package:toy_world/utils/url.dart';

class TradingPostFavoriteList {
  getTradingPostFavorite({token, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };
    var response = await http.get(Uri.https("$urlMain", "$urlGetFavoriteTradingPost/mobile", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Favorite Trading Post:${response.statusCode}");
    if (response.statusCode == 200) {
      return tradingPostGroupFromJson(response.body);
    } else {
      return null;
    }
  }
}