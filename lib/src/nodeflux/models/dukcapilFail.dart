// To parse this JSON data, do
//
//     final dukcapilFail = dukcapilFailFromJson(jsonString);

import 'dart:convert';

DukcapilFail dukcapilFailFromJson(String str) => DukcapilFail.fromJson(json.decode(str));

String dukcapilFailToJson(DukcapilFail data) => json.encode(data.toJson());

class DukcapilFail {
  DukcapilFail({
     this.job,
     this.message,
     this.ok,
  });

  final Job? job;
  final String? message;
  final bool? ok;

  factory DukcapilFail.fromJson(Map<String, dynamic> json) => DukcapilFail(
    job: Job.fromJson(json["job"]),
    message: json["message"],
    ok: json["ok"],
  );

  Map<String, dynamic> toJson() => {
    "job": job?.toJson(),
    "message": message,
    "ok": ok,
  };
}

class Job {
  Job({
     this.id,
     this.result,
  });

  final String? id;
  final Result? result;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    id: json["id"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "result": result?.toJson(),
  };
}

class Result {
  Result({
     this.status,
     this.analyticType,
     this.result,
  });

  final String? status;
  final String? analyticType;
  final List<dynamic>? result;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    status: json["status"],
    analyticType: json["analytic_type"],
    result: List<dynamic>.from(json["result"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "analytic_type": analyticType,
    "result": List<dynamic>.from(result!.map((x) => x)),
  };
}
