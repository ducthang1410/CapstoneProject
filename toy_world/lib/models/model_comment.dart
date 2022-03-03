import 'dart:convert';

List<Comment> groupsFromJson(str) =>
    List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String groupsToJson(List<Comment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
  Comment({
    this.id,
    this.content,
    this.ownerName,
    this.ownerAvatar,
    this.numOfReact,
  });

  int? id;
  String? content;
  String? ownerName;
  String? ownerAvatar;
  int? numOfReact;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    content: json["content"],
    ownerName: json["ownerName"],
    ownerAvatar: json["ownerAvatar"],
    numOfReact: json["numOfReact"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "ownerName": ownerName,
    "ownerAvatar": ownerAvatar,
    "numOfReact": numOfReact,
  };
}
