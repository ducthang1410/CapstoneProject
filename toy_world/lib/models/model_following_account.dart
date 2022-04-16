// To parse this JSON data, do
//
//     final followingAccount = followingAccountFromJson(jsonString);

import 'dart:convert';

List<FollowingAccount> followingAccountFromJson(String str) => List<FollowingAccount>.from(json.decode(str).map((x) => FollowingAccount.fromJson(x)));

String followingAccountToJson(List<FollowingAccount> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FollowingAccount {
  FollowingAccount({
    this.id,
    this.name,
    this.avatar,
  });

  int? id;
  String? name;
  String? avatar;

  factory FollowingAccount.fromJson(Map<String, dynamic> json) => FollowingAccount(
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
