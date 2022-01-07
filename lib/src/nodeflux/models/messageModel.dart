// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  MessageModel({
    this.message,
    this.ok,
    this.status,
  });

  String message;
  bool ok;
  String status;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    message: json["message"],
    ok: json["ok"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "ok": ok,
    "status": status,
  };
}
