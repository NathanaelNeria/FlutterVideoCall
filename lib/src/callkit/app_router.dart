import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/webrtc_room/webrtc_room.dart';

import '../parameterModel.dart';
import 'package:http/http.dart' as http;

class AppRoute {
  static const videoCall = 'webrtc_room.dart';

  String urlParam = 'https://api-portal.herokuapp.com/api/v1/admin/parameter';
  String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNjIyODUxMmM5MmFmYjFmNDA2MDE5NTc2IiwidXNlcm5hbWUiOiJOYXRoYW5hZWwiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE2NDg3MTkxMjYsImV4cCI6MTY0ODg5MTkyNn0.1w2SGvqlSFV1YX-u1d-hAP9qmFTgnHVJsAsUl-glfK4';
  var response;
  Parameter parameter = Parameter();


  param() async{
    response = await http.get(Uri.parse(urlParam), headers: {'Authorization': 'Bearer $token' });

    parameter = Parameter.fromJson(jsonDecode(response.body));
  }

  Route<Object>? generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case videoCall:
        return MaterialPageRoute(
            builder: (context) =>
                WebrtcRoom(
                  scheduled: true, nik: "3175022104970010", parameter: parameter,),
            settings: settings
        );
      default:
        return null;
    }
  }
}