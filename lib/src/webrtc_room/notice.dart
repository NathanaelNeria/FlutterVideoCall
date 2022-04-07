import 'package:flutter/material.dart';
import '../../hexColorConverter.dart';
import '../parameterModel.dart';
import 'schedule.dart';

class Notice extends StatefulWidget {
  const Notice({Key? key, required this.email, required this.nik, required this.name, required this.parameter}) : super(key: key);

  final String email;
  final int nik;
  final String name;
  final Parameter parameter;

  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  double? _height, _width;
  Color bgColor = Colors.white;
  Color buttonColor = Colors.white;
  Color boxColor = Colors.white;
  Color textColor = Colors.white;

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
              colors: [bgColor, bgColor],
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('There\'s a really long queue',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: textColor),
            ),
            SizedBox(height: 20),
            Text('OR',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: textColor),
            ),
            SizedBox(height: 20),
            Text('Current time is not between operation hour',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: textColor),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              child: new Text(
                  'Schedule a Call',
                  style: new TextStyle(fontSize: 12.0, color: textColor)),
              onPressed:  () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScheduleCall(nik: widget.nik, email: widget.email, name: widget.name, parameter: widget.parameter,)));
              },
              style: ElevatedButton.styleFrom(
                  primary: buttonColor
              ),
            )
          ],
        ),
      ),
    );
  }
}

