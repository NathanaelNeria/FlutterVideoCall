import 'package:flutter/material.dart';
import 'schedule.dart';

class Notice extends StatefulWidget {
  const Notice({Key? key, required this.email, required this.nik, required this.name}) : super(key: key);

  final String email;
  final int nik;
  final String name;

  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  double? _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice'),
        centerTitle: true,
      ),
      body: Container(
        height: _height,
        width: _width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('There\'s a really long queue',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('OR',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Current time is not between operation hour',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              child: new Text(
                  'Schedule a Call',
                  style: new TextStyle(fontSize: 12.0, color: Colors.white)),
              onPressed:  () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScheduleCall(nik: widget.nik, email: widget.email, name: widget.name,)));
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.green
              ),
            )
          ],
        ),
      ),
    );
  }
}

