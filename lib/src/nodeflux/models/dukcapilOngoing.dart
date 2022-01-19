// To parse this JSON data, do
//
//     final dukcapilOngoing = dukcapilOngoingFromJson(jsonString);

import 'dart:convert';

DukcapilOngoing dukcapilOngoingFromJson(String str) => DukcapilOngoing.fromJson(json.decode(str));

String dukcapilOngoingToJson(DukcapilOngoing data) => json.encode(data.toJson());

class DukcapilOngoing {
  DukcapilOngoing({
    required this.job,
    required this.message,
    required this.ok,
  }) {
    // TODO: implement
    throw UnimplementedError();
  }

  Job job;
  String message;
  bool ok;

  factory DukcapilOngoing.fromJson(Map<String, dynamic> json) => DukcapilOngoing(
    job: Job.fromJson(json["job"]),
    message: json["message"],
    ok: json["ok"],
  );

  Map<String, dynamic> toJson() => {
    "job": job.toJson(),
    "message": message,
    "ok": ok,
  };
}

class Job {
  Job({
    required this.id,
    required this.result,
  });

  String id;
  Result result;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    id: json["id"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "result": result.toJson(),
  };
}

class Result {
  Result({
    required this.status,
    required this.analyticType,
  });

  String status;
  String analyticType;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    status: json["status"],
    analyticType: json["analytic_type"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "analytic_type": analyticType,
  };
}
