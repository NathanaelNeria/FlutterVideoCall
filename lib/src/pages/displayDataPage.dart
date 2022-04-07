import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/parameterModel.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widget/bezierContainer.dart';
import '../../hexColorConverter.dart';
import 'congratulationPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayDataPage extends StatefulWidget {
  DisplayDataPage({Key? key, required this.parameter}) : super(key: key);

  final Parameter parameter;

  @override
  _DisplayDataPageState createState() => _DisplayDataPageState();
}

class _DisplayDataPageState extends State<DisplayDataPage> {

  //firestore
  late String firestoreId;
  final db = FirebaseFirestore.instance;
  var textColor;
  var bgColor;
  var buttonColor;
  var boxColor;

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'eKTP & Contact ',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme
                .of(context)
                .textTheme
                .headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
          children: [
            TextSpan(
              text: 'Information',
              style: TextStyle(color: textColor, fontSize: 30),
          ),
      ]
    )
    );
  }

  @override
  void initState() {
    bgColor = HexColor.fromHex(widget.parameter.data![0].background!);
    buttonColor = HexColor.fromHex(widget.parameter.data![0].button!);
    boxColor = HexColor.fromHex(widget.parameter.data![0].box!);
    textColor = HexColor.fromHex(widget.parameter.data![0].textColor!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        body: Container(
            height: height,
            child: Stack(
                children: <Widget>[
                  // Positioned(
                  //   top: -MediaQuery
                  //       .of(context)
                  //       .size
                  //       .height * .15,
                  //   right: -MediaQuery
                  //       .of(context)
                  //       .size
                  //       .width * .4,
                  //   child: BezierContainer(),
                  // ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: boxColor,
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
                      child: ListView(
                        padding: EdgeInsets.all(8),
                        children: <Widget>[
                          SizedBox(height: 150),
                          _title(),
                          SizedBox(height: 100),
                          StreamBuilder<QuerySnapshot>(
                              stream: db.collection('form').snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(children: snapshot.data!.docs
                                      .map((doc) => buildItem(doc)).toList());
                                } else {
                                  return SizedBox();
                                }
                              }
                          ),
                          SizedBox(height: 50),
                          _showNextButton()
                        ],
                      )
                  )
                ]
            )
        )
    );
  }

  Widget _showNextButton() {
    return
      InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => CongratulationPage(parameter: widget.parameter,)
            )
            );
          },
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: boxColor,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [buttonColor])),
            child: Text(
              'Next Step',
              style: TextStyle(fontSize: 20, color: textColor),
            ),
          )
      );
  }

  Widget buildItem(DocumentSnapshot doc) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'Name: ${(doc.data() as dynamic)['name']}',
                  style: TextStyle(fontSize: 18, color: textColor)
              ),
              Text(
                  'NIK: ${(doc.data() as dynamic)['nik']}',
                  style: TextStyle(fontSize: 18, color: textColor)
              ),
              Text(
                  'Birthdate: ${(doc.data() as dynamic)['dob']}',
                  style: TextStyle(fontSize: 18, color: textColor)
              ),
              Text(
                  'Birth Place: ${(doc.data() as dynamic)['pob']}',
                  style: TextStyle(fontSize: 18, color: textColor)
              ),
              Text(
                  'Email: ${(doc.data() as dynamic)['email']}',
                  style: TextStyle(fontSize: 18, color: textColor)
              ),
              Text(
                  'Mobile Phone Number: ${(doc.data() as dynamic)['mobile']}',
                  style: TextStyle(fontSize: 18, color: textColor)
              ),
              SizedBox(height: 12),
            ]
        )
    );
  }
}
