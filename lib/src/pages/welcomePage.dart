import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/nodeflux/screens/activeLiveness.dart';
import 'package:flutter_webrtc_demo/src/parameterModel.dart';
import 'package:flutter_webrtc_demo/src/webrtc_room/notice.dart';
import 'package:flutter_webrtc_demo/src/webrtc_room/schedule.dart';
import 'package:flutter_webrtc_demo/src/webrtc_room/webrtc_room.dart';
import 'loginPage.dart';
// import 'signup.dart';
import 'prepPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_webrtc_demo/hexColorConverter.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key, this.parameter}) : super(key: key);

  final Parameter? parameter;
  
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Color bgColor = Colors.white;
  Color buttonColor = Colors.white;
  Color boxColor = Colors.white;
  String titleText = '';
  Color textColor = Colors.white;

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PrepPage(title: '', parameter: widget.parameter!,)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: boxColor, width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: boxColor,
                offset: Offset(2, 4),
                blurRadius: 8,
                spreadRadius: 2)
          ],
          color: buttonColor
        ),
        child: Text(
          'Open Account Now',
          style: TextStyle(fontSize: 20,
              color: textColor
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return InkWell(
      onTap: () async {
        await Firebase.initializeApp();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Notice(email: 'nathanaelneria@gmail.com', nik: 3175022104970010, name: 'Nathanael Neria', parameter: widget.parameter!,)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: boxColor, width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: boxColor,
                offset: Offset(2, 4),
                blurRadius: 8,
                spreadRadius: 2)
          ],
          color: buttonColor
        ),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: textColor),
        ),
      ),
    );
  }

  Widget _label() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              'Quick login with Touch ID',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            SizedBox(
              height: 20,
            ),
            Icon(Icons.fingerprint, size: 90, color: Colors.white),
            SizedBox(
              height: 20,
            ),
            Text(
              'Touch ID',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ));
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'd',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: 'ev',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'rnz',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ]),
    );
  }

  @override
  void initState() {
    bgColor = HexColor.fromHex(widget.parameter!.data![0].background!);
    buttonColor = HexColor.fromHex(widget.parameter!.data![0].button!);
    boxColor = HexColor.fromHex(widget.parameter!.data![0].box!);
    titleText = widget.parameter!.data![0].title!;
    textColor = HexColor.fromHex(widget.parameter!.data![0].textColor!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child:Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [bgColor, bgColor],
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Image.asset(
              //   'images/bank_NTBS.png',
              //   width: 200,
              // ),
              SizedBox(
                height: 10,
              ),
              Text(
                titleText,
                style: TextStyle(color: textColor, fontSize: 23, fontWeight: FontWeight.bold), textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                //'Selamat datang di IST Bank Mobile. Kemudahan bertransaksi dalam genggaman Anda',
                'Welcome to $titleText. Ease of transaction in your hand',
                style: TextStyle(color: textColor, fontSize: 17), textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 80,
              ),
              Text(
                //'Apakah kamu sudah memiliki rekening IST Mobile?',
                'Do you have $titleText Account?',
                style: TextStyle(color: textColor, fontSize: 17), textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              _loginButton(),
              SizedBox(
                height: 50,
              ),
              Text(
                //'Belum memiliki rekening IST Mobile.\nMau buka rekening kamu sekarang juga?',
                'I don\'t have $titleText Account. \nWant to open account now?',
                style: TextStyle(color: textColor, fontSize: 17), textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              _signUpButton(),

              // SizedBox(
              //   height: 20,
              // ),
              // _label()
            ],
          ),
        ),
      ),
    );
  }
}