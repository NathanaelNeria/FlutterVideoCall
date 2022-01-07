import 'package:flutter/material.dart';
import 'src/pages/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src/pages/welcomePage.dart';

void main() {
  runApp(MaterialApp(home: MyApp(),
  debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen.timer(
      seconds: 3,
      navigateAfterSeconds: AfterSplash(),
      title: Text(
        'NTB Syariah Mobile Banking',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0, color: Colors.white),
      ),
      image: Image.asset('images/bank_NTBS.png'),
      photoSize: 150.0,
      backgroundColor: Colors.white,
      loaderColor: Colors.red,
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'NTB Syariah Mobile Banking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      home: WelcomePage(),
    );
  }
}

