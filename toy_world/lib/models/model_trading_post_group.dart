import 'dart:convert';
import 'model_trading_post.dart';



TradingPostGroup tradingPostGroupFromJson(String str) => TradingPostGroup.fromJson(json.decode(str));

String tradingPostGroupToJson(TradingPostGroup data) => json.encode(data.toJson());

class TradingPostGroup {
  TradingPostGroup({
    this.pageNumber,
    this.pageSize,
    this.count,
    this.data,
  });

  int? pageNumber;
  int? pageSize;
  int? count;
  List<TradingPost>? data;

  factory TradingPostGroup.fromJson(Map<String, dynamic> json) => TradingPostGroup(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    count: json["count"],
    data: List<TradingPost>.from(json["data"].map((x) => TradingPost.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "count": count,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
