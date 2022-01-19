import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/pages/displayDataPage.dart';
import 'package:intl/intl.dart';

typedef void StreamStateCallback(MediaStream stream);

class WebrtcSignaling {
  // WebrtcSignaling({required this.context});

  late final BuildContext context;

  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  late RTCPeerConnection peerConnection;
  late MediaStream localStream;
  late MediaStream remoteStream;
  late String roomId;
  late String currentRoomText;
  late StreamStateCallback onAddRemoteStream;

  var VCHandled1;
  var VCHandled2;
  var loggedIn1;
  var loggedIn2;
  var inCall1;
  var inCall2;


  Future<String> createRoom(RTCVideoRenderer remoteRenderer, FirebaseFirestore db) async {
    DocumentReference roomRef = db.collection('rooms').doc('mobiletest').collection('mobiletestroom').doc();
    DocumentReference roomAgent1 = db.collection('rooms').doc('roomAgent1').collection('roomIDAgent1').doc();
    DocumentReference roomAgent2 = db.collection('rooms').doc('roomAgent2').collection('roomIDAgent2').doc();
    
    var agent1Active = db.collection('isActive').doc('agent1').get();
    var agent2Active = db.collection('isActive').doc('agent2').get();

    agent1Active.then((doc){
      var jsonData = jsonEncode(doc.data());
      var parsedJson = jsonDecode(jsonData);
      VCHandled1 = parsedJson['VCHandled'];
      loggedIn1 = parsedJson['loggedIn'];
      inCall1 = parsedJson['inCall'];
      print('a1 >>>>>' + VCHandled1.toString() + loggedIn1.toString() + inCall1.toString());
    });
//buat condition lagi
    agent2Active.then((doc){
      var jsonData = jsonEncode(doc.data());
      var parsedJson = jsonDecode(jsonData);
      VCHandled2 = parsedJson['VCHandled'];
      loggedIn2 = parsedJson['loggedIn'];
      inCall2 = parsedJson['inCall'];
      print('a2 >>>>> ' + VCHandled2.toString() + loggedIn2.toString() + inCall2.toString());
    });

    print('Create PeerConnection with configuration: $configuration');

    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    localStream.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream);
    });

    //Routing
    if(VCHandled1 < VCHandled2 && !inCall1 && loggedIn1){
      var callerCandidatesCollection = roomAgent1.collection('callerCandidates');


      peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
        print('Got candidate: ${candidate.toMap()}');
        callerCandidatesCollection.add(candidate.toMap());


      }; // Finish Code for collecting ICE candidate

      // Add code for creating a room
      RTCSessionDescription offer = await peerConnection.createOffer();
      await peerConnection.setLocalDescription(offer);
      print('Created offer: $offer');

      Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};

      await roomAgent1.set(roomWithOffer);
      var roomId = roomAgent1.id;
      print('New room created with SDK offer. Room ID: $roomId');
      currentRoomText = 'Current room is $roomId - You are the caller!';
      // Created a Room

      peerConnection?.onTrack = (RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');

        event.streams[0].getTracks().forEach((track) {
          print('Add a track to the remoteStream $track');
          remoteStream?.addTrack(track);
        });
      };

      // Listening for remote session description below
      roomAgent1.snapshots().listen((snapshot) async {
        print('Got updated room: ${snapshot.data()}');

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (peerConnection?.getRemoteDescription() != null &&
            data['answer'] != null) {
          var answer = RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );

          print("Someone tried to connect");
          await peerConnection?.setRemoteDescription(answer);
        }
      });
      // Listening for remote session description above

      // Listen for remote Ice candidates below
      roomAgent1.collection('calleeCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) {
          if (change.type == DocumentChangeType.added) {
            Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
            print('Got new remote ICE candidate: ${jsonEncode(data)}');
            peerConnection.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          }
        });
      });
    }
    else if (VCHandled1 > VCHandled2 && !inCall2 && loggedIn2){
      var callerCandidatesCollection = roomAgent2.collection('callerCandidates');


      peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
        print('Got candidate: ${candidate.toMap()}');
        callerCandidatesCollection.add(candidate.toMap());


      }; // Finish Code for collecting ICE candidate

      // Add code for creating a room
      RTCSessionDescription offer = await peerConnection.createOffer();
      await peerConnection.setLocalDescription(offer);
      print('Created offer: $offer');

      Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};

      await roomAgent2.set(roomWithOffer);
      var roomId = roomAgent2.id;
      print('New room created with SDK offer. Room ID: $roomId');
      currentRoomText = 'Current room is $roomId - You are the caller!';
      // Created a Room

      peerConnection?.onTrack = (RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');

        event.streams[0].getTracks().forEach((track) {
          print('Add a track to the remoteStream $track');
          remoteStream?.addTrack(track);
        });
      };

      // Listening for remote session description below
      roomAgent2.snapshots().listen((snapshot) async {
        print('Got updated room: ${snapshot.data()}');

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (peerConnection?.getRemoteDescription() != null &&
            data['answer'] != null) {
          var answer = RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );

          print("Someone tried to connect");
          await peerConnection?.setRemoteDescription(answer);
        }
      });
      // Listening for remote session description above

      // Listen for remote Ice candidates below
      roomAgent2.collection('calleeCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) {
          if (change.type == DocumentChangeType.added) {
            Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
            print('Got new remote ICE candidate: ${jsonEncode(data)}');
            peerConnection.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          }
        });
      });
    }
    else{
      var callerCandidatesCollection = roomAgent1.collection('callerCandidates');


      peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
        print('Got candidate: ${candidate.toMap()}');
        callerCandidatesCollection.add(candidate.toMap());


      }; // Finish Code for collecting ICE candidate

      // Add code for creating a room
      RTCSessionDescription offer = await peerConnection.createOffer();
      await peerConnection.setLocalDescription(offer);
      print('Created offer: $offer');

      Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};

      await roomAgent1.set(roomWithOffer);
      var roomId = roomAgent1.id;
      print('New room created with SDK offer. Room ID: $roomId');
      currentRoomText = 'Current room is $roomId - You are the caller!';
      // Created a Room

      peerConnection?.onTrack = (RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');

        event.streams[0].getTracks().forEach((track) {
          print('Add a track to the remoteStream $track');
          remoteStream?.addTrack(track);
        });
      };

      // Listening for remote session description below
      roomAgent1.snapshots().listen((snapshot) async {
        print('Got updated room: ${snapshot.data()}');

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (peerConnection?.getRemoteDescription() != null &&
            data['answer'] != null) {
          var answer = RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );

          print("Someone tried to connect");
          await peerConnection?.setRemoteDescription(answer);
        }
      });
      // Listening for remote session description above

      // Listen for remote Ice candidates below
      roomAgent1.collection('calleeCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) {
          if (change.type == DocumentChangeType.added) {
            Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
            print('Got new remote ICE candidate: ${jsonEncode(data)}');
            peerConnection.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          }
        });
      });
    }
    // Code for collecting ICE candidates below
    // var callerCandidatesCollection = roomRef.collection('callerCandidates');
    //
    //
    // peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
    //   print('Got candidate: ${candidate.toMap()}');
    //   callerCandidatesCollection.add(candidate.toMap());
    //
    //
    // }; // Finish Code for collecting ICE candidate
    //
    // // Add code for creating a room
    // RTCSessionDescription offer = await peerConnection.createOffer();
    // await peerConnection.setLocalDescription(offer);
    // print('Created offer: $offer');
    //
    // Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};
    //
    // await roomRef.set(roomWithOffer);
    // var roomId = roomRef.id;
    // print('New room created with SDK offer. Room ID: $roomId');
    // currentRoomText = 'Current room is $roomId - You are the caller!';
    // // Created a Room
    //
    // peerConnection?.onTrack = (RTCTrackEvent event) {
    //   print('Got remote track: ${event.streams[0]}');
    //
    //   event.streams[0].getTracks().forEach((track) {
    //     print('Add a track to the remoteStream $track');
    //     remoteStream?.addTrack(track);
    //   });
    // };
    //
    // // Listening for remote session description below
    // roomRef.snapshots().listen((snapshot) async {
    //   print('Got updated room: ${snapshot.data()}');
    //
    //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    //   if (peerConnection?.getRemoteDescription() != null &&
    //       data['answer'] != null) {
    //     var answer = RTCSessionDescription(
    //       data['answer']['sdp'],
    //       data['answer']['type'],
    //     );
    //
    //     print("Someone tried to connect");
    //     await peerConnection?.setRemoteDescription(answer);
    //   }
    // });
    // // Listening for remote session description above
    //
    // // Listen for remote Ice candidates below
    // roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
    //   snapshot.docChanges.forEach((change) {
    //     if (change.type == DocumentChangeType.added) {
    //       Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
    //       print('Got new remote ICE candidate: ${jsonEncode(data)}');
    //       peerConnection.addCandidate(
    //         RTCIceCandidate(
    //           data['candidate'],
    //           data['sdpMid'],
    //           data['sdpMLineIndex'],
    //         ),
    //       );
    //     }
    //   });
    // });
    // Listen for remote ICE candidates above

    return roomId;
  }

  Future<void> joinRoom(String roomId, RTCVideoRenderer remoteVideo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc('$roomId');
    var roomSnapshot = await roomRef.get();
    print('Got room ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      print('Create PeerConnection with configuration: $configuration');
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream);
      });

      // Code for collecting ICE candidates below
      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
        if (candidate == null) {
          print('onIceCandidate: complete!');
          return;
        }
        print('onIceCandidate: ${candidate.toMap()}');
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidate above

      peerConnection?.onTrack = (RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');
        event.streams[0].getTracks().forEach((track) {
          print('Add a track to the remoteStream: $track');
          remoteStream?.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      var data = roomSnapshot.data() as Map<String, dynamic>;
      print('Got offer $data');
      var offer = data['offer'];
      // var currentTimestamp = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()).toString();
      var time = DateTime.now().millisecondsSinceEpoch;
      var isAnswered=false;
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await peerConnection.createAnswer();
      print('Created Answer $answer');

      await peerConnection.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp, 'time': time }
      };

      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((document) {
          var data = document.doc.data() as Map<String, dynamic>;
          print(data);
          print('Got new remote ICE candidate: $data');
          peerConnection.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        });
      });
    }
  }

  Future<void> openUserMedia(
      RTCVideoRenderer localVideo,
      RTCVideoRenderer remoteVideo,
      ) async {
    var stream = await navigator.mediaDevices
        .getUserMedia({
      'video': {
        'facingMode': 'user'
      },
      'audio': true,
      });

    localStream = stream;
    localVideo.srcObject = localStream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  Future<void> hangUp(RTCVideoRenderer localVideo) async {
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    tracks.forEach((track) {
      track.stop();
    });

    if (remoteStream != null) {
      remoteStream.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection.close();

    if (roomId != null) {
      var db = FirebaseFirestore.instance;
      var roomRef = db.collection('rooms').doc(roomId);
      var calleeCandidates = await roomRef.collection('calleeCandidates').get();
      calleeCandidates.docs.forEach((document) => document.reference.delete());

      var callerCandidates = await roomRef.collection('callerCandidates').get();
      callerCandidates.docs.forEach((document) => document.reference.delete());

      await roomRef.delete();
    }

    localStream.dispose();
    remoteStream?.dispose();
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
      if (state==RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DisplayDataPage(title: '',)));
      }
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("Add remote stream");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }
}
