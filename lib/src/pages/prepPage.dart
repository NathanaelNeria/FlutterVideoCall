import 'package:flutter/material.dart';
import '../../Widget/bezierContainer.dart';
import 'loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../nodeflux/screens/nodefluxOcrKtpPage.dart';

class PrepPage extends StatefulWidget {
  PrepPage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  _PrepPageState createState() => _PrepPageState();
}

class _PrepPageState extends State<PrepPage> {
  String selectedValue = 'Savings Account';

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
            Text('Back',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
<<<<<<< HEAD
    return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NodefluxOcrKtpPage()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Text(
            //     'OK, Semua sudah siap',
            'OK, I am ready',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
=======
    return
      InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NodefluxOcrKtpPage(title: '',)));
          },
          child:Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
         //     'OK, Semua sudah siap',
              'OK, I am ready',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
      );
>>>>>>> 99b0f59c56a773690edaf53b7ace594b233f2514
  }

  Widget selectProduct() {
    var product = ['Savings Account', 'Current Account'];
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        margin: EdgeInsets.only(bottom: 35),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
<<<<<<< HEAD
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            isDense: true,
            items: product.map((String value) {
              return DropdownMenuItem<String>(
=======
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Colors.white.withOpacity(0.15),
              value: selectedValue,
              isDense: true,
              items: product.map((String value) {
                return DropdownMenuItem<String>(
>>>>>>> 99b0f59c56a773690edaf53b7ace594b233f2514
                  value: value,
                  child: new Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.blue.shade200,
                    ),
                    child: Text(value, style: TextStyle(color: Colors.white)),
<<<<<<< HEAD
                  ));
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                selectedValue = newValue;
                print(selectedValue + ' ' + newValue);
              });
            },
          ),
        ));
=======
                  )
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                  print(selectedValue + ' ' + newValue);
                });
              },
            ),
          )
      );
>>>>>>> 99b0f59c56a773690edaf53b7ace594b233f2514
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'NTB Syariah',
          style: GoogleFonts.portLligatSans(
<<<<<<< HEAD
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              // color: Color(0xffe46b10),
              color: Colors.white),
=======
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            // color: Color(0xffe46b10),
            color: Colors.white
          ),
>>>>>>> 99b0f59c56a773690edaf53b7ace594b233f2514
          children: [
            TextSpan(
              text: ' Bank',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            // TextSpan(
            //   text: 'rnz',
            //   style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            // ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username"),
        _entryField("Email id"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
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
<<<<<<< HEAD
                colors: [
                  Colors.green,
                  Colors.green[600],
                  Colors.green[700],
                  Colors.green[800]
                ])),
=======
                colors: [Colors.green, Colors.green.shade700, Colors.green.shade900]
            )
        ),
>>>>>>> 99b0f59c56a773690edaf53b7ace594b233f2514
        height: height,
        child: Stack(
          children: <Widget>[
            // Positioned(
            //   top: -MediaQuery.of(context).size.height * .15,
            //   right: -MediaQuery.of(context).size.width * .4,
            //   child: BezierContainer(),
            // ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[SizedBox(height: 80), _title()]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: height * .03),

                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            //'Hai, buka rekening IST Bank kamu sekarang yuk',
                            'Let\'s follow these steps to open NTB Syariah Bank Account',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          //_emailPasswordWidget(),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            //'Sebelum mulai kita persiapkan hal ini yuk:',
                            'Please prepare these following items to begin:',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '\u2022 eKTP',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          //_emailPasswordWidget(),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            //'\u2022 Nomor HP dan Email yang aktif',
                            '\u2022 Active Mobile Phone Number and Email',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          //_emailPasswordWidget(),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            //'\u2022 Situasi kondusif untuk mengambil foto Selfie',
                            '\u2022 Appropriate situation to take selfie',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // Text(
                          //   //'\u2022 Perangkat dan koneksi internet untuk video call',
                          //   '\u2022 Video call ready device',
                          //   style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.left,
                          // ),
                          // //_emailPasswordWidget(),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // Text(
                          //   //'\u2022 Perangkat dan koneksi internet untuk video call',
                          //   '\u2022 Sufficient internet connection to have video call',
                          //   style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.left,
                          // ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Please Select Account Type',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          selectProduct(),
                          SizedBox(height: 20),
                          _submitButton(),
                          SizedBox(height: height * .14),
                        ]),

                    //_loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
