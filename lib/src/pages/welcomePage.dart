import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';
// import 'signup.dart';
import 'prepPage.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PrepPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
          // boxShadow: <BoxShadow>[
          //   BoxShadow(
          //       color: Color(0xffdf8e33).withAlpha(100),
          //       offset: Offset(2, 4),
          //       blurRadius: 8,
          //       spreadRadius: 2)
          // ],
          // color: Colors.white
        ),
        child: Text(
          'Open Account Now',
          style: TextStyle(fontSize: 20, color: Colors.white
              // color: Color(0xfff7892b)
              ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                  // colors: [Color(0xfffbb448), Color(0xffe46b10)]
                  colors: [
                    Colors.green,
                    Colors.green[600],
                    Colors.green[700],
                    Colors.green[800]
                  ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/bank_NTBS.png',
                width: 200,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Bank NTB Syariah',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                //'Selamat datang di IST Bank Mobile. Kemudahan bertransaksi dalam genggaman Anda',
                'Welcome to NTB Syariah Mobile Banking. Ease of transaction in your hand',
                style: TextStyle(color: Colors.white, fontSize: 17),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 80,
              ),
              Text(
                //'Apakah kamu sudah memiliki rekening IST Mobile?',
                'Do you have NTB Syariah Mobile Banking Account?',
                style: TextStyle(color: Colors.white, fontSize: 17),
                textAlign: TextAlign.center,
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
                'I don\'t have NTB Syariah Mobile Banking Account. \nWant to open account now?',
                style: TextStyle(color: Colors.white, fontSize: 17),
                textAlign: TextAlign.center,
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
