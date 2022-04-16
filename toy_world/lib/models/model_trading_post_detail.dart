// To parse this JSON data, do
//
//     final tradingPostDetail = tradingPostDetailFromJson(jsonString);

import 'dart:convert';

import 'package:toy_world/models/model_comment.dart';
import 'package:toy_world/models/model_image_post.dart';

TradingPostDetail tradingPostDetailFromJson(String str) => TradingPostDetail.fromJson(json.decode(str));

String tradingPostDetailToJson(TradingPostDetail data) => json.encode(data.toJson());

class TradingPostDetail {
  TradingPostDetail({
    this.id,
    this.title,
    this.toyName,
    this.content,
    this.address,
    this.trading,
    this.value,
    this.phone,
    this.postDate,
    this.status,
    this.groupId,
    this.ownerId,
    this.ownerName,
    this.ownerAvatar,
    this.toyId,
    this.typeName,
    this.brandName,
    this.images,
    this.comment,
    this.isReact,
    this.numOfReact,
    this.numOfComment,
    this.isReadMore
  });

  int? id;
  String? title;
  String? toyName;
  String? content;
  String? address;
  String? trading;
  double? value;
  String? phone;
  DateTime? postDate;
  int? status;
  int? groupId;
  int? ownerId;
  String? ownerName;
  String? ownerAvatar;
  int? toyId;
  String? typeName;
  String? brandName;
  List<ImagePost>? images;
  List<Comment>? comment;
  bool? isReact;
  int? numOfReact;
  int? numOfComment;
  bool? isReadMore = false;

  factory TradingPostDetail.fromJson(Map<String, dynamic> json) => TradingPostDetail(
    id: json["id"],
    title: json["title"],
    toyName: json["toyName"],
    content: json["content"],
    address: json["address"],
    trading: json["trading"],
    value: json["value"].toDouble(),
    phone: json["phone"],
    postDate: DateTime.parse(json["postDate"]),
    status: json["status"],
    groupId: json["groupId"],
    ownerId: json["ownerId"],
    ownerName: json["ownerName"],
    ownerAvatar: json["ownerAvatar"],
    toyId: json["toyId"],
    typeName: json["typeName"],
    brandName: json["brandName"],
    images: List<ImagePost>.from(json["images"].map((x) => ImagePost.fromJson(x))),
    comment: List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
    isReact: json["isReact"],
    numOfReact: json["numOfReact"],
    numOfComment: json["numOfComment"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "toyName": toyName,
    "content": content,
    "address": address,
    "trading": trading,
    "value": value,
    "phone": phone,
    "postDate": postDate!.toIso8601String(),
    "status": status,
    "groupId": groupId,
    "ownerId": ownerId,
    "ownerName": ownerName,
    "ownerAvatar": ownerAvatar,
    "toyId": toyId,
    "typeName": typeName,
    "brandName": brandName,
    "images": List<dynamic>.from(images!.map((x) => x.toJson())),
    "comment": List<dynamic>.from(comment!.map((x) => x)),
    "isReact": isReact,
    "numOfReact": numOfReact,
    "numOfComment": numOfComment,
  };
}

