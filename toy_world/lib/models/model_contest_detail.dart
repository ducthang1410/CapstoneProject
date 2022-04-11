// To parse this JSON data, do
//
//     final contestDetail = contestDetailFromJson(jsonString);

import 'dart:convert';

ContestDetail contestDetailFromJson(String str) => ContestDetail.fromJson(json.decode(str));

String contestDetailToJson(ContestDetail data) => json.encode(data.toJson());

class ContestDetail {
  ContestDetail({
    this.id,
    this.title,
    this.description,
    this.coverImage,
    this.slogan,
    this.rule,
    this.startRegistration,
    this.endRegistration,
    this.startDate,
    this.endDate,
    this.brandName,
    this.typeName,
    this.status,
    this.evaluates,
    this.isReadMore,
  });

  int? id;
  String? title;
  String? description;
  String? coverImage;
  String? slogan;
  String? rule;
  DateTime? startRegistration;
  DateTime? endRegistration;
  DateTime? startDate;
  DateTime? endDate;
  String? brandName;
  String? typeName;
  int? status;
  List<dynamic>? evaluates;
  bool? isReadMore = false;

  factory ContestDetail.fromJson(Map<String, dynamic> json) => ContestDetail(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    coverImage: json["coverImage"],
    slogan: json["slogan"],
    rule: json["rule"],
    startRegistration: DateTime.parse(json["startRegistration"]),
    endRegistration: DateTime.parse(json["endRegistration"]),
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    brandName: json["brandName"],
    typeName: json["typeName"],
    status: json["status"],
    evaluates: List<dynamic>.from(json["evaluates"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "coverImage": coverImage,
    "slogan": slogan,
    "rule": rule,
    "startRegistration": startRegistration!.toIso8601String(),
    "endRegistration": endRegistration!.toIso8601String(),
    "startDate": startDate!.toIso8601String(),
    "endDate": endDate!.toIso8601String(),
    "brandName": brandName,
    "typeName": typeName,
    "status": status,
    "evaluates": List<dynamic>.from(evaluates!.map((x) => x)),
  };
}
