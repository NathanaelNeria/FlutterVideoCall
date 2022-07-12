import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/pages/welcomePage.dart';
import 'package:flutter_webrtc_demo/src/webrtc_room/webrtc_room.dart';

class AppRoute {
  static const videoCall = 'webrtc_room.dart';
  static const welcomePage = 'welcomePage.dart';

  static Route<Object>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case videoCall:
        return MaterialPageRoute(
            builder: (context) =>
                WebrtcRoom(
                  scheduled: true, nik: "3175022104970010"), settings: settings
        );
      case welcomePage:
        return MaterialPageRoute(
          builder: (context)=>
              WelcomePage(), settings: settings
        );
      default:
        return null;
    }
  }
}