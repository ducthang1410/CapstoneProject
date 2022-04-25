// To parse this JSON data, do
//
//     final waitingSubmissions = waitingSubmissionsFromJson(jsonString);

import 'dart:convert';

import 'package:toy_world/models/model_image_post.dart';

WaitingSubmissions waitingSubmissionsFromJson(String str) => WaitingSubmissions.fromJson(json.decode(str));

String waitingSubmissionsToJson(WaitingSubmissions data) => json.encode(data.toJson());

class WaitingSubmissions {
  WaitingSubmissions({
    this.pageNumber,
    this.pageSize,
    this.count,
    this.data,
  });

  int? pageNumber;
  int? pageSize;
  int? count;
  List<WaitingSubmission>? data;

  factory WaitingSubmissions.fromJson(Map<String, dynamic> json) => WaitingSubmissions(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    count: json["count"],
    data: List<WaitingSubmission>.from(json["data"].map((x) => WaitingSubmission.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "count": count,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class WaitingSubmission {
  WaitingSubmission({
    this.id,
    this.contestId,
    this.content,
    this.dateCreate,
    this.status,
    this.ownerId,
    this.ownerName,
    this.ownerAvatar,
    this.images,
    this.isReadMore
  });

  int? id;
  int? contestId;
  String? content;
  DateTime? dateCreate;
  int? status;
  int? ownerId;
  String? ownerName;
  String? ownerAvatar;
  List<ImagePost>? images;
  bool? isReadMore = false;

  factory WaitingSubmission.fromJson(Map<String, dynamic> json) => WaitingSubmission(
    id: json["id"],
    contestId: json["contestId"],
    content: json["content"],
    dateCreate: DateTime.parse(json["dateCreate"]),
    status: json["status"],
    ownerId: json["ownerId"],
    ownerName: json["ownerName"],
    ownerAvatar: json["ownerAvatar"],
    images: List<ImagePost>.from(json["images"].map((x) => ImagePost.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "contestId": contestId,
    "content": content,
    "dateCreate": dateCreate!.toIso8601String(),
    "status": status,
    "ownerId": ownerId,
    "ownerName": ownerName,
    "ownerAvatar": ownerAvatar,
    "images": List<dynamic>.from(images!.map((x) => x.toJson())),
  };
}
