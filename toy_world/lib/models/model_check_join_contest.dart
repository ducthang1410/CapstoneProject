// To parse this JSON data, do
//
//     final CheckJoinContest = CheckJoinContestFromJson(jsonString);

import 'dart:convert';

CheckJoinContest checkJoinContestFromJson(String str) => CheckJoinContest.fromJson(json.decode(str));

String checkJoinContestToJson(CheckJoinContest data) => json.encode(data.toJson());

class CheckJoinContest {
  CheckJoinContest({
    this.isJoinedToContest,
  });

  bool? isJoinedToContest;

  factory CheckJoinContest.fromJson(Map<String, dynamic> json) => CheckJoinContest(
    isJoinedToContest: json["isJoinedToContest"],
  );

  Map<String, dynamic> toJson() => {
    "isJoinedToContest": isJoinedToContest,
  };
}
