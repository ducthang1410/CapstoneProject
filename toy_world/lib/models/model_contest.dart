import 'dart:convert';

import 'package:toy_world/models/model_prize.dart';

List<Contest> contestFromJson(String str) => List<Contest>.from(json.decode(str).map((x) => Contest.fromJson(x)));

class Contest {
  Contest({
    this.id,
    this.title,
    this.description,
    this.minRegistration,
    this.maxRegistration,
    this.startDate,
    this.endDate,
    this.startRegistration,
    this.endRegistration,
    this.proposalId,
    this.prizes,
    this.coverImage,
    this.slogan,
    this.status,
    this.isReadMore
  });

  int? id;
  String? title;
  String? description;
  int? minRegistration;
  int? maxRegistration;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? startRegistration;
  DateTime? endRegistration;
  int? proposalId;
  List<Prize>? prizes;
  String? coverImage;
  String? slogan;
  int? status;
  bool? isReadMore = false;

  factory Contest.fromJson(Map<String, dynamic> json) => Contest(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    startRegistration: DateTime.parse(json["startRegistration"]),
    endRegistration: DateTime.parse(json["endRegistration"]),
    proposalId: json["proposalId"],
    prizes: List<Prize>.from(json["prizes"].map((x) => Prize.fromJson(x))),
    coverImage: json["coverImage"],
    slogan: json["slogan"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "startDate": startDate!.toIso8601String(),
    "endDate": endDate!.toIso8601String(),
    "startRegistration": startRegistration!.toIso8601String(),
    "endRegistration": endRegistration!.toIso8601String(),
    "proposalId": proposalId,
    "prizes": List<dynamic>.from(prizes!.map((x) => x)),
    "coverImage": coverImage,
    "slogan": slogan,
  };
}

