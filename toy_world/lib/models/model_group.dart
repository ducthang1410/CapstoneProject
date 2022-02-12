import 'dart:convert';

List<Group> groupsFromJson(str) =>
    List<Group>.from(json.decode(str).map((x) => Group.fromJson(x)));

String groupsToJson(List<Group> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Group {
  Group({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Group.fromJson(Map<String, dynamic> json) =>
      Group(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
