// To parse this JSON data, do
//
//     final facePairNotMatch = facePairNotMatchFromJson(jsonString);

import 'dart:convert';

FacePairNotMatch facePairNotMatchFromJson(String str) => FacePairNotMatch.fromJson(json.decode(str));

String facePairNotMatchToJson(FacePairNotMatch data) => json.encode(data.toJson());

class FacePairNotMatch {
  FacePairNotMatch({
     this.analyticType,
     this.jobId,
     this.message,
     this.ok,
     this.result,
     this.status,
  });

  final String? analyticType;
  final String?jobId;
  final String? message;
  final bool? ok;
  final List<Result>? result;
  final String?status;

  factory FacePairNotMatch.fromJson(Map<String, dynamic> json) => FacePairNotMatch(
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
    required this.faceLiveness,
    required this.faceMatch,
  });

  FaceLiveness faceLiveness;
  FaceMatch faceMatch;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
    required this.live,
    required this.liveness,
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
    required this.match,
    required this.similarity,
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