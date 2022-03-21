import 'dart:convert';

List<ImagePost> imagesFromJson(str) =>
    List<ImagePost>.from(json.decode(str).map((x) => ImagePost.fromJson(x)));

String imagesToJson(List<ImagePost> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImagePost {
  ImagePost({
    this.id,
    this.url,
  });

  int? id;
  String? url;

  factory ImagePost.fromJson(Map<String, dynamic> json) => ImagePost(
    id: json["id"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
  };
}
