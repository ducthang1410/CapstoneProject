
import 'dart:convert';

FeedbackModels feedbackModelsFromJson(String str) => FeedbackModels.fromJson(json.decode(str));

String feedbackModelsToJson(FeedbackModels data) => json.encode(data.toJson());

class FeedbackModels {
  FeedbackModels({
    this.pageNumber,
    this.pageSize,
    this.count,
    this.data,
  });

  int? pageNumber;
  int? pageSize;
  int? count;
  List<FeedbackModel>? data;

  factory FeedbackModels.fromJson(Map<String, dynamic> json) => FeedbackModels(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    count: json["count"],
    data: List<FeedbackModel>.from(json["data"].map((x) => FeedbackModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "count": count,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FeedbackModel {
  FeedbackModel({
    this.id,
    this.content,
    this.senderId,
    this.senderName,
    this.senderAvatar,
    this.feedbackAbout,
    this.idForDetail,
    this.sendDate,
    this.replierId,
    this.replierName,
    this.replierAvatar,
    this.replyContent,
  });

  int? id;
  String? content;
  int? senderId;
  String? senderName;
  String? senderAvatar;
  String? feedbackAbout;
  int? idForDetail;
  DateTime? sendDate;
  int? replierId;
  String? replierName;
  String? replierAvatar;
  String? replyContent;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
    id: json["id"],
    content: json["content"],
    senderId: json["senderId"],
    senderName: json["senderName"],
    senderAvatar: json["senderAvatar"],
    feedbackAbout: json["feedbackAbout"],
    idForDetail: json["idForDetail"],
    sendDate: DateTime.parse(json["sendDate"]),
    replierId: json["replierId"],
    replierName: json["replierName"] ?? "",
    replierAvatar: json["replierAvatar"] ?? "",
    replyContent: json["replyContent"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "senderId": senderId,
    "senderName": senderName,
    "senderAvatar": senderAvatar,
    "feedbackAbout": feedbackAbout,
    "idForDetail": idForDetail,
    "sendDate": sendDate!.toIso8601String(),
    "replierId": replierId,
    "replierName": replierName ?? "",
    "replierAvatar": replierAvatar ?? "",
    "replyContent": replyContent ?? "",
  };
}
