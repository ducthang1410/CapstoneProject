import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({this.avatar, this.noOfPost, this.noOfFollowing, this.noOfFollower});

  String? avatar;
  int? noOfPost;
  int? noOfFollowing;
  int? noOfFollower;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      avatar: json["avatar"],
      noOfPost: json["noOfPost"],
      noOfFollowing: json["noOfFollowing"],
      noOfFollower: json["noOfFollower"]);

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "noOfPost": noOfPost,
        "noOfFollowing": noOfFollowing,
        "noOfFollower": noOfFollower,
      };
}
