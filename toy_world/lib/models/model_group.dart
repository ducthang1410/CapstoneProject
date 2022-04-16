import 'dart:convert';

List<Group> groupsFromJson(str) =>
    List<Group>.from(json.decode(str).map((x) => Group.fromJson(x)));

String groupsToJson(List<Group> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Group {
  Group({
    this.id,
    this.name,
    this.description,
    this.coverImage,
  });

  int? id;
  String? name;
  String? description;
  String? coverImage;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        coverImage: json["coverImage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "coverImage": coverImage,
      };
}
