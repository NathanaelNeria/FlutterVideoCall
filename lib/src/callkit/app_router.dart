import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/webrtc_room/webrtc_room.dart';
import 'home_page.dart';
import 'calling_page.dart';

class AppRoute {
  static const homePage = 'home_page.dart';

  static const callingPage = 'calling_page.dart';
  static const videoCall= 'webrtc_room.dart';

  static Route<Object>? generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name){
      case videoCall:
        return MaterialPageRoute(
            builder: (context) => WebrtcRoom(scheduled: false, nik: "3175022104970010")
        );
      default:
        return null;
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (builder){
      return Scaffold(
        appBar: AppBar(
          title: Text('ERROR'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Page not found!'),
        ),
      );
    });
  }

// static Route<Object>? generateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case homePage:
//       return MaterialPageRoute(
//           builder: () => HomePage(), settings: settings);
//     case callingPage:
//       return MaterialPageRoute(
//           builder: (_) => CallingPage(), settings: settings);
//     default:
//       return null;
//   }
// }
}