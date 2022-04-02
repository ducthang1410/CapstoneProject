import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_bill_created.dart';

import 'package:toy_world/utils/url.dart';

class CreateNewBill {
  createNewBill(
      {token, toyOfSellerName, toyOfBuyerName, isExchangeByMoney, exchangeValue, buyerId, tradingPostId}) async {
    final response = await http.post(
      Uri.https('$urlMain', '$urlCreateBill'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<dynamic, dynamic>{
        "toyOfSellerName": "$toyOfSellerName",
        "toyOfBuyerName": toyOfBuyerName,
        "isExchangeByMoney": isExchangeByMoney,
        "exchangeValue": exchangeValue,
        "buyerId": "$buyerId",
        "tradingPostId": "$tradingPostId",
      }),
    );

    print("Status postApi Create Bill:${response.statusCode}");

    if (response.statusCode == 200) {
      return billCreatedFromJson(response.body);
    } else {
      return null;
    }
  }
}