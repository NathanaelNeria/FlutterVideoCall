// To parse this JSON data, do
//
//     final dukcapilNoImage = dukcapilNoImageFromJson(jsonString);

import 'dart:convert';

DukcapilNoImage dukcapilNoImageFromJson(String str) => DukcapilNoImage.fromJson(json.decode(str));

String dukcapilNoImageToJson(DukcapilNoImage data) => json.encode(data.toJson());

class DukcapilNoImage {
  DukcapilNoImage({
     this.analytic,
     this.code,
     this.errors,
     this.message,
     this.ok,
  });

  final String? analytic;
  final String? code;
  final List<String>? errors;
  final String? message;
  final bool? ok;

  factory DukcapilNoImage.fromJson(Map<String, dynamic> json) => DukcapilNoImage(
    analytic: json["analytic"],
    code: json["code"],
    errors: List<String>.from(json["errors"].map((x) => x)),
    message: json["message"],
    ok: json["ok"],
  );

  Map<String, dynamic> toJson() => {
    "analytic": analytic,
    "code": code,
    "errors": List<dynamic>.from(errors!.map((x) => x)),
    "message": message,
    "ok": ok,
  };
}
