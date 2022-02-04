import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/pages/congratulationPage.dart';

class coreBanking extends StatefulWidget {
  @override
  _coreBankingState createState() => _coreBankingState();
}

class _coreBankingState extends State<coreBanking> with TickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 10), (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => CongratulationPage()
      ), (_) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Sending data result to Core Banking for further verification',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
