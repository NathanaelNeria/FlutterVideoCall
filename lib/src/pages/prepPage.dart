import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/nodeflux/screens/nodefluxOcrKtpResultPage.dart';
import 'package:flutter_webrtc_demo/src/parameterModel.dart';
import '../../Widget/bezierContainer.dart';
import '../../hexColorConverter.dart';
import 'loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../nodeflux/screens/nodefluxOcrKtpPage.dart';


class PrepPage extends StatefulWidget {
  PrepPage({Key? key, required this.title, required this.parameter}) : super(key: key);


  final String title;
  final Parameter parameter;

  @override
  _PrepPageState createState() => _PrepPageState();
}

class _PrepPageState extends State<PrepPage> {
  String selectedValue = 'Savings Account';
  Color bgColor = Colors.white;
  Color buttonColor = Colors.white;
  Color boxColor = Colors.white;
  String titleText = '';
  Color textColor = Colors.white;

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
              child: Icon(Icons.keyboard_arrow_left, color: textColor),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor))
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
    return
      InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) =>
                // NodefluxOcrKtpPage(title: '', parameter: widget.parameter,)
              NodefluxOcrKtpResultPage(parameter: widget.parameter)
            ));
          },
          child:Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 15),
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
              //     'OK, Semua sudah siap',
              'OK, I am ready',
              style: TextStyle(fontSize: 20, color: textColor),
            ),
          )
      );
  }

  Widget selectProduct(){
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
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: Colors.white.withOpacity(0.15),
            value: selectedValue,
            isDense: true,
            items: product.map((String value) {
              return DropdownMenuItem<String>(
                  value: value,
                  child: new Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.blue.shade200,
                    ),
                    child: Text(value, style: TextStyle(color: Colors.white)),
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
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: titleText,
          style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              // color: Color(0xffe46b10),
              color: Colors.white
          ),
          // children: [
          //   TextSpan(
          //     text: ' Bank',
          //     style: TextStyle(color: Colors.white, fontSize: 30),
          //   ),
          //   // TextSpan(
          //   //   text: 'rnz',
          //   //   style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
          //   // ),
          // ]
      ),
    );
  }

  @override
  void initState() {
    bgColor = HexColor.fromHex(widget.parameter.data![0].background!);
    buttonColor = HexColor.fromHex(widget.parameter.data![0].button!);
    boxColor = HexColor.fromHex(widget.parameter.data![0].box!);
    titleText = widget.parameter.data![0].title!;
    textColor = HexColor.fromHex(widget.parameter.data![0].textColor!);
    super.initState();
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
                colors: [bgColor, bgColor]
            )
        ),
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
                        children: <Widget> [
                          SizedBox(height: 80),
                          _title()
                        ]
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          SizedBox(height: height * .03),

                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'Let\'s follow these steps to register $titleText Account',
                            style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.left,
                          ),
                          //_emailPasswordWidget(),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Please prepare these following items to begin:',
                            style: TextStyle(color: textColor, fontSize: 17), textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '\u2022 eKTP',
                            style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '\u2022 Active Mobile Phone Number and Email',
                            style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '\u2022 Appropriate situation to take selfie',
                            style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.left,
                          ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          SizedBox(
                            height: 30,
                          ),
                          // Text(
                          //   'Please Select Account Type',
                          //   style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                          //   textAlign: TextAlign.center,
                          // ),
                          // SizedBox(height: 20),
                          // selectProduct(),
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