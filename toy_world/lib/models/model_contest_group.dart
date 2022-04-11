import 'dart:convert';

import 'package:toy_world/models/model_contest.dart';

ContestGroup contestGroupFromJson(String str) => ContestGroup.fromJson(json.decode(str));

String contestGroupToJson(ContestGroup data) => json.encode(data.toJson());

class ContestGroup {
  ContestGroup({
    this.pageNumber,
    this.pageSize,
    this.count,
    this.data,
  });

  int? pageNumber;
  int? pageSize;
  int? count;
  List<Contest>? data;

  factory ContestGroup.fromJson(Map<String, dynamic> json) => ContestGroup(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    count: json["count"],
    data: List<Contest>.from(json["data"].map((x) => Contest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "count": count,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

