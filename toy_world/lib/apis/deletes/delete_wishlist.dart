import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toy_world/utils/url.dart';

class DeleteWishlist {
  deleteWishlist({token, List<int>? groupIds}) async {
    var response = await http.delete(
      Uri.https("$urlMain", "$urlDeleteWishlist/mobile"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "groupIds": groupIds,
      }),
    );
    print("Status deleteApi Delete Wishlist:${response.statusCode}");
    return response.statusCode;
  }
}
