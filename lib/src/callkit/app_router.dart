import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/pages/welcomePage.dart';
import 'package:flutter_webrtc_demo/src/parameterModel.dart';
import 'home_page.dart';
import 'calling_page.dart';
import '../pages/welcomePage.dart';
import 'package:http/http.dart' as http;

class AppRoute {
  static const homePage = 'home_page.dart';

  static const callingPage = 'calling_page.dart';

  static const welcomePage = 'welcomePage.dart';

  // String urlParam = 'https://api-portal.herokuapp.com/api/v1/admin/parameter';
  // String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNjIyODUxMmM5MmFmYjFmNDA2MDE5NTc2IiwidXNlcm5hbWUiOiJOYXRoYW5hZWwiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE2NDg3MTkxMjYsImV4cCI6MTY0ODg5MTkyNn0.1w2SGvqlSFV1YX-u1d-hAP9qmFTgnHVJsAsUl-glfK4';
  // var response;
  // Parameter parameter = Parameter();
  //
  //
  // Future<Parameter?> param() async{
  //   response = await http.get(Uri.parse(urlParam), headers: {'Authorization': 'Bearer $token' });
  //
  //   return parameter = Parameter.fromJson(jsonDecode(response.body));
  // }


  static Route<Object>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
            builder: (_) => HomePage(), settings: settings);
      case callingPage:
        return MaterialPageRoute(
            builder: (_) => CallingPage(), settings: settings);
      default:
        return null;
    }
  }
}