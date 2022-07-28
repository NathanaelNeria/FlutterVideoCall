import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_demo/src/pages/displayDataPage.dart';
import 'package:flutter_webrtc_demo/src/parameterModel.dart';
import 'package:flutter_webrtc_demo/src/utils/websocket.dart';
import 'webrtc_signaling.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class WebrtcRoom extends StatefulWidget {
  WebrtcRoom({Key? key, required this.scheduled, this.nik, this.parameter})
      : super(key: key);

  final bool scheduled;
  final String? nik;
  final Parameter? parameter;

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

  String urlParam = 'https://api-portal.herokuapp.com/api/v1/admin/parameter';
  String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNjIyODUxMmM5MmFmYjFmNDA2MDE5NTc2IiwidXNlcm5hbWUiOiJOYXRoYW5hZWwiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE2NDg3MTkxMjYsImV4cCI6MTY0ODg5MTkyNn0.1w2SGvqlSFV1YX-u1d-hAP9qmFTgnHVJsAsUl-glfK4';
  var response;
  Parameter parameter = Parameter();

  param() async {
    response = await http
        .get(Uri.parse(urlParam), headers: {'Authorization': 'Bearer $token'});

    parameter = Parameter.fromJson(jsonDecode(response.body));
    print('backend complete room.dart');
  }

  @override
  void initState() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Intl.defaultLocale = 'pt_BR';

    initRenderers();
    print('init webrtc room');

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    signaling.firebaseAgent(db).then((value) {
      setState(() {
        agentNum = value;
        print(value);
        print(agentNum);
      });
    });

    signaling.openUserMedia(_localRenderer, _remoteRenderer).whenComplete(() {
      setState(() {});
    });

    if (!widget.scheduled) {
      Timer(const Duration(seconds: 3), () {
        signaling.createRoom(_remoteRenderer, db, agentNum!).then((data) {
          setState(() {
            roomId = data;
            signaling.connectionState(context);
          });
        });
      });
    } else if (widget.scheduled) {
      signaling.joinRoom(widget.nik!, _remoteRenderer).whenComplete(() {
        signaling.connectionState(context);
      });
    }
    param();
    super.initState();
  }

  @override
  void dispose() {
    if (_localRenderer.srcObject != null) {
      _localRenderer.srcObject = null;
      _localRenderer.dispose();
    }
    if (_remoteRenderer.srcObject != null) {
      _remoteRenderer.srcObject = null;
      _remoteRenderer.dispose();
    }
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
      body: (_remoteRenderer.srcObject == null)
          ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(height: 280),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
                ],
              ),
              SizedBox(height: 160),
              Text("Connecting you to our agent"),
              Text("Please wait.."),
              SizedBox(height: 20),
            ])
          : Column(
              children: [
                SizedBox(height: 178),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RTCVideoView(_localRenderer, mirror: true),
                        ),
                        Expanded(child: RTCVideoView(_remoteRenderer)),
                      ],
                    ),
                  ),
                ),
                (_remoteRenderer.srcObject != null)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "Client Video                             "),
                                Text("Agent Video")
                              ]),
                        ],
                      )
                    : Container(),
                SizedBox(height: 148),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // START: Comment button hangup
                    (_remoteRenderer.srcObject != null)
                        ? ElevatedButton(
                            onPressed: () {
                              // FlutterCallkitIncoming.endAllCalls();
                              signaling.hangUp(_localRenderer);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DisplayDataPage(
                                            parameter: parameter,
                                          )));
                            },
                            child: Icon(Icons.call_end_rounded),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(CircleBorder()),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(20)),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.red), // <-- Button color
                            ),
                          )
                        : Container(),
                    // END: Comment button hangup
                  ],
                ),
                SizedBox(height: 8)
              ],
            ),
    );
  }
}
