import 'dart:convert';

import 'package:toy_world/models/model_image_post.dart';

List<Prize> prizeFromJson(String str) => List<Prize>.from(json.decode(str).map((x) => Prize.fromJson(x)));

class Prize {
  Prize({
    this.id,
    this.name,
    this.description,
    this.value,
    this.images,
  });

  int? id;
  String? name;
  String? description;
  String? value;
  List<ImagePost>? images;

  factory Prize.fromJson(Map<String, dynamic> json) => Prize(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    value: json["value"],
    images: List<ImagePost>.from(json["images"].map((x) => ImagePost.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "value": value,
    "images": List<dynamic>.from(images!.map((x) => x)),
  };
}
