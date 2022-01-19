// To parse this JSON data, do
//
//     final livenessModelUnderqualified = livenessModelUnderqualifiedFromJson(jsonString);

import 'dart:convert';

LivenessModelUnderqualified livenessModelUnderqualifiedFromJson(String str) => LivenessModelUnderqualified.fromJson(json.decode(str));

String livenessModelUnderqualifiedToJson(LivenessModelUnderqualified data) => json.encode(data.toJson());

class LivenessModelUnderqualified {
  LivenessModelUnderqualified({
     this.analyticType,
     this.jobId,
     this.message,
     this.ok,
     this.result,
     this.status,
  });

  final String? analyticType;
  final String? jobId;
  final String? message;
  final bool? ok;
  final List<Result>? result;
  final String? status;

  factory LivenessModelUnderqualified.fromJson(Map<String, dynamic> json) => LivenessModelUnderqualified(
    analyticType: json["analytic_type"],
    jobId: json["job_id"],
    message: json["message"],
    ok: json["ok"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "analytic_type": analyticType,
    "job_id": jobId,
    "message": message,
    "ok": ok,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "status": status,
  };
}

class Result {
  Result({
     this.faceLiveness,
  });

  final FaceLiveness? faceLiveness;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    faceLiveness: FaceLiveness.fromJson(json["face_liveness"]),
  );

  Map<String, dynamic> toJson() => {
    "face_liveness": faceLiveness?.toJson(),
  };
}

class FaceLiveness {
  FaceLiveness({
     this.live,
     this.liveness,
  });

  final bool? live;
  final double? liveness;

  factory FaceLiveness.fromJson(Map<String, dynamic> json) => FaceLiveness(
    live: json["live"],
    liveness: json["liveness"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "live": live,
    "liveness": liveness,
  };
}
