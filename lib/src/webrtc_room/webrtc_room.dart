import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/src/pages/displayDataPage.dart';
import 'package:flutter_webrtc_demo/src/parameterModel.dart';
import 'webrtc_signaling.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WebrtcRoom extends StatefulWidget {
  WebrtcRoom({Key? key, required this.scheduled, this.nik, this.parameter}) : super(key: key);

  final bool scheduled;
  final String? nik;
  final dynamic? parameter;

  @override
  _WebrtcRoomState createState() => _WebrtcRoomState();
}

class _WebrtcRoomState extends State<WebrtcRoom> {
  WebrtcSignaling signaling = WebrtcSignaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  int? agentNum;


  @override
  void initState() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Intl.defaultLocale = 'pt_BR';

    initRenderers();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    signaling.firebaseAgent(db).then((value){
      setState(() {
          agentNum = value;
          print(value);
          print(agentNum);
      });
    });

    signaling.openUserMedia(_localRenderer, _remoteRenderer).whenComplete(() {
      setState(() {
      });
    } );

    if(!widget.scheduled) {
      Timer(const Duration(seconds: 3), () {
        signaling.createRoom(_remoteRenderer, db, agentNum!).then((data) {
          setState(() {
            roomId = data;
            signaling.connectionState(context);
          });
        });
      });
    }
    else if(widget.scheduled){
      signaling.joinRoom(widget.nik!, _remoteRenderer).whenComplete((){
        signaling.connectionState(context);
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  void initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Call with Agent"),
      ),
      body:
      (_remoteRenderer.srcObject==null)?
      Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 280),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation <Color> (Colors.blue)
                ),
              ],
            ),
            SizedBox(height: 160),
            Text("Connecting you to our agent"),
            Text("Please wait.."),
            SizedBox(height: 20),
          ]
      )
          :
      Column(
        children: [
          SizedBox(height: 178),
          Expanded(
            child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child:RTCVideoView(_localRenderer, mirror: true),
                  ),
                  Expanded(child: RTCVideoView(_remoteRenderer)),
                ],
              ),
            ),
          ),
          (_remoteRenderer.srcObject!=null)?Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Client Video                             "),
                    Text("Agent Video")]
              ),
            ],
          ):
          Container(),
          SizedBox(height: 148),
          Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // START: Comment button hangup
              (_remoteRenderer.srcObject!=null)?
              ElevatedButton(
                onPressed: () {
                  signaling.hangUp(_localRenderer);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => DisplayDataPage(parameter: widget.parameter!,)));
                },
                child: Icon(Icons.call_end_rounded),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(CircleBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                  backgroundColor: MaterialStateProperty.all(Colors.red), // <-- Button color
                ),
              ):Container(),
              // END: Comment button hangup
            ],
          ),
          SizedBox(height: 8)
        ],
      ),
    );
  }
}
