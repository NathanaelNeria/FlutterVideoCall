// To parse this JSON data, do
//
//     final livenessModel = livenessModelFromJson(jsonString);

import 'dart:convert';

LivenessModel livenessModelFromJson(String str) => LivenessModel.fromJson(json.decode(str));

String livenessModelToJson(LivenessModel data) => json.encode(data.toJson());

class LivenessModel {
  LivenessModel({
    this.analyticType,
    this.jobId,
    this.message,
    this.ok,
    this.result,
    this.status,
  });

  String analyticType;
  String jobId;
  String message;
  bool ok;
  List<ResultLive> result;
  String status;

  factory LivenessModel.fromJson(Map<String, dynamic> json) => LivenessModel(
    analyticType: json["analytic_type"],
    jobId: json["job_id"],
    message: json["message"],
    ok: json["ok"],
    result: List<ResultLive>.from(json["result"].map((x) => ResultLive.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "analytic_type": analyticType,
    "job_id": jobId,
    "message": message,
    "ok": ok,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
    "status": status,
  };
}

class ResultLive {
  ResultLive({
    this.faceLiveness,
    this.faceMatch,
  });

  FaceLiveness faceLiveness;
  FaceMatch faceMatch;

  factory ResultLive.fromJson(Map<String, dynamic> json) => ResultLive(
    faceLiveness: json["face_liveness"] == null ? null : FaceLiveness.fromJson(json["face_liveness"]),
    faceMatch: json["face_match"] == null ? null : FaceMatch.fromJson(json["face_match"]),
  );

  Map<String, dynamic> toJson() => {
    "face_liveness": faceLiveness == null ? null : faceLiveness.toJson(),
    "face_match": faceMatch == null ? null : faceMatch.toJson(),
  };
}

class FaceLiveness {
  FaceLiveness({
    this.live,
    this.liveness,
  });

  bool live;
  double liveness;

  factory FaceLiveness.fromJson(Map<String, dynamic> json) => FaceLiveness(
    live: json["live"],
    liveness: json["liveness"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "live": live,
    "liveness": liveness,
  };
}

class FaceMatch {
  FaceMatch({
    this.match,
    this.similarity,
  });

  bool match;
  double similarity;

  factory FaceMatch.fromJson(Map<String, dynamic> json) => FaceMatch(
    match: json["match"],
    similarity: json["similarity"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "match": match,
    "similarity": similarity,
  };
}