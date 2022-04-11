
import 'dart:convert';

import 'package:toy_world/models/model_image_post.dart';

ContestPosts contestPostsFromJson(String str) => ContestPosts.fromJson(json.decode(str));

String contestPostsToJson(ContestPosts data) => json.encode(data.toJson());

class ContestPosts {
  ContestPosts({
    this.pageNumber,
    this.pageSize,
    this.count,
    this.data,
  });

  int? pageNumber;
  int? pageSize;
  int? count;
  List<ContestPost>? data;

  factory ContestPosts.fromJson(Map<String, dynamic> json) => ContestPosts(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        count: json["count"],
        data: List<ContestPost>.from(
            json["data"].map((x) => ContestPost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "count": count,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ContestPost {
  ContestPost(
      {this.id,
      this.content,
      this.ownerAvatar,
      this.ownerName,
      this.averageStar,
      this.isRated,
      this.rates,
      this.images,
      this.isReadMore});

  int? id;
  String? content;
  String? ownerAvatar;
  String? ownerName;
  double? averageStar;
  bool? isRated;
  List<Rate>? rates;
  List<ImagePost>? images;
  bool? isReadMore = false;

  factory ContestPost.fromJson(Map<String, dynamic> json) => ContestPost(
        id: json["id"],
        content: json["content"],
        ownerAvatar: json["ownerAvatar"],
        ownerName: json["ownerName"],
        averageStar: json["averageStar"].toDouble(),
        isRated: json["isRated"],
        rates: List<Rate>.from(json["rates"].map((x) => Rate.fromJson(x))),
        images: List<ImagePost>.from(
           json["images"].map((x) => ImagePost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "ownerAvatar": ownerAvatar,
        "ownerName": ownerName,
        "averageStar": averageStar,
        "isRated": isRated,
        "rates": List<dynamic>.from(rates!.map((x) => x.toJson())),
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class Rate {
  Rate({
    this.id,
    this.numOfStar,
    this.note,
    this.ownerId,
    this.ownerAvatar,
    this.ownerName,
  });

  int? id;
  double? numOfStar;
  String? note;
  int? ownerId;
  String? ownerAvatar;
  String? ownerName;

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        id: json["id"],
        numOfStar: json["numOfStar"].toDouble(),
        note: json["note"],
        ownerId: json["ownerId"],
        ownerAvatar: json["ownerAvatar"],
        ownerName: json["ownerName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "numOfStar": numOfStar,
        "note": note,
        "ownerId": ownerId,
        "ownerAvatar": ownerAvatar,
        "ownerName": ownerName,
      };
}
