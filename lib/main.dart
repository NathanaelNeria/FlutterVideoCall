import 'dart:async';
import 'dart:convert';

import 'package:callkeep/callkeep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_webrtc_demo/src/parameterModel.dart';
import 'package:uuid/uuid.dart';
import 'src/callkit/app_router.dart';
import 'src/callkit/navigation_service.dart';
import 'src/pages/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src/pages/welcomePage.dart';
import 'package:http/http.dart' as http;
import 'hexColorConverter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  showCallkitIncoming(Uuid().v4());
}

Future<void> showCallkitIncoming(String uuid) async {
  var params = <String, dynamic>{
    'id': uuid,
    'nameCaller': 'Hien Nguyen',
    'appName': 'Callkit',
    'avatar': 'https://i.pravatar.cc/100',
    'handle': '0123456789',
    'type': 1,
    'duration': 30000,
    'textAccept': 'Accept',
    'textDecline': 'Decline',
    'textMissedCall': 'Missed call',
    'textCallback': 'Call back',
    'extra': <String, dynamic>{'userId': '1a2b3c4d'},
    'headers': <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    'android': <String, dynamic>{
      'isCustomNotification': true,
      'isShowLogo': false,
      'isShowCallback': false,
      'ringtonePath': 'system_ringtone_default',
      'backgroundColor': '#0955fa',
      'background': 'https://i.pravatar.cc/500',
      'actionColor': '#4CAF50'
    },
    'ios': <String, dynamic>{
      'iconName': 'CallKitLogo',
      'handleType': '',
      'supportsVideo': true,
      'maximumCallGroups': 2,
      'maximumCallsPerCallGroup': 1,
      'audioSessionMode': 'default',
      'audioSessionActive': true,
      'audioSessionPreferredSampleRate': 44100.0,
      'audioSessionPreferredIOBufferDuration': 0.005,
      'supportsDTMF': true,
      'supportsHolding': true,
      'supportsGrouping': false,
      'supportsUngrouping': false,
      'ringtonePath': 'system_ringtone_default'
    }
  };
  await FlutterCallkitIncoming.showCallkitIncoming(params);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String urlParam = 'https://api-portal.herokuapp.com/api/v1/admin/parameter';
  String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNjIyODUxMmM5MmFmYjFmNDA2MDE5NTc2IiwidXNlcm5hbWUiOiJOYXRoYW5hZWwiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE2NDg3MTkxMjYsImV4cCI6MTY0ODg5MTkyNn0.1w2SGvqlSFV1YX-u1d-hAP9qmFTgnHVJsAsUl-glfK4';
  var response;
  Parameter parameter = Parameter();
  Color bgColor = Colors.white;
  Color buttonColor = Colors.white;
  Color boxColor = Colors.white;

  var _uuid;
  var _currentUuid;
  late final FirebaseMessaging _firebaseMessaging;

  param() async{
    response = await http.get(Uri.parse(urlParam), headers: {'Authorization': 'Bearer $token' });

    parameter = Parameter.fromJson(jsonDecode(response.body));
    print(response.body);

    setState(() {
      bgColor = HexColor.fromHex(parameter.data![0].background!);
      buttonColor = HexColor.fromHex(parameter.data![0].button!);
      boxColor = HexColor.fromHex(parameter.data![0].box!);
    });
  }

  @override
  void initState() {
    param();
    _uuid = Uuid();
    initFirebase();
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        this._currentUuid = calls[0]['id'];
        return calls[0];
      } else {
        this._currentUuid = "";
        return null;
      }
    }
  }

  checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall();
    if (currentCall != null) {
      NavigationService.instance
          .pushNamedIfNotCurrent(AppRoute.videoCall, args: currentCall);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => CallingPage(args: currentCall,)));
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print(state);
    if (state == AppLifecycleState.resumed) {
      //Check call when open app from background
      checkAndNavigationCallingPage();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  initFirebase() async {
    await Firebase.initializeApp();
    _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
      this._currentUuid = _uuid.v4();
      showCallkitIncoming(this._currentUuid);
    });
    _firebaseMessaging.getToken().then((token) {
      print('Device Token FCM: $token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen.timer(
      seconds: 7,
      navigateAfterSeconds: AfterSplash(parameter: parameter,),
      title: Text(
        'Initializing',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0, color: Colors.black),
      ),
      image: Image.asset('images/logoist.jpg'),
      photoSize: 150.0,
      backgroundColor: Colors.black,
      loaderColor: Colors.red,
    );
  }
}


class AfterSplash extends StatefulWidget {
  const AfterSplash({Key? key, required this.parameter}) : super(key: key);

  final Parameter parameter;

  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: widget.parameter.data![0].title!,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      home: WelcomePage(parameter: widget.parameter),
      onGenerateRoute: AppRoute.generateRoute,
      navigatorKey: NavigationService.instance.navigationKey,
      navigatorObservers: <NavigatorObserver>[
        NavigationService.instance.routeObserver
      ],
    );
  }



  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
    await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }
}