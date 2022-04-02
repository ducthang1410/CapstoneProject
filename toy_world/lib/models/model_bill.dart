
import 'dart:convert';

Bill billFromJson(String str) => Bill.fromJson(json.decode(str));

String billToJson(Bill data) => json.encode(data.toJson());

class Bill {
  Bill({
    this.id,
    this.toyOfSellerName,
    this.toyOfBuyerName,
    this.isExchangeByMoney,
    this.exchangeValue,
    this.sellerName,
    this.buyerName,
    this.status,
    this.createTime,
  });

  int? id;
  String? toyOfSellerName;
  String? toyOfBuyerName;
  bool? isExchangeByMoney;
  double? exchangeValue;
  String? sellerName;
  String? buyerName;
  int? status;
  DateTime? createTime;

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
    id: json["id"],
    toyOfSellerName: json["toyOfSellerName"],
    toyOfBuyerName: json["toyOfBuyerName"],
    isExchangeByMoney: json["isExchangeByMoney"],
    exchangeValue: json["exchangeValue"],
    sellerName: json["sellerName"],
    buyerName: json["buyerName"],
    status: json["status"],
    createTime: DateTime.parse(json["createTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "toyOfSellerName": toyOfSellerName,
    "toyOfBuyerName": toyOfBuyerName,
    "isExchangeByMoney": isExchangeByMoney,
    "exchangeValue": exchangeValue,
    "sellerName": sellerName,
    "buyerName": buyerName,
    "status": status,
    "createTime": createTime!.toIso8601String(),
  };
}
