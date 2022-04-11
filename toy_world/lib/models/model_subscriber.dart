
import 'dart:convert';

List<Subscriber> subscriberFromJson(String str) => List<Subscriber>.from(json.decode(str).map((x) => Subscriber.fromJson(x)));

String subscriberToJson(List<Subscriber> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Subscriber {
  Subscriber({
    this.id,
    this.avatar,
    this.name,
    this.phone,
    this.status,
  });

  int? id;
  String? avatar;
  String? name;
  String? phone;
  String? status;

  factory Subscriber.fromJson(Map<String, dynamic> json) => Subscriber(
    id: json["id"],
    avatar: json["avatar"],
    name: json["name"],
    phone: json["phone"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "name": name,
    "phone": phone,
    "status": status,
  };
}
