// To parse this JSON data, do
//
//     final rewardContest = rewardContestFromJson(jsonString);

import 'dart:convert';

import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/models/model_prize.dart';


List<RewardContest> rewardContestFromJson(String str) => List<RewardContest>.from(json.decode(str).map((x) => RewardContest.fromJson(x)));

String rewardContestToJson(List<RewardContest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RewardContest {
  RewardContest({
    this.id,
    this.rewardPost,
    this.prize,
  });

  int? id;
  RewardPost? rewardPost;
  Prize? prize;

  factory RewardContest.fromJson(Map<String, dynamic> json) => RewardContest(
    id: json["id"],
    rewardPost: RewardPost.fromJson(json["post"]),
    prize: Prize.fromJson(json["prizes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "RewardPost": rewardPost!.toJson(),
    "prizes": prize!.toJson(),
  };
}

class RewardPost {
  RewardPost({
    this.id,
    this.content,
    this.ownerAvatar,
    this.ownerName,
    this.images,
    this.sumOfStart,
  });

  int? id;
  String? content;
  String? ownerAvatar;
  String? ownerName;
  List<ImagePost>? images;
  int? sumOfStart;

  factory RewardPost.fromJson(Map<String, dynamic> json) => RewardPost(
    id: json["id"],
    content: json["content"],
    ownerAvatar: json["ownerAvatar"],
    ownerName: json["ownerName"],
    images: List<ImagePost>.from(json["images"].map((x) => ImagePost.fromJson(x))),
    sumOfStart: json["sumOfStart"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "ownerAvatar": ownerAvatar,
    "ownerName": ownerName,
    "images": List<dynamic>.from(images!.map((x) => x.toJson())),
    "sumOfStart": sumOfStart,
  };
}