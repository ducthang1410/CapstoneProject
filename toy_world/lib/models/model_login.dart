import 'dart:convert';

ModelLogin loginFromJson(String str) => ModelLogin.fromJson(json.decode(str));

String loginToJson(ModelLogin data) => json.encode(data.toJson());

class ModelLogin {
  ModelLogin({
    this.accountId,
    this.avatar,
    this.name,
    this.biography,
    this.email,
    this.phoneNumber,
    this.gender,
    this.role,
    this.status,
    this.token,
  });

  int? accountId;
  String? avatar;
  String? name;
  String? biography;
  String? email;
  String? phoneNumber;
  String? gender;
  int? role;
  bool? status;
  String? token;

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
        accountId: json["accountId"],
        avatar: json["avatar"],
        name: json["name"],
        biography: json["biography"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        gender: json["gender"],
        role: json["role"],
        status: json["status"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "accountId": accountId,
        "avatar": avatar,
        "name": name,
        "biography": biography,
        "email": email,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "role": role,
        "status": status,
        "token": token,
      };
}
