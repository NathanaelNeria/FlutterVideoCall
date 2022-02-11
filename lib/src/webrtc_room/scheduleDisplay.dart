import 'package:flutter/material.dart';
import '../pages/welcomePage.dart';

class scheduleDisplay extends StatefulWidget {
  const scheduleDisplay({Key? key, required this.name, required this.nik, required this.email, required this.date, required this.time}) : super(key: key);

  final String name, email, date, time;
  final int nik;

  @override
  _scheduleDisplayState createState() => _scheduleDisplayState();
}

class _scheduleDisplayState extends State<scheduleDisplay> {
  double? _height, _width;

  Widget returnHome() {
    return InkWell(
      onTap: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomePage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width/100*60,
        padding: EdgeInsets.symmetric(vertical: 13),
        margin: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Complete',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule has been requested'),
        centerTitle: true,
      ),
      backgroundColor: Colors.green,
      body: Container(
        height: _height,
        width: _width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('The schedule you requested has been sent',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Your details:\n'
                  'NIK: ${widget.nik}\n'
                  'Name: ${widget.name}\n'
                  'Email: ${widget.email}\n'
                  'Date: ${widget.date}\n'
                  'Time: ${widget.time}',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text('Please wait for schedule confirmation from us via e-mail',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            returnHome(),
          ],
        ),
      ),
    );
  }
}

