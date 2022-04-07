import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/parameterModel.dart';
import 'src/pages/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src/pages/welcomePage.dart';
import 'package:http/http.dart' as http;
import 'hexColorConverter.dart';

void main() {
  runApp(MaterialApp(home: MyApp(),
  debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String urlParam = 'https://api-portal.herokuapp.com/api/v1/admin/parameter';
  String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNjIyODUxMmM5MmFmYjFmNDA2MDE5NTc2IiwidXNlcm5hbWUiOiJOYXRoYW5hZWwiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE2NDg3MTkxMjYsImV4cCI6MTY0ODg5MTkyNn0.1w2SGvqlSFV1YX-u1d-hAP9qmFTgnHVJsAsUl-glfK4';
  var response;
  Parameter parameter = Parameter();
  Color bgColor = Colors.white;
  Color buttonColor = Colors.white;
  Color boxColor = Colors.white;


  param() async{
    response = await http.get(Uri.parse(urlParam), headers: {'Authorization': 'Bearer $token' });

    parameter = Parameter.fromJson(jsonDecode(response.body));
    print(response.body);

    setState(() {
      bgColor = HexColor.fromHex(parameter.data![0].background!);
      buttonColor = HexColor.fromHex(parameter.data![0].button!);
      boxColor = HexColor.fromHex(parameter.data![0].box!);
    });
  }

  @override
  void initState() {
    param();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen.timer(
      seconds: 5,
      navigateAfterSeconds: AfterSplash(parameter: parameter,),
      title: Text(
        'Initializing',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0, color: Colors.black),
      ),
      image: Image.asset('images/logoist.jpg'),
      photoSize: 150.0,
      backgroundColor: Colors.black,
      loaderColor: Colors.red,
    );
  }
}


class AfterSplash extends StatefulWidget {
  const AfterSplash({Key? key, required this.parameter}) : super(key: key);

  final Parameter parameter;

  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: widget.parameter.data![0].title!,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      home: WelcomePage(parameter: widget.parameter,),
    );
  }
}


