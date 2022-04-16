
import 'dart:convert';

import 'package:toy_world/models/model_image_post.dart';

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
    this.updateTime,
    this.images
  });

  int? id;
  String? toyOfSellerName;
  String? toyOfBuyerName;
  bool? isExchangeByMoney;
  int? exchangeValue;
  String? sellerName;
  String? buyerName;
  int? status;
  DateTime? updateTime;
  List<ImagePost>? images;

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
    id: json["id"],
    toyOfSellerName: json["toyOfSellerName"],
    toyOfBuyerName: json["toyOfBuyerName"],
    isExchangeByMoney: json["isExchangeByMoney"],
    exchangeValue: json["exchangeValue"],
    sellerName: json["sellerName"],
    buyerName: json["buyerName"],
    status: json["status"],
    updateTime: DateTime.parse(json["updateTime"],),
    images: List<ImagePost>.from(json["images"].map((x) => ImagePost.fromJson(x))),
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
    "updateTime": updateTime!.toIso8601String(),
    "images": List<dynamic>.from(images!.map((x) => x.toJson())),
  };
}
