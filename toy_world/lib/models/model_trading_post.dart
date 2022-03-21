import 'dart:convert';

import 'model_image_post.dart';

List<TradingPost> tradingPostFromJson(String str) => List<TradingPost>.from(json.decode(str).map((x) => TradingPost.fromJson(x)));

class TradingPost {
  TradingPost({
    this.id,
    this.ownerId,
    this.ownerAvatar,
    this.ownerName,
    this.postDate,
    this.toyName,
    this.type,
    this.brand,
    this.address,
    this.content,
    this.exchange,
    this.value,
    this.images,
    this.noOfReact,
    this.noOfComment,
    this.isLikedPost,
  });

  int? id;
  int? ownerId;
  String? ownerAvatar;
  String? ownerName;
  DateTime? postDate;
  String? toyName;
  String? type;
  String? brand;
  String? address;
  String? content;
  String? exchange;
  double? value;
  List<ImagePost>? images;
  int? noOfReact;
  int? noOfComment;
  bool? isLikedPost;

  factory TradingPost.fromJson(Map<String, dynamic> json) => TradingPost(
    id: json["id"],
    ownerId: json["ownerId"],
    ownerAvatar: json["ownerAvatar"],
    ownerName: json["ownerName"],
    postDate: DateTime.parse(json["postDate"]),
    toyName: json["toyName"],
    type: json["type"],
    brand: json["brand"],
    address: json["address"],
    content: json["content"],
    exchange: json["exchange"],
    value: json["value"],
    images: List<ImagePost>.from(json["images"].map((x) => ImagePost.fromJson(x))),
    noOfReact: json["noOfReact"],
    noOfComment: json["noOfComment"],
    isLikedPost: json["isLikedPost"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ownerId": ownerId,
    "ownerAvatar": ownerAvatar,
    "ownerName": ownerName,
    "postDate": postDate!.toIso8601String(),
    "toyName": toyName,
    "type": type,
    "brand": brand,
    "address": address,
    "content": content,
    "exchange": exchange,
    "value": value,
    "images": List<dynamic>.from(images!.map((x) => x.toJson())),
    "noOfReact": noOfReact,
    "noOfComment": noOfComment,
    "isLikedPost": isLikedPost,
  };
}