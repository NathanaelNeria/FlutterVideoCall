import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActiveLivenessDetection extends StatefulWidget {


  @override
  _ActiveLivenessDetectionState createState() => _ActiveLivenessDetectionState();
}

class _ActiveLivenessDetectionState extends State<ActiveLivenessDetection> {
  static const platform = MethodChannel('samples.flutter.dev/battery');

  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(onPressed: _getBatteryLevel, child: Text('Get Battery Level', textDirection: TextDirection.ltr,)),
          Text(_batteryLevel, textDirection: TextDirection.ltr,)
        ],
      ),
    );
  }
}
