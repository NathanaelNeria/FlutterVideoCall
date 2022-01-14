import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActiveLivenessDetection extends StatefulWidget {
  const ActiveLivenessDetection({Key key}) : super(key: key);

  @override
  _ActiveLivenessDetectionState createState() => _ActiveLivenessDetectionState();
}

class _ActiveLivenessDetectionState extends State<ActiveLivenessDetection> {
  static const platform = const MethodChannel('activeLiveness');

  Future<void> LivenessDetection() async {
    try {
      await platform.invokeMethod('startActivity');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LivenessDetection();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              child: Text('Call Native Method'),
              onPressed: LivenessDetection,
            ),
            Text('_responseFromNativeCode'),
          ],
        ),
      ),
    );
  }
}
