import 'dart:convert';

Agent1 agent1FromJson(String str) => Agent1.fromJson(json.decode(str));

String agent1ToJson(Agent1 data) => json.encode(data.toJson());

class Agent1 {
  Agent1({
    this.vcHandled,
    this.inCall,
    this.loggedIn,
  });

  int? vcHandled;
  bool? inCall;
  bool? loggedIn;

  factory Agent1.fromJson(Map<String, dynamic> json) => Agent1(
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
