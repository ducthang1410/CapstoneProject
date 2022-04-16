// To parse this JSON data, do
//
//     final accountInfo = accountInfoFromJson(jsonString);

import 'dart:convert';

AccountInfo accountInfoFromJson(String str) => AccountInfo.fromJson(json.decode(str));

String accountInfoToJson(AccountInfo data) => json.encode(data.toJson());

class AccountInfo {
  AccountInfo({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.biography,
    this.gender,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  String? avatar;
  String? biography;
  String? gender;

  factory AccountInfo.fromJson(Map<String, dynamic> json) => AccountInfo(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    avatar: json["avatar"],
    biography: json["biography"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "avatar": avatar,
    "biography": biography,
    "gender": gender,
  };
}
