// To parse this JSON data, do
//
//     final FollowerAccount = FollowerAccountFromJson(jsonString);

import 'dart:convert';

List<FollowerAccount> followerAccountFromJson(String str) => List<FollowerAccount>.from(json.decode(str).map((x) => FollowerAccount.fromJson(x)));

String followerAccountToJson(List<FollowerAccount> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FollowerAccount {
  FollowerAccount({
    this.id,
    this.name,
    this.avatar,
  });

  int? id;
  String? name;
  String? avatar;

  factory FollowerAccount.fromJson(Map<String, dynamic> json) => FollowerAccount(
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
  };
}
