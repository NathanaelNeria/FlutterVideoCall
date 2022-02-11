import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widget/bezierContainer.dart';
import 'congratulationPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayDataPage extends StatefulWidget {
  DisplayDataPage({Key? key}) : super(key: key);

  @override
  _DisplayDataPageState createState() => _DisplayDataPageState();
}

class _DisplayDataPageState extends State<DisplayDataPage> {

  //firestore
  late String firestoreId;
  final db = FirebaseFirestore.instance;

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
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'Information',
              style: TextStyle(color: Colors.black, fontSize: 30),
          ),
      ]
    )
    );
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
                  Positioned(
                    top: -MediaQuery
                        .of(context)
                        .size
                        .height * .15,
                    right: -MediaQuery
                        .of(context)
                        .size
                        .width * .4,
                    child: BezierContainer(),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                builder: (context) => CongratulationPage()
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
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xfffbb448), Color(0xfff7892b)])),
            child: Text(
              'Next Step',
              style: TextStyle(fontSize: 20, color: Colors.white),
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
                  style: TextStyle(fontSize: 18)
              ),
              Text(
                  'NIK: ${(doc.data() as dynamic)['nik']}',
                  style: TextStyle(fontSize: 18)
              ),
              Text(
                  'Birthdate: ${(doc.data() as dynamic)['dob']}',
                  style: TextStyle(fontSize: 18)
              ),
              Text(
                  'Birth Place: ${(doc.data() as dynamic)['pob']}',
                  style: TextStyle(fontSize: 18)
              ),
              Text(
                  'Email: ${(doc.data() as dynamic)['email']}',
                  style: TextStyle(fontSize: 18)
              ),
              Text(
                  'Mobile Phone Number: ${(doc.data() as dynamic)['mobile']}',
                  style: TextStyle(fontSize: 18)
              ),
              SizedBox(height: 12),
            ]
        )
    );
  }
}
