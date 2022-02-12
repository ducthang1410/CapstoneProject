import 'dart:convert';

ModelLogin loginFromJson(String str) => ModelLogin.fromJson(json.decode(str));

String loginToJson(ModelLogin data) => json.encode(data.toJson());

class ModelLogin {
  ModelLogin({
    this.accountId,
    this.avatar,
    this.name,
    this.role,
    this.status,
    this.token,
  });

  int? accountId;
  String? avatar;
  String? name;
  int? role;
  bool? status;
  String? token;

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
        accountId: json["accountId"],
        avatar: json["avatar"],
        name: json["name"],
        role: json["role"],
        status: json["status"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "accountId": accountId,
        "avatar": avatar,
        "name": name,
        "role": role,
        "status": status,
        "token": token,
      };
}
