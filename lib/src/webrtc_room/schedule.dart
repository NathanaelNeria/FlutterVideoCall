import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/pages/welcomePage.dart';
import 'package:flutter_webrtc_demo/src/parameterModel.dart';
import 'package:flutter_webrtc_demo/src/webrtc_room/scheduleDisplay.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'dart:math';

class ScheduleCall extends StatefulWidget {
  const ScheduleCall({Key? key, required this.email, required this.nik, required this.name, required this.parameter}) : super(key: key);

  final String email;
  final int nik;
  final String name;
  final Parameter parameter;

  @override
  _ScheduleCallState createState() => _ScheduleCallState();
}

class _ScheduleCallState extends State<ScheduleCall> {
  double? _height;
  double? _width;

  String? _setTime, _setDate;

  String? _hour, _minute, _time;

  String? dateTime;

  String? fcmToken;

  DateFormat formatter = DateFormat('yyyy-MM-dd');

  String? dateFormatted, timeFormatted;

  String timeMessage = '';
  var startTime, endTime;

  bool operationTime = false;

  double? _selectedTime;

  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  final db = FirebaseFirestore.instance;

  late final FirebaseMessaging _firebaseMessaging;


  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        selectableDayPredicate: (val) =>
          (val.weekday != 7) ? true : false,
        firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
        lastDate: DateTime(DateTime.now().year + 1)
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
        dateFormatted = formatter.format(selectedDate);
      });
    else if (picked == null){

      setState(() {
        dateFormatted = formatter.format(selectedDate);
      });
    }
    return selectedDate.toString();
  }

  Future<String> _selectTime(BuildContext context) async {
    double _openTime = widget.parameter.data![0].operationalStart!;
    double _closeTime = widget.parameter.data![0].operationalEnd!;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, widget){
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: widget!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _selectedTime = selectedTime.hour.toDouble() + (selectedTime.minute.toDouble()/60);
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        _timeController.text = _time!;
        _timeController.text = formatDate(
            DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, selectedTime.hour, selectedTime.minute),
            [HH, ':', nn, " "]).toString();
        print(_selectedTime! > _openTime && _selectedTime! < _closeTime);
        print(_selectedTime);
      });

      // double _selectedTime = selectedTime.hour.toDouble() + (selectedTime.minute.toDouble()/60);
      if(_selectedTime! >= _openTime && _selectedTime! <= _closeTime){
        operationTime = true;
        timeFormatted = selectedTime.format(context);
      }
      else{
        operationTime = false;
        timeMessage = 'Please select time between $startTime - $endTime';
      }
    }
    else if(picked == null){
      _selectedTime = selectedTime.hour.toDouble() + (selectedTime.minute.toDouble()/60);
      if(_selectedTime! >= _openTime && _selectedTime! <= _closeTime){
        operationTime = true;
        timeFormatted = selectedTime.format(context);
      }
      else{
        operationTime = false;
        timeMessage = 'Please select time between $startTime - $endTime';
      }
    }
    return selectedTime.toString();
  }

  String getTimeStringFromDouble(double value) {
    if (value < 0) return 'Invalid Value';
    int flooredValue = value.floor();
    double decimalValue = value - flooredValue;
    String hourValue = getHourString(flooredValue);
    String minuteString = getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String getMinuteString(double decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(selectedDate);

    // _timeController.text = formatDate(
    //     DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute),
    //     [HH, ':', nn, " "]).toString();

    // dateFormatted = _dateController.text;
    timeFormatted = _timeController.text;
    dateFormatted = formatter.format(today);
    _selectedTime = DateTime.now().hour.toDouble() + (DateTime.now().minute.toDouble()/60);
    startTime = getTimeStringFromDouble(widget.parameter.data![0].operationalStart!);
    endTime = getTimeStringFromDouble(widget.parameter.data![0].operationalEnd!);
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((fcm){
      setState(() {
        fcmToken = fcm;
        print('ini dari token: $fcmToken');
      });
    });
    super.initState();
  }

  firestoreSchedule() async {
    try {
      await db.collection('schedule').doc().set({
        'date': dateFormatted,
        'time': timeFormatted,
        'nik': widget.nik,
        'email': widget.email,
        'name': widget.name,
        'status': 'Pending',
        'disable': false,
        'disableRoom': true,
        'disableDecline': false,
        'token': fcmToken
      });
    }
    catch(e){
      print('Error: $e');
    }
  }

  Widget setCallSchedule(){
    return InkWell(
      onTap: () {
        if(operationTime) {
          firestoreSchedule();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => scheduleDisplay(name: widget.name, nik: widget.nik, email: widget.email, date: dateFormatted!, time: timeFormatted!, parameter: widget.parameter,))
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Text(
          'Set Schedule',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Date time picker'),
      ),
      body: Container(
        width: _width,
        height: _height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Choose Date',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    width: _width! / 1.7,
                    height: _height! / 9,
                    margin: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      onSaved: (val) {
                        _setDate = val!;
                        print(_setDate);
                      },
                      decoration: InputDecoration(
                          disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                          // labelText: 'Time',
                          contentPadding: EdgeInsets.only(top: 0.0)),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  'Choose Time',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
                InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: _width! / 1.7,
                    height: _height! / 9,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                      onSaved: (val) {
                        _setTime = val!;
                        print(_setTime);
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _timeController,
                      decoration: InputDecoration(
                          disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                          // labelText: 'Time',
                          contentPadding: EdgeInsets.all(5)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                (operationTime)? Container() : Text(timeMessage, style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                setCallSchedule(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}