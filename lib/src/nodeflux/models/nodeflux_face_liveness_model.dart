import 'package:json_annotation/json_annotation.dart';

class NodefluxFaceLivenessModel {

 final bool? live;


  final double? liveness;

  NodefluxFaceLivenessModel({
    this.live,
    this.liveness,
  });

  factory NodefluxFaceLivenessModel.fromJson(Map<String, dynamic> json) => NodefluxFaceLivenessModel(
    live: json["live"],
    liveness: json["liveness"],
  );

  Map<String, dynamic> toJson() => {
    "live": live,
    "liveness": liveness,
  };
}