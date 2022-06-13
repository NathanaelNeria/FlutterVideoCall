import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/webrtc_room/webrtc_room.dart';

class AppRoute {
  static const videoCall = 'webrtc_room.dart';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case videoCall:
        return MaterialPageRoute(
            builder: (context) =>
                WebrtcRoom(
                  scheduled: true, nik: "3175022104970010", parameter: args,),
            settings: settings
        );
      default:
        return null;
    }
  }
}