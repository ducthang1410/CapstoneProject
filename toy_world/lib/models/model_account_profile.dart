
import 'dart:convert';

AccountDetail accountDetailFromJson(String str) => AccountDetail.fromJson(json.decode(str));

String accountDetailToJson(AccountDetail data) => json.encode(data.toJson());

class AccountDetail {
  AccountDetail({
    this.avatar,
    this.noOfPost,
    this.noOfFollowing,
    this.noOfFollower,
    this.isFollowed,
    this.biography,
    this.name,
  });

  String? avatar;
  int? noOfPost;
  int? noOfFollowing;
  int? noOfFollower;
  bool? isFollowed;
  String? biography;
  String? name;

  factory AccountDetail.fromJson(Map<String, dynamic> json) => AccountDetail(
    avatar: json["avatar"],
    noOfPost: json["noOfPost"],
    noOfFollowing: json["noOfFollowing"],
    noOfFollower: json["noOfFollower"],
    isFollowed: json["isFollowed"],
    biography: json["biography"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "avatar": avatar,
    "noOfPost": noOfPost,
    "noOfFollowing": noOfFollowing,
    "noOfFollower": noOfFollower,
    "isFollowed": isFollowed,
    "biography": biography,
    "name": name,
  };
}
