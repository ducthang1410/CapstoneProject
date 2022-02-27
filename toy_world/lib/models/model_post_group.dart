
import 'dart:convert';
import 'model_post.dart';



PostGroup postGroupFromJson(String str) => PostGroup.fromJson(json.decode(str));

String postGroupToJson(PostGroup data) => json.encode(data.toJson());

class PostGroup {
  PostGroup({
    this.pageNumber,
    this.pageSize,
    this.count,
    this.data,
  });

  int? pageNumber;
  int? pageSize;
  int? count;
  List<Post>? data;

  factory PostGroup.fromJson(Map<String, dynamic> json) => PostGroup(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    count: json["count"],
    data: List<Post>.from(json["data"].map((x) => Post.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "count": count,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

