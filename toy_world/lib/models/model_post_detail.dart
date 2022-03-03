import 'dart:convert';

import 'model_comment.dart';

PostDetail postDetailFromJson(String str) => PostDetail.fromJson(json.decode(str));

String postDetailToJson(PostDetail data) => json.encode(data.toJson());

class PostDetail {
  PostDetail({
    this.id,
    this.ownerId,
    this.ownerAvatar,
    this.ownerName,
    this.isLikedPost,
    this.content,
    this.publicDate,
    this.images,
    this.comments,
    this.numOfReact,
    this.numOfComment,
  });

  int? id;
  int? ownerId;
  String? ownerAvatar;
  String? ownerName;
  bool? isLikedPost;
  String? content;
  DateTime? publicDate;
  List<String>? images;
  List<Comment>? comments;
  int? numOfReact;
  int? numOfComment;

  factory PostDetail.fromJson(Map<String, dynamic> json) => PostDetail(
    id: json["id"],
    ownerId: json["ownerId"],
    ownerAvatar: json["ownerAvatar"],
    ownerName: json["ownerName"],
    isLikedPost: json["isLikedPost"],
    content: json["content"],
    publicDate: DateTime.parse(json["publicDate"]),
    images: List<String>.from(json["images"].map((x) => x)),
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    numOfReact: json["numOfReact"],
    numOfComment: json["numOfComment"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ownerId": ownerId,
    "ownerAvatar": ownerAvatar,
    "ownerName": ownerName,
    "isLikedPost": isLikedPost,
    "content": content,
    "publicDate": publicDate!.toIso8601String(),
    "images": List<String>.from(images!.map((x) => x)),
    "comments": List<Comment>.from(comments!.map((x) => x.toJson())),
    "numOfReact": numOfReact,
    "numOfComment": numOfComment,
  };
}
