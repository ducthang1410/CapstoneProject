class Comment {
  Comment({
    this.id,
    this.content,
    this.ownerId,
    this.ownerName,
    this.ownerAvatar,
    this.numOfReact,
    this.commentDate,
    this.isReacted,
  });

  int? id;
  String? content;
  int? ownerId;
  String? ownerName;
  String? ownerAvatar;
  int? numOfReact;
  DateTime? commentDate;
  bool? isReacted;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    content: json["content"],
    ownerId: json["ownerId"],
    ownerName: json["ownerName"],
    ownerAvatar: json["ownerAvatar"],
    numOfReact: json["numOfReact"],
    commentDate: DateTime.parse(json["commentDate"]),
    isReacted: json["isReacted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "ownerId": ownerId,
    "ownerName": ownerName,
    "ownerAvatar": ownerAvatar,
    "numOfReact": numOfReact,
    "commentDate": commentDate!.toIso8601String(),
    "isReacted": isReacted,
  };
}