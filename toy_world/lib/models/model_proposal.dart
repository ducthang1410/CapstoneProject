// To parse this JSON data, do
//
//     final proposals = proposalsFromJson(jsonString);

import 'dart:convert';

Proposals proposalsFromJson(String str) => Proposals.fromJson(json.decode(str));

String proposalsToJson(Proposals data) => json.encode(data.toJson());

List<Proposal> proposalFromJson(String str) => List<Proposal>.from(json.decode(str).map((x) => Proposal.fromJson(x)));

String proposalToJson(List<Proposal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Proposals {
  Proposals({
    this.pageNumber,
    this.pageSize,
    this.count,
    this.data,
  });

  int? pageNumber;
  int? pageSize;
  int? count;
  List<Proposal>? data;

  factory Proposals.fromJson(Map<String, dynamic> json) => Proposals(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    count: json["count"],
    data: List<Proposal>.from(json["data"].map((x) => Proposal.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "count": count,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Proposal {
  Proposal({
    this.id,
    this.reason,
    this.groupId,
    this.title,
    this.description,
    this.rule,
    this.slogan,
    this.ownerId,
    this.ownerName,
    this.ownerAvatar,
    this.isReadMore,
  });

  int? id;
  String? reason;
  int? groupId;
  String? title;
  String? description;
  String? rule;
  String? slogan;
  int? ownerId;
  String? ownerName;
  String? ownerAvatar;
  bool? isReadMore = false;

  factory Proposal.fromJson(Map<String, dynamic> json) => Proposal(
    id: json["id"],
    reason: json["reason"],
    groupId: json["groupId"],
    title: json["title"],
    description: json["description"],
    rule: json["rule"],
    slogan: json["slogan"],
    ownerId: json["ownerId"],
    ownerName: json["ownerName"],
    ownerAvatar: json["ownerAvatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reason": reason,
    "groupId": groupId,
    "title": title,
    "description": description,
    "rule": rule,
    "slogan": slogan,
    "ownerId": ownerId,
    "ownerName": ownerName,
    "ownerAvatar": ownerAvatar
  };
}
