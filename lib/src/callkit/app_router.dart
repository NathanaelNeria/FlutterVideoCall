import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/webrtc_room/webrtc_room.dart';

class AppRoute {
  static const homePage = 'home_page.dart';

  static const callingPage = 'calling_page.dart';
  static const videoCall= 'webrtc_room.dart';

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      case videoCall:
        return MaterialPageRoute(
          builder: (context) => WebrtcRoom(scheduled: true, nik: "3175022104970010"), settings: settings
        );
      default:
        return _errorRoute();
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
  //           builder: (_) => HomePage(), settings: settings);
  //     case callingPage:
  //       return MaterialPageRoute(
  //           builder: (_) => CallingPage(), settings: settings);
  //     default:
  //       return null;
  //   }
  // }
}