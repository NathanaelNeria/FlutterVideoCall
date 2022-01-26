import 'dart:convert';

Agent2 agent2FromJson(String str) => Agent2.fromJson(json.decode(str));

String agent2ToJson(Agent2 data) => json.encode(data.toJson());

class Agent2 {
  Agent2({
    this.vcHandled,
    this.inCall,
    this.loggedIn,
  });

  int? vcHandled;
  bool? inCall;
  bool? loggedIn;

  factory Agent2.fromJson(Map<String, dynamic> json) => Agent2(
    vcHandled: json["VCHandled"],
    inCall: json["inCall"],
    loggedIn: json["loggedIn"],
  );

  Map<String, dynamic> toJson() => {
    "VCHandled": vcHandled,
    "inCall": inCall,
    "loggedIn": loggedIn,
  };
}
