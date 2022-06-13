// ignore_for_file: unnecessary_statements, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_webrtc_demo/src/nodeflux/models/dukcapilFail.dart';
import 'package:flutter_webrtc_demo/src/nodeflux/models/dukcapilOngoing.dart';
import 'package:flutter_webrtc_demo/src/webrtc_room/notice.dart';
import 'package:google_fonts/google_fonts.dart';

// import '../../../Widget/bezierContainer.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../hexColorConverter.dart';
import '../../parameterModel.dart';
import '../models/nodeflux_result2_model.dart';
import 'dart:convert';
import '../../webrtc_room/webrtc_room.dart';

import '../../../Widget/datetime_picker_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/livenessUnderqualified.dart';
import '../models/messageModel.dart';
import '../models/modelLivenessNathan.dart';
import '../models/face_pair_not_match.dart';
import '../models/no_face_detected.dart';
import '../models/dukcapilFaceMatch.dart';

class NodefluxOcrKtpResultPage extends StatefulWidget {
  final NodefluxResult2Model model;
  final File ektpImage;
  final Parameter parameter;

  NodefluxOcrKtpResultPage({ Key? key, required this.ektpImage, required this.model, required this.parameter}) : super(key: key);

  @override
  _NodefluxOcrKtpResultPageState createState() => _NodefluxOcrKtpResultPageState();
}

class _NodefluxOcrKtpResultPageState extends State<NodefluxOcrKtpResultPage> {
  ImagePicker _picker= ImagePicker();
  File? ektpImage;
  File? _selfieImage;
  File? _selfieEktpImage;

  bool isEmail = false;
  bool scheduled = false;

  TextEditingController nikController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController birthplaceController = TextEditingController();
  TextEditingController mobilePhoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late TextEditingController addressController, genderController, rtrwController, kecamatanController, religionController, maritalStatusController, workfieldController, provinceController, expiryController,
      bloodTypeController, kabupatenKotaController, kelurahanDesaController, nationalityController;

  //firestore
  late String firestoreId;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late String firestoreName;
  late String firestoreNik;
  late String firestoreAddress;
  late String firestoreBirthdate;
  late String firestoreBirthplace;
  late String firestoreGender;
  late String firestoreRtRw;
  late String firestoreKecamatan;
  late String firestoreReligion;
  late String firestoreMaritalStatus;
  late String firestoreWorkfield;
  late String firestoreProvince;
  late String firestoreExpiry;
  late String firestoreBloodType;
  late String firestoreKabupatenKota;
  late String firestoreKelurahanDesa;
  late String firestoreNationality;
  late String firestoreMobilePhone;
  late String firestoreEmail;

  final int minPhotoSize=256000; // 250KB
  final int maxPhotoSize=512000; // 500KB

  late String ocrNama, ocrNik, ocrTempatLahir, ocrTanggalLahir, ocrJenisKelamin, ocrAlamat, ocrRtrw, ocrKecamatan, ocrAgama, ocrStatusPerkawinan,
      ocrPekerjaan, ocrProvinsi, ocrBerlakuHingga, ocrGolonganDarah, ocrKabupatenKota, ocrKelurahanDesa, ocrKewarganegaraan;


  TextEditingController scheduledDateTimeController = new TextEditingController(text: 'Anonymous');
  DatetimePickerWidget datetimePickerWidget = DatetimePickerWidget();

  Color bgColor = Colors.white;
  Color buttonColor = Colors.white;
  Color boxColor = Colors.white;
  String titleText = '';
  Color textColor = Colors.white;
  Color warningTextColor = Colors.white;

  bool? isLive;
  bool? isMatched;
  bool nodefluxSelfie = false;
  double? livenessValue;
  double? similarityValue;
  var matchLivenessFeedback="";
  String message = '';
  bool noFace = false;
  bool underQualified = false;
  bool changeColor = false;
  String ktpDetected = '';
  String messageDukcapil = '';
  bool dukcapil = true;
  String selfieProcessed = '';
  String dukcapilStatus = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
    bgColor = HexColor.fromHex(widget.parameter.data![0].background!);
    buttonColor = HexColor.fromHex(widget.parameter.data![0].button!);
    boxColor = HexColor.fromHex(widget.parameter.data![0].box!);
    titleText = widget.parameter.data![0].title!;
    textColor = HexColor.fromHex(widget.parameter.data![0].textColor!);
    warningTextColor = HexColor.fromHex(widget.parameter.data![0].warningTextColor!);
  }

  setup() {
    nikController= TextEditingController(text: widget.model.nik);
    nameController= TextEditingController(text: widget.model.nama);
    birthdateController= TextEditingController(text: widget.model.tanggal_lahir);
    birthplaceController= TextEditingController(text: widget.model.tempat_lahir);
    genderController= TextEditingController(text: widget.model.jenis_kelamin);
    addressController= TextEditingController(text: widget.model.alamat);
    rtrwController= TextEditingController(text: widget.model.rt_rw);
    kecamatanController= TextEditingController(text: widget.model.kecamatan);
    religionController= TextEditingController(text: widget.model.agama);
    maritalStatusController= TextEditingController(text: widget.model.status_perkawinan);
    workfieldController= TextEditingController(text: widget.model.pekerjaan);
    provinceController= TextEditingController(text: widget.model.provinsi);
    expiryController= TextEditingController(text: widget.model.berlaku_hingga);
    bloodTypeController= TextEditingController(text: widget.model.golongan_darah);
    kabupatenKotaController= TextEditingController(text: widget.model.kabupaten_kota);
    kelurahanDesaController= TextEditingController(text: widget.model.kelurahan_desa);
    nationalityController= TextEditingController(text: widget.model.kewarganegaraan);

    initializeDateFormatting();
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'eKTP & Contact ',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
            // color: Colors.black
          ),
          children: [
            TextSpan(
              text: 'Information',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            // TextSpan(
            //   text: 'Form',
            //   style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            // ),
          ]),
    );
  }


  _getSelfieImage(BuildContext context, ImageSource source) async{
    try{
      Directory tempDir = await getTemporaryDirectory();

      if (await tempDir.exists())
        tempDir.delete(recursive: false);

      Directory appdocdir= await getApplicationSupportDirectory();

      if (await appdocdir.exists())
        appdocdir.delete(recursive: false);

      XFile? xFilepicture =  await _picker.pickImage(source: source);
      File? picture = File(xFilepicture!.path);

      int appFileDirectory=picture.path.lastIndexOf('/');
      String resultDirectory=picture.path.substring(0,appFileDirectory+1); // = appdocdir+'/Pictures/'
      String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';

      int photoQuality=90;
      if(picture != null) {
        try {

          var result = await FlutterImageCompress.compressAndGetFile(
            picture.path, resultPath,
            quality: photoQuality,
          );

          int? resultLength=result?.lengthSync();

          while ((resultLength! < minPhotoSize || resultLength > maxPhotoSize) && photoQuality>0 && photoQuality<100) {
            if (result!=null)
              await result.delete();
            resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
            photoQuality=(resultLength>maxPhotoSize)? photoQuality-10:photoQuality+10;
            result = await FlutterImageCompress.compressAndGetFile(
              picture.path, resultPath,
              quality: photoQuality,
            );
            resultLength=result?.lengthSync();
          }

          double sizeinKb=resultLength.toDouble()/1024;
          debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');
          //print(pictureLength+resultLength);
          await picture.delete();
          this.setState(() {
            //_imageFileProfile = cropped;
            _selfieImage = result;
            selfieProcessed = 'lagi proses';
            //loading = false;
          });
        } catch (e) {
          print (e);
          debugPrint("Error $e");
        }
      }else{
        this.setState(() {
          //loading = false;
        });
      }
    } catch (e) {
      print (e);
      debugPrint("Error $e");
    }
    await nodefluxSelfieMatchLivenessProcess(context);
    // await nodefluxDukcapilProcess(context);
    await uploadImage(_selfieImage!, "selfie");
  }

  nodefluxDukcapilProcess(BuildContext context) async{
    String authorization = 'NODEFLUX-HMAC-SHA256 Credential=6JDO19EURXVTAH1T8PWBUI6CT/20220406/nodeflux.api.v1beta1.ImageAnalytic/StreamImageAnalytic, SignedHeaders=x-nodeflux-timestamp, Signature= eb29a7ca14f9c005ec55416819bd13a70bcb0c154ea72812a8dfb64d1082d298';
    String nodefluxTimestamp = '20220406T080540Z';
    final imageBytesSelfie = _selfieImage?.readAsBytesSync();
    String base64ImageSelfie = 'data:image/jpeg;base64,'+base64Encode(imageBytesSelfie!);
    String currentStatus = '';
    String contentType = 'application/json';
    String accept = 'application/json';
    DukcapilFaceMatch dukcapilFaceMatch = DukcapilFaceMatch();
    DukcapilFail dukcapilFail = DukcapilFail();
    DukcapilOngoing dukcapilOngoing = DukcapilOngoing();
    bool okValue;
    String url = 'https://api.cloud.nodeflux.io/v1/analytics/dukcapil-validation';
    var response;

    try{
      while (currentStatus == 'on going' || currentStatus == '') {
        response = await http.post(
            Uri.parse(url),
            body: json.encode({
              "additional_params": {
                "nik": widget.model.nik,
                "transaction_id": "{random digit}",
                "transaction_source": "{device}",
                "dukcapil": {
                  "user_id": "{encrypted_user_id}",
                  "password": "{encrypted_password}",
                  "image": base64ImageSelfie
                }
              },
              "images": [
                base64ImageSelfie
              ]
            }),
            headers: {
              'Accept': accept,
              'Content-Type': contentType,
              'Authorization': authorization,
              'x-nodeflux-timestamp': nodefluxTimestamp
            }
        );

        print(response.body);
        print(widget.model.nik);

        dukcapilOngoing = DukcapilOngoing.fromJson(jsonDecode(response.body));
        okValue = dukcapilOngoing.ok!;
        var status = dukcapilOngoing.job!.result!.status;
        if(okValue){
          currentStatus = status!;
          dukcapilStatus = status;
        }
      }

      if(currentStatus == "success"){
        dukcapilFaceMatch = DukcapilFaceMatch.fromJson(jsonDecode(response.body));
        setState(() {
          similarityValue = dukcapilFaceMatch.job!.result!.result![0].faceMatch!.similarity;
          messageDukcapil = dukcapilFaceMatch.message!;
          nodefluxSelfie = true;
          changeColor = true;
          dukcapil = false;
          selfieProcessed = 'selfie ada';
        });

        double similarityPercentage=similarityValue!*100;
        String isMatchedString = (similarityPercentage>=widget.parameter.data![0].percentageSimilarity!)? "matched": "not matched";
        matchLivenessFeedback += "\nNIK " + isMatchedString +" with selfie ("+similarityPercentage.toStringAsFixed(2)+" %)";
      }
      else if(currentStatus == 'failed' || currentStatus == 'incompleted'){
        dukcapilFail = DukcapilFail.fromJson(jsonDecode(response.body));
        setState(() {
          messageDukcapil = dukcapilFail.message!;
          nodefluxSelfie = true;
          changeColor = true;
          similarityValue = 0.0;
          dukcapil = false;
          selfieProcessed = 'selfie ada';
        });

        if(messageDukcapil == 'Please ensure image format is JPEG, or NIK is registered on Dukcapil'){
          matchLivenessFeedback += "\nNIK doesn't match with face or NIK not registered on Dukcapil";
        }
        else if(messageDukcapil == "NIK is not found, please check your NIK"){
          matchLivenessFeedback += '\n$messageDukcapil';
        }
        else if(messageDukcapil == 'NIK data not found'){
          matchLivenessFeedback += '\n$messageDukcapil';
        }
        else if(messageDukcapil == 'Invalid Response from Gateway'){
          matchLivenessFeedback += 'Face doesn\'t match with Dukcapil';
        }
        else if(messageDukcapil == 'Gateway not Responding'){
          matchLivenessFeedback += 'Dukcapil verification server error';
        }
      }
      // await nodefluxSelfieMatchLivenessProcess(context);
    }
    catch(e){
      print('Error: $e');
    }
  }

  nodefluxSelfieMatchLivenessProcess(BuildContext context) async{
    String authorization = 'NODEFLUX-HMAC-SHA256 Credential=VFUWPCWUJEPWBSH3S7WNW7975/20220405/nodeflux.api.v1beta1.ImageAnalytic/StreamImageAnalytic, SignedHeaders=x-nodeflux-timestamp, Signature=ca67983c3bf8c688112b59f00e32f119481dbb2e6375e1ad5a7af66fca9cb7c8';
    final imageBytesSelfie = _selfieImage?.readAsBytesSync();
    String base64ImageSelfie = 'data:image/jpeg;base64,'+base64Encode(imageBytesSelfie!);
    final imageBytesEktp = widget.ektpImage.readAsBytesSync();
    String base64ImageEktp = 'data:image/jpeg;base64,'+base64Encode(imageBytesEktp);
    String currentStatus='';
    LivenessModelUnderqualified livenessModelUnderqualified = LivenessModelUnderqualified();
    MessageModel messageModel = MessageModel();
    LivenessModel livenessModel = LivenessModel();
    FacePairNotMatch facePairNotMatch = FacePairNotMatch();
    NoFaceDetected noFaceDetected = NoFaceDetected();
    bool okValue=false;

    try{
      var url='https://api.cloud.nodeflux.io/syncv2/analytics/face-match-liveness';
      List<String> photoBase64List=<String>[];
      photoBase64List.add(base64ImageEktp);
      photoBase64List.add(base64ImageSelfie);

      var response;

      response = await http
          .post(Uri.parse(url), body: json.encode({
        "images":photoBase64List
      }),
          headers: {"Accept": "application/json",  "Content-Type": "application/json",
            "x-nodeflux-timestamp": "20220405T094324Z",
            "Authorization": authorization
          });

      print(response.body);

      messageModel = MessageModel.fromJson(jsonDecode(response.body));
      message = messageModel.message!;
      okValue = messageModel.ok!;
      var status = messageModel.status;
      print(message + ' ' + okValue.toString());
      if (okValue) {
        currentStatus= status!;

        if (currentStatus == "success") {
          if(message == 'Face Liveness Underqualified'){
            livenessModelUnderqualified = LivenessModelUnderqualified.fromJson(jsonDecode(response.body));
            setState(() {
              livenessValue = livenessModelUnderqualified.result![0].faceLiveness!.liveness;
              isLive = livenessModelUnderqualified.result![0].faceLiveness!.live;
              underQualified = true;
              nodefluxSelfie = true;
              changeColor = true;
              selfieProcessed = 'selfie ada';
              messageDukcapil = ' ';
            });

            double livenessPercentage=livenessValue!*100;
            String isLiveString = (livenessPercentage>=widget.parameter.data![0].percentageLiveness!)? "from live ": "not from live ";
            matchLivenessFeedback= "Selfie is taken " + isLiveString +"person!";
            matchLivenessFeedback= '\nOR';
            matchLivenessFeedback= '\nLow photo quality';
          }
          else if(message == 'Face Match Liveness Success'){
            livenessModel = LivenessModel.fromJson(jsonDecode(response.body));
            setState(() {
              similarityValue = livenessModel.result![1].faceMatch!.similarity;
              isMatched = livenessModel.result![1].faceMatch!.match;
              livenessValue = livenessModel.result![0].faceLiveness!.liveness;
              isLive = livenessModel.result![0].faceLiveness!.live;
              nodefluxSelfie = true;
              changeColor = true;
            });

            // double similarityPercentage=similarityValue!*100;
            double livenessPercentage=livenessValue!*100;
            String isLiveString = (livenessPercentage>=widget.parameter.data![0].percentageLiveness!)? "from live ": "not from live ";
            // String isMatchedString = (similarityPercentage>=75)? "matched": "not matched";
            matchLivenessFeedback = "Selfie is taken " + isLiveString +"person ("+livenessPercentage.toStringAsFixed(2)+" %)";
            // matchLivenessFeedback+= "\neKTP photo is " + isMatchedString +" with selfie ("+similarityPercentage.toStringAsFixed(2)+" %)";
            nodefluxDukcapilProcess(context);
          }
          else if(message == "The Face Pair Not Match"){
            facePairNotMatch = FacePairNotMatch.fromJson(jsonDecode(response.body));
            setState(() {
              similarityValue = facePairNotMatch.result![1].faceMatch!.similarity;
              livenessValue = facePairNotMatch.result![0].faceLiveness!.liveness;
              isMatched = facePairNotMatch.result![1].faceMatch!.match;
              isLive = facePairNotMatch.result![0].faceLiveness!.live;
              nodefluxSelfie = true;
              changeColor = true;
            });

            // double similarityPercentage = similarityValue!*100;
            double livenessPercentage = livenessValue!*100;
            String isLiveString = (livenessPercentage>=widget.parameter.data![0].percentageLiveness!)? "from live ": "not from live ";
            // String isMatchedString = (similarityPercentage>=75)? "matched": "not matched";
            matchLivenessFeedback = "Selfie is taken " + isLiveString +"person ("+livenessPercentage.toStringAsFixed(2)+" %)";
            // matchLivenessFeedback+= "\neKTP photo is " + isMatchedString +" with selfie ("+similarityPercentage.toStringAsFixed(2)+" %)";
            nodefluxDukcapilProcess(context);
          }
        } else {
          noFaceDetected = NoFaceDetected.fromJson(jsonDecode(response.body));
          matchLivenessFeedback = noFaceDetected.message!;
          setState(() {
            message = noFaceDetected.message!;
            noFace = true;
            changeColor = true;
            selfieProcessed = 'selfie ada';
            livenessValue = 0.0;
          });
        }
      } else {
        matchLivenessFeedback= messageModel.message!;
        print(ektpImage?.exists());
      }
    }
    catch(e){
      debugPrint('Error $e');
    }
    // setState(() {
    //   print(matchLivenessFeedback);
    // });
    print('isi string $matchLivenessFeedback');
  }


  _getSelfieEktpImage(BuildContext context, ImageSource source) async{
    this.setState(() {
      //loading = true;
    });
    try{
      Directory tempDir = await getTemporaryDirectory();

      if (await tempDir.exists())
        tempDir.delete(recursive: false);

      Directory appdocdir= await getApplicationSupportDirectory();

      if (await appdocdir.exists())
        appdocdir.delete(recursive: false);

      XFile? xFilepicture =  await _picker.pickImage(source: source);
      File? picture = File(xFilepicture!.path);

      int? appFileDirectory=picture.path.lastIndexOf('/');
      String? resultDirectory=picture.path.substring(0,appFileDirectory+1);
      String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';

      int photoQuality=50;
      if(picture != null) {
        try {
          var result = await FlutterImageCompress.compressAndGetFile(
            picture.path, resultPath,
            quality: photoQuality,
          );

          int resultLength=result!.lengthSync();

          while ((resultLength < minPhotoSize || resultLength > maxPhotoSize) && photoQuality>0 && photoQuality<100) {
            if (result!=null)
              await result.delete();
            resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
            if ((resultLength > maxPhotoSize)) {
              photoQuality = photoQuality-10;
            } else {
              photoQuality = photoQuality+10;
            }
            result = await FlutterImageCompress.compressAndGetFile(
              picture.path, resultPath,
              quality: photoQuality,
            );
            resultLength=result!.lengthSync();
          }

          double sizeinKb=resultLength.toDouble()/1024;
          debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');
          await picture.delete();
          this.setState(() {
            _selfieEktpImage = result;
          });
        } catch (e) {
          print (e);
          debugPrint("Error $e");
        }
      }else{
        this.setState(() {
          //loading = false;
        });
      }
    } catch (e) {
      print (e);
      debugPrint("Error $e");
    }
    uploadImage(_selfieEktpImage!, "selfieEktp");
  }

  Widget showUploadSelfieButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: boxColor, width: 2),
          ),
          child: new ElevatedButton(
              child: new Text(
                  'Take Selfie Photo',
                  style: new TextStyle(fontSize: 12.0, color: textColor)),
              onPressed: () {
                // nodefluxSelfie? changeColor :
                _getSelfieImage(this.context, ImageSource.camera);
              },
              style: ElevatedButton.styleFrom(
                  primary: changeColor ? Colors.grey : buttonColor
              )
          ),
        )
    );
  }

  Widget showUploadSelfieEktpButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: boxColor, width: 2),
          ),
          child: new ElevatedButton(
              child: new Text(
                  'Take Selfie With eKTP Photo',
                  style: new TextStyle(fontSize: 12.0, color: textColor)),
              onPressed: () {
                nodefluxSelfie? changeColor :
                _getSelfieEktpImage(this.context, ImageSource.camera);
              },
              style: ElevatedButton.styleFrom(
                  primary: changeColor? Colors.grey : buttonColor
              )
          ),
        ));
  }

  Widget tryAgainButton(){
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: boxColor, width: 2),
          ),
          child: new ElevatedButton(
            child: new Text(
                'Try again',
                style: new TextStyle(fontSize: 12.0, color: textColor)),
            onPressed:  () {
              _getSelfieImage(this.context, ImageSource.camera);
              matchLivenessFeedback = "";
              selfieProcessed = "";
              message = "";
              underQualified = false;
            },
            style: ElevatedButton.styleFrom(
                primary: buttonColor
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        // firestore start
        ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column (
                  children: <Widget>[
                    SizedBox(height: 60),
                    _title(),
                    SizedBox(height: 50),
                    buildTextFormFieldName(),
                    SizedBox(height: 15),
                    buildTextFormFieldNik(),
                    buildTextFormFieldBirthplace(),
                    SizedBox(height: 15),
                    buildTextFormFieldBirthdate(),
                    SizedBox(height: 15),
                    buildTextFormFieldGender(),
                    SizedBox(height: 15),
                    buildTextFormFieldAddress(),
                    SizedBox(height: 15),
                    buildTextFormFieldRtRw(),
                    SizedBox(height: 15),
                    buildTextFormFieldKelurahanDesa(),
                    SizedBox(height: 15),
                    buildTextFormFieldKecamatan(),
                    SizedBox(height: 15),
                    buildTextFormFieldKabupatenKota(),
                    SizedBox(height: 15),
                    buildTextFormFieldProvince(),
                    SizedBox(height: 15),
                    buildTextFormFieldReligion(),
                    SizedBox(height: 15),
                    buildTextFormFieldMaritalStatus(),
                    SizedBox(height: 15),
                    buildTextFormFieldWorkfield(),
                    SizedBox(height: 15),
                    buildTextFormFieldExpiry(),
                    SizedBox(height: 15),
                    buildTextFormFieldBloodType(),
                    SizedBox(height: 15),
                    buildTextFormFieldNationality(),
                    SizedBox(height: 15),
                    buildTextFormFieldEmail(),
                    SizedBox(height: 15),
                    buildTextFormFieldMobilePhone(),
                    Column (
                        children: <Widget> [
                          showUploadSelfieEktpButton(),
                          (_selfieEktpImage != null)? showUploadSelfieButton() : Container(),
                          (selfieProcessed == 'lagi proses')? Text('Processing.. Please wait a moment..',
                              style: new TextStyle(fontSize: 12.0, color: Colors.black)):Container(),
                          (selfieProcessed == 'selfie ada')? Text('Processed',
                              style: new TextStyle(fontSize: 12.0, color: Colors.black)):Container(),
                          SizedBox(height: 10),
                          (matchLivenessFeedback != "") ?
                          Container(
                            child: (messageDukcapil != '' && selfieProcessed == 'selfie ada')? Container(
                                child: (message == 'Face Match Liveness Success' && messageDukcapil == 'Dukcapil Validation Success')?
                                Text(matchLivenessFeedback,
                                  style: new TextStyle(fontSize: 12.0, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ) : Text(matchLivenessFeedback,
                                  style: new TextStyle(fontSize: 12.0, color: Colors.red),
                                  textAlign: TextAlign.center,
                                )
                            ):Container(),
                          ):Container(),
                          (similarityValue != null && livenessValue != null && dukcapilStatus == 'success' &&
                              _selfieImage != null && similarityValue! >= widget.parameter.data![0].percentageSimilarity!/100 && livenessValue! >= widget.parameter.data![0].percentageLiveness!/100
                          )?
                          InkWell(
                              onTap: createData,
                              child:Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(color: boxColor, width: 2),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: boxColor,
                                          offset: Offset(2, 4),
                                          blurRadius: 8,
                                          spreadRadius: 2)
                                    ],
                                    color: buttonColor
                                ),
                                child: Text(
                                  'Start Video Call',
                                  style: TextStyle(fontSize:20, color: textColor),
                                  textAlign: TextAlign.center,
                                ),
                              )
                          )
                              :
                          Container(
                              child: (noFace && message == 'No face detected')? tryAgainButton()//true
                                  :
                              ((nodefluxSelfie)?
                              ((underQualified)? tryAgainButton()//true
                                  :
                              ((similarityValue! < widget.parameter.data![0].percentageSimilarity!/100 && livenessValue! < widget.parameter.data![0].percentageLiveness!/100 && dukcapilStatus != 'success' && selfieProcessed == 'selfie ada')? Column(
                                children: [
                                  SizedBox(height: 10),
                                  Text('Liveness or face match do not pass the requirement',
                                    style: TextStyle(fontSize: 15.0, color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  // SizedBox(height: 10),
                                  tryAgainButton()
                                ],
                              ):Container())) : Container())
                          ),
                        ]
                    ),
                  ],
                )


            ),
            SizedBox(height: 15),
          ],
        )
    );
  }

  checkQueue() async {
    int? queue1;
    int? queue2;
    String? checkNikRoom = widget.model.nik;
    int nik = int.parse(widget.model.nik!);
    TimeOfDay currTime = TimeOfDay.now();
    double _openTime = widget.parameter.data![0].operationalStart!;
    double _closeTime = widget.parameter.data![0].operationalEnd!;
    double _currTime = currTime.hour.toDouble() + (currTime.minute.toDouble()/60);

    await db.collection('rooms').doc('roomAgent1').collection('roomIDAgent1').get().then((value) => {
      print(value.docs.length),
      queue1 = value.docs.length,
      print('1')
    });

    await db.collection('rooms').doc('roomAgent2').collection('roomIDAgent2').get().then((value) => {
      print(value.docs.length),
      queue2 = value.docs.length,
      print('2')
    });

    await db.collection('rooms').doc('scheduledRoom').collection('scheduledRoomID').doc(checkNikRoom!).get().then((value){
      if(value.exists){
        scheduled = true;
        print("hasil schedule" + value.toString());
      }
      else{
        scheduled = false;
      }
    });

    print(queue1! + queue2! >= 3 || (_currTime <= _openTime || _currTime >= _closeTime));
    print(queue1! + queue2! < 3 && (_currTime >= _openTime && _currTime <= _closeTime));

    if(queue1! + queue2! >= 3 || (_currTime <= _openTime || _currTime >= _closeTime)){
      print('masuk notice');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Notice(nik: nik, email: firestoreEmail, name:firestoreName, parameter: widget.parameter,)));
    }
    else if(queue1! + queue2! < 3 && (_currTime >= _openTime && _currTime <= _closeTime)){
      print('masuk room');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => WebrtcRoom(scheduled: scheduled, nik: checkNikRoom, parameter: widget.parameter,)));
    }
  }

  void createData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      await db.collection('form').doc('user').update({
        'name': '$firestoreName',
        'nik': '$firestoreNik',
        'address': '$firestoreAddress',
        'dob': '$firestoreBirthdate',
        'pob': '$firestoreBirthplace',
        'gender': '$firestoreGender',
        'rtrw': '$firestoreRtRw',
        'kecamatan': '$firestoreKecamatan',
        'religion': '$firestoreReligion',
        'maritalstatus': '$firestoreMaritalStatus',
        'workfield': '$firestoreWorkfield',
        'province': '$firestoreProvince',
        'expiry': '$firestoreExpiry',
        'bloodtype': '$firestoreBloodType',
        'kabupatenkota': '$firestoreKabupatenKota',
        'kelurahandesa': '$firestoreKelurahanDesa',
        'nationality': '$firestoreNationality',
        'mobile': '$firestoreMobilePhone',
        'email': '$firestoreEmail'});

      checkQueue();
    }
  }

  TextFormField buildTextFormFieldName(){
    return TextFormField (
      controller: nameController,
      onChanged: (value){
        firestoreName = value;
        print(firestoreName);
      },
      decoration: new InputDecoration(
          hintText: 'Nama',
          icon: new Icon(
            Icons.person,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input nama';
        }
        return null;
      },
      onSaved: (value) => firestoreName = value!,
    );
  }

  TextFormField buildTextFormFieldNik(){
    return TextFormField (
      maxLength: 16,
      controller: nikController,
      onChanged: (value){
        widget.model.nik = value;
      },
      keyboardType: TextInputType.number,
      decoration: new InputDecoration(
          hintText: 'NIK',
          icon: new Icon(
            Icons.credit_card,
            color: Colors.grey,
          )),
      validator: (String? value) {
        if (value!.isEmpty || value.length < 16) {
          return 'Please input NIK';
        }
        return null;
      },
      onSaved: (value) => firestoreNik = value!,
    );
  }

  TextFormField buildTextFormFieldAddress(){
    return TextFormField (
      controller: addressController,
      decoration: new InputDecoration(
          hintText: 'Address',
          icon: new Icon(
            Icons.home,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input alamat';
        }
        return null;
      },
      onSaved: (value) => firestoreAddress = value!,
    );
  }

  TextFormField buildTextFormFieldBirthdate(){
    return TextFormField (
      controller: birthdateController,
      decoration: new InputDecoration(
          hintText: 'Date of Birth',
          icon: new Icon(
            Icons.calendar_today,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input tanggal lahir';
        }
        return null;
      },
      onSaved: (value) => firestoreBirthdate = value!,
    );
  }

  TextFormField buildTextFormFieldBirthplace(){
    return TextFormField (
      controller: birthplaceController,
      decoration: new InputDecoration(
          hintText: 'Tempat Lahir',
          icon: new Icon(
            Icons.location_city,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input tempat lahir';
        }
        return null;
      },
      onSaved: (value) => firestoreBirthplace = value!,
    );
  }

  TextFormField buildTextFormFieldGender(){
    return TextFormField (
      controller: genderController,
      decoration: new InputDecoration(
          hintText: 'Jenis Kelamin',
          icon: new Icon(
            Icons.person,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input gender';
        }
        return null;
      },
      onSaved: (value) => firestoreGender = value!,
    );
  }

  TextFormField buildTextFormFieldRtRw(){
    return TextFormField (
      controller:rtrwController,
      //maxLength: 16,
      decoration: new InputDecoration(
          hintText: 'RT / RW',
          icon: new Icon(
            Icons.map,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input RT/RW';
        }
        return null;
      },
      onSaved: (value) => firestoreRtRw = value!,
    );
  }

  TextFormField buildTextFormFieldKecamatan(){
    return TextFormField (
      controller:kecamatanController,
      //maxLength: 16,
      decoration: new InputDecoration(
          hintText: 'Kecamatan',
          icon: new Icon(
            Icons.map,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input Kecamatan';
        }
        return null;
      },
      onSaved: (value) => firestoreKecamatan = value!,
    );
  }

  TextFormField buildTextFormFieldReligion(){
    return TextFormField (
      //maxLength: 16,
      controller:religionController,
      decoration: new InputDecoration(
          hintText: 'Agama',
          icon: new Icon(
            Icons.home_outlined,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input agama';
        }
        return null;
      },
      onSaved: (value) => firestoreReligion = value!,
    );
  }

  TextFormField buildTextFormFieldMaritalStatus(){
    return TextFormField (
      //maxLength: 16,
      controller:maritalStatusController,
      decoration: new InputDecoration(
          hintText: 'Status Perkawinan',
          icon: new Icon(
            Icons.home_outlined,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input status perkawinan';
        }
        return null;
      },
      onSaved: (value) => firestoreMaritalStatus = value!,
    );
  }

  TextFormField buildTextFormFieldWorkfield(){
    return TextFormField (
      controller:workfieldController,
      //maxLength: 16,
      decoration: new InputDecoration(
          hintText: 'Pekerjaan',
          icon: new Icon(
            Icons.location_city,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input pekerjaan';
        }
        return null;
      },
      onSaved: (value) => firestoreWorkfield = value!,
    );
  }

  TextFormField buildTextFormFieldProvince(){
    return TextFormField (
      controller:provinceController,
      //maxLength: 16,
      decoration: new InputDecoration(
          hintText: 'Provinsi',
          icon: new Icon(
            Icons.map,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input provinsi';
        }
        return null;
      },
      onSaved: (value) => firestoreProvince = value!,
    );
  }

  TextFormField buildTextFormFieldExpiry(){
    return TextFormField (
      //maxLength: 16,
      controller:expiryController,
      decoration: new InputDecoration(
          hintText: 'Berlaku Hingga',
          icon: new Icon(
            Icons.calendar_today,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input tanggal berlaku';
        }
        return null;
      },
      onSaved: (value) => firestoreExpiry = value!,
    );
  }

  TextFormField buildTextFormFieldBloodType(){
    return TextFormField (
      controller:bloodTypeController,
      //maxLength: 16,
      decoration: new InputDecoration(
          hintText: 'Golongan Darah',
          icon: new Icon(
            Icons.account_box_rounded,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input gol. darah';
        }
        return null;
      },
      onSaved: (value) => firestoreBloodType = value!,
    );
  }

  TextFormField buildTextFormFieldKabupatenKota(){
    return TextFormField (
      //maxLength: 16,
      controller: kabupatenKotaController,
      decoration: new InputDecoration(
          hintText: 'Kabupaten / Kota',
          icon: new Icon(
            Icons.person,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input kabupaten/kota';
        }
        return null;
      },
      onSaved: (value) => firestoreKabupatenKota = value!,
    );
  }

  TextFormField buildTextFormFieldKelurahanDesa(){
    return TextFormField (
      controller:kelurahanDesaController,
      //maxLength: 16,
      decoration: new InputDecoration(
          hintText: 'Kelurahan / Desa',
          icon: new Icon(
            Icons.location_city,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input kelurahan/desa';
        }
        return null;
      },
      onSaved: (value) => firestoreKelurahanDesa = value!,
    );
  }


  TextFormField buildTextFormFieldNationality(){
    return TextFormField (
      //maxLength: 16,
      controller:nationalityController,
      decoration: new InputDecoration(
          hintText: 'Kewarganegaraan',
          icon: new Icon(
            Icons.credit_card,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please input kewarganegaraan';
        }
        return null;
      },
      onSaved: (value) => firestoreNationality = value!,
    );
  }


  TextFormField buildTextFormFieldEmail(){
    return TextFormField (
      controller:emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: new InputDecoration(
          hintText: 'Email',
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          )),
      validator: (value){
        isEmail = EmailValidator.validate(value!);

        if (value.isEmpty || !isEmail) {
          print(value.isNotEmpty);
          print(isEmail);
          return 'Please input a valid email address';
        }
        return null;
      },
      onSaved: (value) => firestoreEmail = value!,
    );
  }

  TextFormField buildTextFormFieldMobilePhone(){
    return TextFormField (
      controller:mobilePhoneController,
      keyboardType: TextInputType.phone,
      decoration: new InputDecoration(
          hintText: 'Mobile Phone Number (e.g. 08xxxx)',
          icon: new Icon(
            Icons.phone_android,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value!.isEmpty || value.length < 11 || value.length > 12) {
          return 'Input a proper phone number';
        }
        return null;
      },
      onSaved: (value) => firestoreMobilePhone = value!,
    );
  }

  Future uploadImage(File fileVar, String fileName) async {
    Reference _reference = FirebaseStorage.instance.ref().child(fileName+'.jpg');
    UploadTask uploadTask = _reference.putFile(fileVar);
    await uploadTask; // so when the upload task is complete we can have a snapshot [Maya note]
  }
}