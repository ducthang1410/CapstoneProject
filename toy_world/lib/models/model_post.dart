import 'dart:convert';

List<Post> postFromJson(String str) => List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

class Post {
  Post({
    this.id,
    this.ownerId,
    this.ownerAvatar,
    this.ownerName,
    this.isLikedPost,
    this.content,
    this.publicDate,
    this.images,
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
  int? numOfReact;
  int? numOfComment;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    ownerId: json["ownerId"],
    ownerAvatar: json["ownerAvatar"],
    ownerName: json["ownerName"],
    isLikedPost: json["isLikedPost"],
    content: json["content"],
    publicDate: DateTime.parse(json["publicDate"]),
    images: List<String>.from(json["images"].map((x) => x)),
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
    "numOfReact": numOfReact,
    "numOfComment": numOfComment,
  };
}
