// To parse this JSON data, do
//
//     final dukcapilFaceMatch = dukcapilFaceMatchFromJson(jsonString);

import 'dart:convert';

DukcapilFaceMatch dukcapilFaceMatchFromJson(String str) => DukcapilFaceMatch.fromJson(json.decode(str));

String dukcapilFaceMatchToJson(DukcapilFaceMatch data) => json.encode(data.toJson());

class DukcapilFaceMatch {
  DukcapilFaceMatch({
     this.job,
     this.message,
     this.ok,
  });

  final Job? job;
  final String? message;
  final bool? ok;

  factory DukcapilFaceMatch.fromJson(Map<String, dynamic> json) => DukcapilFaceMatch(
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
  final JobResult? result;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    id: json["id"],
    result: JobResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "result": result?.toJson(),
  };
}

class JobResult {
  JobResult({
     this.status,
     this.analyticType,
     this.result,
  });

  final String? status;
  final String? analyticType;
  final List<ResultElement>? result;

  factory JobResult.fromJson(Map<String, dynamic> json) => JobResult(
    status: json["status"],
    analyticType: json["analytic_type"],
    result: List<ResultElement>.from(json["result"].map((x) => ResultElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "analytic_type": analyticType,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class ResultElement {
  ResultElement({
     this.faceMatch,
  });

  final FaceMatch? faceMatch;

  factory ResultElement.fromJson(Map<String, dynamic> json) => ResultElement(
    faceMatch: FaceMatch.fromJson(json["face_match"]),
  );

  Map<String, dynamic> toJson() => {
    "face_match": faceMatch?.toJson(),
  };
}

class FaceMatch {
  FaceMatch({
     this.similarity,
  });

  final double? similarity;

  factory FaceMatch.fromJson(Map<String, dynamic> json) => FaceMatch(
    similarity: json["similarity"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "similarity": similarity,
  };
}
