// To parse this JSON data, do
//
//     final billsStatus = billsStatusFromJson(jsonString);

import 'dart:convert';

import 'package:toy_world/models/model_image_post.dart';

BillsStatus billsStatusFromJson(String str) =>
    BillsStatus.fromJson(json.decode(str));

String billsStatusToJson(BillsStatus data) => json.encode(data.toJson());

class BillsStatus {
  BillsStatus({
    this.pageNumber,
    this.pageSize,
    this.count,
    this.data,
  });

  int? pageNumber;
  int? pageSize;
  int? count;
  List<BillStatus>? data;

  factory BillsStatus.fromJson(Map<String, dynamic> json) => BillsStatus(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        count: json["count"],
        data: List<BillStatus>.from(
            json["data"].map((x) => BillStatus.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "count": count,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class BillStatus {
  BillStatus({
    this.id,
    this.senderName,
    this.receiverName,
    this.senderToy,
    this.receiverToy,
    this.postTitle,
    this.idPost,
    this.status,
    this.updateTime,
    this.images,
  });

  int? id;
  String? senderName;
  String? receiverName;
  String? senderToy;
  String? receiverToy;
  String? postTitle;
  int? idPost;
  int? status;
  DateTime? updateTime;
  List<ImagePost>? images;

  factory BillStatus.fromJson(Map<String, dynamic> json) => BillStatus(
        id: json["id"],
        senderName: json["senderName"],
        receiverName: json["receiverName"],
        senderToy: json["senderToy"],
        receiverToy: json["receiverToy"] ?? "",
        postTitle: json["postTitle"],
        idPost: json["idPost"],
        status: json["status"],
        updateTime: DateTime.parse(json["updateTime"]),
        images: List<ImagePost>.from(
            json["images"].map((x) => ImagePost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "senderName": senderName,
        "receiverName": receiverName,
        "senderToy": senderToy,
        "receiverToy": receiverToy,
        "postTitle": postTitle,
        "idPost": idPost,
        "status": status,
        "updateTime": updateTime!.toIso8601String(),
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}
