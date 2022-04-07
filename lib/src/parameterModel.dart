// To parse this JSON data, do
//
//     final parameter = parameterFromJson(jsonString);

import 'dart:convert';

Parameter parameterFromJson(String str) => Parameter.fromJson(json.decode(str));

String parameterToJson(Parameter data) => json.encode(data.toJson());

class Parameter {
  Parameter({
    this.status,
    this.data,
    this.message,
  });

  int? status;
  List<Data>? data;
  String? message;

  factory Parameter.fromJson(Map<String, dynamic> json) => Parameter(
    status: json["status"],
    data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class Data {
  Data({
    this.deleted,
    this.id,
    this.updatedAt,
    this.background,
    this.box,
    this.button,
    this.percentage,
    this.title,
    this.attributes,
    this.operationalEnd,
    this.operationalStart,
    this.percentageLiveness,
    this.percentageSimilarity,
    this.operationalButton,
    this.textColor,
    this.warningTextColor,
  });

  bool? deleted;
  String? id;
  DateTime? updatedAt;
  String? background;
  String? box;
  String? button;
  int? percentage;
  String? title;
  List<String>? attributes;
  double? operationalEnd;
  double? operationalStart;
  int? percentageLiveness;
  int? percentageSimilarity;
  bool? operationalButton;
  String? textColor;
  String? warningTextColor;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    deleted: json["deleted"],
    id: json["_id"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    background: json["background"],
    box: json["box"],
    button: json["button"],
    percentage: json["percentage"],
    title: json["title"],
    attributes: List<String>.from(json["attributes"].map((x) => x)),
    operationalEnd: json["operationalEnd"].toDouble(),
    operationalStart: json["operationalStart"].toDouble(),
    percentageLiveness: json["percentageLiveness"],
    percentageSimilarity: json["percentageSimilarity"],
    operationalButton: json["operationalButton"],
    textColor: json["textColor"],
    warningTextColor: json["warningTextColor"],
  );

  Map<String, dynamic> toJson() => {
    "deleted": deleted,
    "_id": id,
    "updatedAt": updatedAt!.toIso8601String(),
    "background": background,
    "box": box,
    "button": button,
    "percentage": percentage,
    "title": title,
    "attributes": List<dynamic>.from(attributes!.map((x) => x)),
    "operationalEnd": operationalEnd,
    "operationalStart": operationalStart,
    "percentageLiveness": percentageLiveness,
    "percentageSimilarity": percentageSimilarity,
    "operationalButton": operationalButton,
    "textColor": textColor,
    "warningTextColor": warningTextColor,
  };
}
