import 'dart:convert';

BillCreated billCreatedFromJson(String str) => BillCreated.fromJson(json.decode(str));

String billCreatedToJson(BillCreated data) => json.encode(data.toJson());

class BillCreated {
  BillCreated({
    this.billId,
  });

  int? billId;

  factory BillCreated.fromJson(Map<String, dynamic> json) => BillCreated(
    billId: json["billId"],
  );

  Map<String, dynamic> toJson() => {
    "billId": billId,
  };
}