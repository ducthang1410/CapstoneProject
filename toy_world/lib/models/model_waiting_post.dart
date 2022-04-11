import 'dart:convert';

import 'package:toy_world/models/model_image_post.dart';

WaitingPosts waitingPostsFromJson(String str) => WaitingPosts.fromJson(json.decode(str));

String waitingPostsToJson(WaitingPosts data) => json.encode(data.toJson());

class WaitingPosts {
  WaitingPosts({
    this.pageNumber,
    this.pageSize,
    this.count,
    this.data,
  });

  int? pageNumber;
  int? pageSize;
  int? count;
  List<WaitingPost>? data;

  factory WaitingPosts.fromJson(Map<String, dynamic> json) => WaitingPosts(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    count: json["count"],
    data: List<WaitingPost>.from(json["data"].map((x) => WaitingPost.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "count": count,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class WaitingPost {
  WaitingPost({
    this.id,
    this.ownerId,
    this.ownerAvatar,
    this.ownerName,
    this.content,
    this.postDate,
    this.images,
    this.isReadMore
  });

  int? id;
  int? ownerId;
  String? ownerAvatar;
  String? ownerName;
  String? content;
  DateTime? postDate;
  List<ImagePost>? images;
  bool? isReadMore = false;

  factory WaitingPost.fromJson(Map<String, dynamic> json) => WaitingPost(
    id: json["id"],
    ownerId: json["ownerId"],
    ownerAvatar: json["ownerAvatar"],
    ownerName: json["ownerName"],
    content: json["content"],
    postDate: DateTime.parse(json["postDate"]),
    images: List<ImagePost>.from(json["images"].map((x) => ImagePost.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ownerId": ownerId,
    "ownerAvatar": ownerAvatar,
    "ownerName": ownerName,
    "content": content,
    "postDate": postDate!.toIso8601String(),
    "images": List<dynamic>.from(images!.map((x) => x.toJson())),
  };
}