// To parse this JSON data, do
//
//     final noFaceDetected = noFaceDetectedFromJson(jsonString);

import 'dart:convert';

NoFaceDetected noFaceDetectedFromJson(String str) => NoFaceDetected.fromJson(json.decode(str));

String noFaceDetectedToJson(NoFaceDetected data) => json.encode(data.toJson());

class NoFaceDetected {
  NoFaceDetected({
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
  final List<dynamic>? result;
  final String? status;

  factory NoFaceDetected.fromJson(Map<String, dynamic> json) => NoFaceDetected(
    analyticType: json["analytic_type"],
    jobId: json["job_id"],
    message: json["message"],
    ok: json["ok"],
    result: List<dynamic>.from(json["result"].map((x) => x)),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "analytic_type": analyticType,
    "job_id": jobId,
    "message": message,
    "ok": ok,
    "result": List<dynamic>.from(result!.map((x) => x)),
    "status": status,
  };
}
