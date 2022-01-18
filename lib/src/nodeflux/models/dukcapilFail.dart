// To parse this JSON data, do
//
//     final dukcapilFail = dukcapilFailFromJson(jsonString);

import 'dart:convert';

DukcapilFail dukcapilFailFromJson(String str) => DukcapilFail.fromJson(json.decode(str));

String dukcapilFailToJson(DukcapilFail data) => json.encode(data.toJson());

class DukcapilFail {
  DukcapilFail({
    required this.job,
    required this.message,
    required this.ok,
  });

  Job job;
  String message;
  bool ok;

  factory DukcapilFail.fromJson(Map<String, dynamic> json) => DukcapilFail(
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
    required this.result,
  });

  String status;
  String analyticType;
  List<dynamic> result;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    status: json["status"],
    analyticType: json["analytic_type"],
    result: List<dynamic>.from(json["result"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "analytic_type": analyticType,
    "result": List<dynamic>.from(result.map((x) => x)),
  };
}
