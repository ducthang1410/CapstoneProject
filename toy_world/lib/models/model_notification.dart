// To parse this JSON data, do
//
//     final AccountNotifications = AccountNotificationsFromJson(jsonString);

import 'dart:convert';

AccountNotifications accountNotificationsFromJson(String str) => AccountNotifications.fromJson(json.decode(str));

String accountNotificationsToJson(AccountNotifications data) => json.encode(data.toJson());

class AccountNotifications {
  AccountNotifications({
    this.pageNumber,
    this.pageSize,
    this.count,
    this.data,
  });

  int? pageNumber;
  int? pageSize;
  int? count;
  List<AccountNotification>? data;

  factory AccountNotifications.fromJson(Map<String, dynamic> json) => AccountNotifications(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    count: json["count"],
    data: List<AccountNotification>.from(json["data"].map((x) => AccountNotification.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "count": count,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AccountNotification {
  AccountNotification({
    this.id,
    this.content,
    this.createTime,
    this.isReaded,
    this.accountId,
    this.postId,
    this.tradingPostId,
    this.postOfContestId,
    this.contestId,
    this.account,
    this.post,
    this.tradingPost,
    this.postOfContest,
    this.contest,
  });

  int? id;
  String? content;
  DateTime? createTime;
  bool? isReaded;
  int? accountId;
  int? postId;
  int? tradingPostId;
  int? postOfContestId;
  int? contestId;
  dynamic account;
  dynamic post;
  dynamic tradingPost;
  dynamic postOfContest;
  dynamic contest;

  factory AccountNotification.fromJson(Map<String, dynamic> json) => AccountNotification(
    id: json["id"],
    content: json["content"],
    createTime: DateTime.parse(json["createTime"]),
    isReaded: json["isReaded"],
    accountId: json["accountId"],
    postId: json["postId"],
    tradingPostId: json["tradingPostId"],
    postOfContestId: json["postOfContestId"],
    contestId: json["contestId"],
    account: json["account"],
    post: json["post"],
    tradingPost: json["tradingPost"],
    postOfContest: json["postOfContest"],
    contest: json["contest"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "createTime": createTime!.toIso8601String(),
    "isReaded": isReaded,
    "accountId": accountId,
    "postId": postId,
    "tradingPostId": tradingPostId,
    "postOfContestId": postOfContestId,
    "contestId": contestId,
    "account": account,
    "post": post,
    "tradingPost": tradingPost,
    "postOfContest": postOfContest,
    "contest": contest,
  };
}

