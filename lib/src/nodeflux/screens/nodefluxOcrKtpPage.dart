import 'package:flutter/material.dart';
import '../../pages/signup.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Widget/bezierContainer.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/nodeflux_data_model.dart';
import '../models/nodeflux_data_model_sync2.dart';
import '../models/nodeflux_job_model.dart';
import '../models/nodeflux_result_model.dart';
import '../models/nodeflux_result2_model.dart';
import 'dart:convert';

import 'nodefluxOcrKtpResultPage.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../webrtc_room/webrtc_room.dart';
import '../models/livenessUnderqualified.dart';
import '../models/messageModel.dart';
import '../models/modelLivenessNathan.dart';
import '../models/face_pair_not_match.dart';
import '../models/no_face_detected.dart';

class NodefluxOcrKtpPage extends StatefulWidget {
  NodefluxOcrKtpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NodefluxOcrKtpPageState createState() => _NodefluxOcrKtpPageState();
}

class _NodefluxOcrKtpPageState extends State<NodefluxOcrKtpPage> {
  DateTime selectedbirthdate=null;
  File _imageFile;

  File _ektpImage;
  File _selfieImage;
  File _npwpImage;
  File _selfieEktpImage;

  TextEditingController nikController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController birthplaceController = TextEditingController();
  TextEditingController mobilePhoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController, genderController, rtrwController, kecamatanController, religionController, maritalStatusController, workfieldController, provinceController, expiryController,
    bloodTypeController, kabupatenKotaController, kelurahanDesaController, nationalityController;

  //firestore
  String firestoreId;

  FirebaseFirestore db;
  final _formKey = GlobalKey<FormState>();
  String firestoreName;
  String firestoreNik;
  String firestoreAddress;
  String firestoreBirthdate;
  String firestoreBirthplace;
  String firestoreGender;
  String firestoreRtRw;
  String firestoreKecamatan;
  String firestoreReligion;
  String firestoreMaritalStatus;
  String firestoreWorkfield;
  String firestoreProvince;
  String firestoreExpiry;
  String firestoreBloodType;
  String firestoreKabupatenKota;
  String firestoreKelurahanDesa;
  String firestoreNationality;
  String firestoreMobilePhone;
  String firestoreEmail;

  int minPhotoSize=256000; // 250KB
  int maxPhotoSize=512000; // 500KB

  String ocrNama, ocrNik, ocrTempatLahir, ocrTanggalLahir, ocrJenisKelamin, ocrAlamat, ocrRtrw, ocrKecamatan, ocrAgama, ocrStatusPerkawinan,
      ocrPekerjaan, ocrProvinsi, ocrBerlakuHingga, ocrGolonganDarah, ocrKabupatenKota, ocrKelurahanDesa, ocrKewarganegaraan;

  //NodefluxResult2Model nodefluxResult2Model =NodefluxResult2Model();
  NodefluxResult2Model _nodefluxResult2Model;
  bool isLive;
  bool isMatched;
  bool nodefluxSelfie = false;
  double livenessValue;
  double similarityValue;
  String matchLivenessFeedback="";
  String message = '';
  bool noFace = false;
  bool underQualified = false;
  bool changeColor = false;
  String ktpDetected = '';
  bool ktpProcessed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      db = FirebaseFirestore.instance;
      print("completed");
      setup();
    });

  }

  setup() {
    nikController= TextEditingController(text: ocrNik!=null? ocrNik:"");
    nameController= TextEditingController(text: ocrNama!=null? ocrNama:"");
    birthdateController= TextEditingController(text: ocrTanggalLahir!=null? ocrTanggalLahir:"");
    birthplaceController= TextEditingController(text: ocrTempatLahir!=null? ocrTempatLahir:"");
    genderController= TextEditingController(text: ocrJenisKelamin!=null? ocrJenisKelamin:"");
    addressController= TextEditingController(text: ocrAlamat!=null? ocrAlamat:"");
    rtrwController= TextEditingController(text: ocrRtrw!=null? ocrRtrw:"");
    kecamatanController= TextEditingController(text: ocrKecamatan!=null? ocrKecamatan:"");
    religionController= TextEditingController(text: ocrAgama!=null? ocrAgama:"");
    maritalStatusController= TextEditingController(text: ocrStatusPerkawinan!=null? ocrStatusPerkawinan:"");
    workfieldController= TextEditingController(text: ocrPekerjaan!=null? ocrPekerjaan:"");
    provinceController= TextEditingController(text: ocrProvinsi!=null? ocrProvinsi:"");
    expiryController= TextEditingController(text: ocrBerlakuHingga!=null? ocrBerlakuHingga:"");
    bloodTypeController= TextEditingController(text: ocrGolonganDarah!=null? ocrGolonganDarah:"");
    kabupatenKotaController= TextEditingController(text: ocrKabupatenKota!=null? ocrKabupatenKota:"");
    kelurahanDesaController= TextEditingController(text: ocrKelurahanDesa!=null? ocrKelurahanDesa:"");
    nationalityController= TextEditingController(text: ocrKewarganegaraan!=null? ocrKewarganegaraan:"");
    _ektpImage=null;
    _selfieImage=null;
    _nodefluxResult2Model=null;
    isLive=false;
    isMatched=false;
    livenessValue = null;
    similarityValue= null;
    matchLivenessFeedback="";
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return
      InkWell(
          onTap: () {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => VideoCallPage()));;

            Navigator.push(
                context,
                MaterialPageRoute(
                    //builder: (BuildContext context) => CallSample(host: 'demo.cloudwebrtc.com')));
                    builder: (BuildContext context) => WebrtcRoom()));
          },
          child:

          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xfffbb448), Color(0xfff7892b)])),
            child: Text(
              'Saya siap melakukan video call',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
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
            // color: Color(0xffe46b10),
            color: Colors.white
          ),
          children: [
            TextSpan(
              text: 'Information',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            // TextSpan(
            //   text: 'Form',
            //   style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            // ),
          ]),
    );
  }


  Widget showUploadSelfieButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: new ElevatedButton(
            child: new Text(
                //'Ambil Foto Selfie',
              'Take Selfie Photo',
                style: new TextStyle(fontSize: 12.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed: () {
              nodefluxSelfie? changeColor :
              _getSelfieImage(this.context, ImageSource.camera);
            },
            style: ElevatedButton.styleFrom(
              primary: changeColor? Colors.grey : Colors.green[700]
            )
          ),
        ));
  }

  Widget showUploadSelfie2Button(){
    return Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: RaisedButton(
          color: Colors.orange,
          textColor: Colors.white,
          child:
          Text(
            'Upload Selfie',
            textScaleFactor: 1.5,
          ),
          onPressed: () {

            _getEktpImage(this.context, ImageSource.camera);
          },
        )
    );
  }

  _getEktpImage0(BuildContext context, ImageSource source) async{
    this.setState(() {
      //loading = true;
    });
    var picture = await ImagePicker.pickImage(source: source);

    if(picture != null){
      //File cropped=picture;
      try {
        File cropped = await ImageCropper.cropImage(
            sourcePath: picture.path,
            aspectRatio: CropAspectRatio(ratioX: 8, ratioY: 5),
            compressQuality: 100,
            maxWidth: 640,
            maxHeight: 480,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.deepOrange,
              toolbarTitle: "RPS Cropper",
              statusBarColor: Colors.deepOrange.shade900,
              backgroundColor: Colors.white,
            )
        );
        this.setState(() {
          _ektpImage = cropped;
          //loading = false;
        });
      }
      catch (e) {
        print (e);
        debugPrint("Error $e");
      }
    }else{
      this.setState(() {
        //loading = false;
      });
    }


    Navigator.of(context).pop();
  }

  _getEktpImage(BuildContext context, ImageSource source) async{
    this.setState(() {
      //loading = true;
    });
    try{
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      if (await tempDir.exists())
        tempDir.delete(recursive: false);

      Directory appdocdir= await getApplicationSupportDirectory();
      String test=appdocdir.path;

      if (await appdocdir.exists())
        appdocdir.delete(recursive: false);

      var picture =  await ImagePicker.pickImage(source: source);

      int appFileDirectory=picture.path.lastIndexOf('/');
      String resultDirectory=picture.path.substring(0,appFileDirectory+1); // = appdocdir+'/Pictures/'
      String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
      //String resultPath='/storage/emulated/0/Android/data/com.smartherd.flutter_app_section2/files/Pictures/'+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';

      int photoQuality=90;


      if(picture != null) {
        try {
          var result = await FlutterImageCompress.compressAndGetFile(
            picture.absolute.path, resultPath,
            quality: photoQuality,
          );

          int pictureLength=picture.lengthSync();
          int resultLength=result.lengthSync();

          var i = 1;

          while ((resultLength < minPhotoSize || resultLength > maxPhotoSize) && photoQuality>0 && photoQuality<100) {
            if (result!=null)
              await result.delete();
            resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
            photoQuality=(resultLength>maxPhotoSize)? photoQuality-10:photoQuality+10;
            result = await FlutterImageCompress.compressAndGetFile(
              picture.absolute.path, resultPath,
              quality: photoQuality,
            );
            resultLength=result.lengthSync();
          }

          //comment end

          double sizeinKb=resultLength.toDouble()/1024;
          debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');
          //print(pictureLength+resultLength);
          await picture.delete();
          this.setState(() {
            //_imageFileProfile = cropped;
            _ektpImage = result;
            ktpDetected = 'lagi proses';
            nodefluxSelfie = true;
            changeColor = true;
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
    //Navigator.of(context).pop();

    await nodefluxOcrKtpProcess(context);
    await uploadImage(_ektpImage, "ektp");
  }

  nodefluxOcrKtpProcess(BuildContext context) async{
    setState(() {
      //loading = true;
    });
    //String trx_id = 'Liveness_' + DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String authorization = 'NODEFLUX-HMAC-SHA256 Credential=ZZC8MB2EHH01G3FX60ZNZS7KA/20201110/nodeflux.api.v1beta1.ImageAnalytic/StreamImageAnalytic, SignedHeaders=x-nodeflux-timestamp, Signature=5a6b903b95b8f3c9677169d69b13b4f790799ffba897405b7826770f51fd4a21';
    String contentType = 'application/json';
    String xnodefluxtimestamp='20201110T135945Z';
    final imageBytes = _ektpImage.readAsBytesSync();
    String base64Image = 'data:image/jpeg;base64,'+base64Encode(imageBytes);
    String dialog = "";
    bool isPassed=false;
    String currentStatus="";
    NodefluxDataModel nodefluxDataModel=NodefluxDataModel();
    NodefluxJobModel nodefluxJobModel=NodefluxJobModel();
    NodefluxResultModel nodefluxResultModel = NodefluxResultModel();
    // NodefluxResult2Model nodefluxResult2Model =NodefluxResult2Model();
    bool okValue=true;
    try{

      var url='https://api.cloud.nodeflux.io/v1/analytics/ocr-ktp';
      List<String> photoBase64List=List<String>();
      photoBase64List.add(base64Image);

      var response;
      while (currentStatus=="on going" || currentStatus=="") {
        response = await http
            .post(Uri.parse(url), body: json.encode({
          "images":photoBase64List
        }), headers: {"Accept": "application/json",  "Content-Type": "application/json",
          "x-nodeflux-timestamp": "20201110T135945Z",
          "Authorization": authorization,});

        print(response.body);

        var respbody=response.body;
        nodefluxDataModel=NodefluxDataModel.fromJson00(jsonDecode(response.body));
        okValue=nodefluxDataModel.ok;
        if (okValue) {
          nodefluxDataModel=NodefluxDataModel.fromJson0(jsonDecode(response.body));
          nodefluxJobModel=nodefluxDataModel.job;
          nodefluxResultModel = nodefluxJobModel.result;

          currentStatus=nodefluxResultModel.status;
          message = nodefluxDataModel.message;
        } else {
          dialog=nodefluxDataModel.message;
          isPassed=false;
        }
      }

      if (response!=null && currentStatus=="success") {
        nodefluxDataModel=NodefluxDataModel.fromJson(jsonDecode(response.body));
        nodefluxJobModel=nodefluxDataModel.job;
        nodefluxResultModel = nodefluxJobModel.result;
        _nodefluxResult2Model = nodefluxResultModel.result[0];
      }

      // decipherin result
      if(nodefluxResultModel.status != 'on going' && nodefluxDataModel.message != 'Job successfully submitted'){
        if (nodefluxResultModel.status=="success" && nodefluxDataModel.message=="OCR_KTP Service Success") { // if photo ktp
          dialog="OCR Process success";
          isPassed=true;
          setState(() {
            ocrNik = _nodefluxResult2Model.nik;
            ocrNama= _nodefluxResult2Model.nama;
            ocrTempatLahir = _nodefluxResult2Model.tempat_lahir;
            ocrTanggalLahir = _nodefluxResult2Model.tanggal_lahir;
            ocrJenisKelamin = _nodefluxResult2Model.jenis_kelamin;
            ocrAlamat = _nodefluxResult2Model.alamat;
            ocrRtrw = _nodefluxResult2Model.rt_rw;
            ocrKecamatan = _nodefluxResult2Model.kecamatan;
            ocrAgama = _nodefluxResult2Model.agama;
            ocrStatusPerkawinan = _nodefluxResult2Model.status_perkawinan;
            ocrPekerjaan = _nodefluxResult2Model.pekerjaan;
            ocrProvinsi = _nodefluxResult2Model.provinsi;
            ocrBerlakuHingga = _nodefluxResult2Model.berlaku_hingga;
            ocrGolonganDarah = _nodefluxResult2Model.golongan_darah;
            ocrKabupatenKota = _nodefluxResult2Model.kabupaten_kota;
            ocrKelurahanDesa = _nodefluxResult2Model.kelurahan_desa;
            ocrKewarganegaraan= _nodefluxResult2Model.kewarganegaraan;
            ktpDetected = 'ktp ada';
            ktpProcessed = true;
          });
        }
        else if(nodefluxResultModel.status == 'incompleted' && nodefluxDataModel.message != "OCR_KTP Service Success"){
          setState(() {
            ktpDetected = 'ktp ga ada';
            ktpProcessed = true;
          });
        }
      }
      // else if (nodefluxDataModel.message=="The image might be in wrong orientation"){ // if photo not ktp/ wrong orientation
      //   dialog=nodefluxDataModel.message+" or photo is not KTP";
      // }
    }
    catch(e){
      debugPrint('Error $e');
      dialog=e;
    }
    setState(() {
      //loading = false;

    });
    //createAlertDialog(context,isPassed?'Success!':'Failed',dialog);

  }

  createAlertDialog(BuildContext context, String title, String message) {
    Widget okButton = FlatButton(
      child: Text("Close"),
      onPressed: () {Navigator.of(context).pop(); },
    );

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(title), content: Text(message),  actions: [
            okButton,
          ],);
        });
  }

  _getNpwpImage(BuildContext context, ImageSource source) async{
    this.setState(() {
      //loading = true;
    });
    try{
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      if (await tempDir.exists())
        tempDir.delete(recursive: false);

      Directory appdocdir= await getApplicationSupportDirectory();
      String test=appdocdir.path;

      if (await appdocdir.exists())
        appdocdir.delete(recursive: false);

      var picture =  await ImagePicker.pickImage(source: source);

      int appFileDirectory=picture.path.lastIndexOf('/');
      String resultDirectory=picture.path.substring(0,appFileDirectory+1); // = appdocdir+'/Pictures/'
      String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
      //String resultPath='/storage/emulated/0/Android/data/com.smartherd.flutter_app_section2/files/Pictures/'+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';

      int photoQuality=50;
      if(picture != null) {
        try {
          var result = await FlutterImageCompress.compressAndGetFile(
            picture.absolute.path, resultPath,
            quality: photoQuality,
          );

          int pictureLength=picture.lengthSync();
          int resultLength=result.lengthSync();

          var i = 1;

          while ((resultLength < minPhotoSize || resultLength > maxPhotoSize) && photoQuality>0 && photoQuality<100) {
            if (result!=null)
              await result.delete();
            resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
            photoQuality=(resultLength>maxPhotoSize)? photoQuality-10:photoQuality+10;
            result = await FlutterImageCompress.compressAndGetFile(
              picture.absolute.path, resultPath,
              quality: photoQuality,
            );
            resultLength=result.lengthSync();
          }

          double sizeinKb=resultLength.toDouble()/1024;
          debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');
          //print(pictureLength+resultLength);
          await picture.delete();
          this.setState(() {
            //_imageFileProfile = cropped;
            _npwpImage = result;
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
    //Navigator.of(context).pop();
    uploadImage(_npwpImage, "npwp");
  }

  _getSelfieImage(BuildContext context, ImageSource source) async{
    this.setState(() {
      //loading = true;
    });
    try{
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      if (await tempDir.exists())
        tempDir.delete(recursive: false);

      Directory appdocdir= await getApplicationSupportDirectory();
      String test=appdocdir.path;

      if (await appdocdir.exists())
        appdocdir.delete(recursive: false);

      var picture =  await ImagePicker.pickImage(source: source);

      int appFileDirectory=picture.path.lastIndexOf('/');
      String resultDirectory=picture.path.substring(0,appFileDirectory+1); // = appdocdir+'/Pictures/'
      String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
      //String resultPath='/storage/emulated/0/Android/data/com.smartherd.flutter_app_section2/files/Pictures/'+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';

      int photoQuality=90;
      if(picture != null) {
        try {
          var result = await FlutterImageCompress.compressAndGetFile(
            picture.absolute.path, resultPath,
            quality: photoQuality,
          );

          int pictureLength=picture.lengthSync();
          int resultLength=result.lengthSync();

          var i = 1;

          while ((resultLength < minPhotoSize || resultLength > maxPhotoSize) && photoQuality>0 && photoQuality<100) {
            if (result!=null)
              await result.delete();
            resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
            photoQuality=(resultLength>maxPhotoSize)? photoQuality-10:photoQuality+10;
            result = await FlutterImageCompress.compressAndGetFile(
              picture.absolute.path, resultPath,
              quality: photoQuality,
            );
            resultLength=result.lengthSync();
          }

          double sizeinKb=resultLength.toDouble()/1024;
          debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');
          //print(pictureLength+resultLength);
          await picture.delete();
          this.setState(() {
            //_imageFileProfile = cropped;
            _selfieImage = result;
            ktpDetected = 'lagi proses';
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
    //Navigator.of(context).pop();

    // Nodeflux API
    // Process kalau selfie live
    await nodefluxSelfieMatchLivenessProcess(context);
    await uploadImage(_selfieImage, "selfie");
    // Navigator.of(context).push(MaterialPageRoute(
    //   // builder: (context) => NodefluxOcrKtpResult(nodefluxResultModel.result[0])));
    //     builder: (context) => NodefluxOcrKtpResultPage(nodefluxResult2Model, _ektpImage, _selfieImage)));
  }

  nodefluxSelfieMatchLivenessProcess(BuildContext context) async{
    setState(() {
      //loading = true;
    });
    //String trx_id = 'Liveness_' + DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String authorization = 'NODEFLUX-HMAC-SHA256 Credential=ZZC8MB2EHH01G3FX60ZNZS7KA/20201110/nodeflux.api.v1beta1.ImageAnalytic/StreamImageAnalytic, SignedHeaders=x-nodeflux-timestamp, Signature=5a6b903b95b8f3c9677169d69b13b4f790799ffba897405b7826770f51fd4a21';
    String contentType = 'application/json';
    String xnodefluxtimestamp='20201110T135945Z';
    final imageBytesSelfie = _selfieImage.readAsBytesSync();
    String base64ImageSelfie = 'data:image/jpeg;base64,'+base64Encode(imageBytesSelfie);
    final imageBytesEktp = _ektpImage.readAsBytesSync();
    String base64ImageEktp = 'data:image/jpeg;base64,'+base64Encode(imageBytesEktp);
    String dialog = "";
    bool isPassed=false;
    String currentStatus='';
    NodefluxDataModelSync2 nodefluxDataModelSync2=NodefluxDataModelSync2();
    LivenessModelUnderqualified livenessModelUnderqualified = LivenessModelUnderqualified();
    MessageModel messageModel = MessageModel();
    LivenessModel livenessModel = LivenessModel();
    FacePairNotMatch facePairNotMatch = FacePairNotMatch();
    NoFaceDetected noFaceDetected = NoFaceDetected();
    bool okValue=false;

    try{
      var url='https://api.cloud.nodeflux.io/syncv2/analytics/face-match-liveness';
      List<String> photoBase64List=List<String>();
      photoBase64List.add(base64ImageEktp);
      photoBase64List.add(base64ImageSelfie);

      var response;
      // while (currentStatus!='success' && okValue) {
        response = await http
            .post(Uri.parse(url), body: json.encode({
          "images":photoBase64List
        }), headers: {"Accept": "application/json",  "Content-Type": "application/json",
          "x-nodeflux-timestamp": "20201110T135945Z",
          "Authorization": authorization,});

        print(response.body);

        var respbody=response.body;
        // first check ok value
        messageModel = MessageModel.fromJson(jsonDecode(response.body));
        message = messageModel.message;
        okValue = messageModel.ok;
        var status = messageModel.status;
        print(message + ' ' + okValue.toString());
        // second, if ok false, exit; if ok true, check status [success or incompleted]
        if (okValue) {
          currentStatus= status;
          // third, if status: success, ada liveness -> check liveness > live


          if (currentStatus == "success") {
            if(message == 'Face Liveness Underqualified'){
              livenessModelUnderqualified = LivenessModelUnderqualified.fromJson(jsonDecode(response.body));
              setState(() {
                livenessValue = livenessModelUnderqualified.result[0].faceLiveness.liveness;
                isLive = livenessModelUnderqualified.result[0].faceLiveness.live;
                underQualified = true;
                nodefluxSelfie = true;
                changeColor = true;
              });

              double livenessPercentage=livenessValue*100;
              String isLiveString = (livenessPercentage>=75)? "from live ": "not from live ";
              matchLivenessFeedback= "Selfie is taken " + isLiveString +"person!";
              matchLivenessFeedback+= '\nOR';
              matchLivenessFeedback+= '\nLow photo quality';
            }
            else if(message == 'Face Match Liveness Success'){
              livenessModel = LivenessModel.fromJson(jsonDecode(response.body));
              setState(() {
                similarityValue = livenessModel.result[1].faceMatch.similarity;
                isMatched = livenessModel.result[1].faceMatch.match;
                livenessValue = livenessModel.result[0].faceLiveness.liveness;
                isLive = livenessModel.result[0].faceLiveness.live;
                nodefluxSelfie = true;
                changeColor = true;
              });

              double similarityPercentage=similarityValue*100;
              double livenessPercentage=livenessValue*100;
              String isLiveString = (livenessPercentage>=75)? "from live ": "not from live ";
              String isMatchedString = (similarityPercentage>=75)? "matched": "not matched";
              matchLivenessFeedback = "Selfie is taken " + isLiveString +"person ("+livenessPercentage.toStringAsFixed(2)+" %)";
              matchLivenessFeedback+= "\neKTP photo is " + isMatchedString +" with selfie ("+similarityPercentage.toStringAsFixed(2)+" %)";
            }
            else if(message == "The Face Pair Not Match"){
              facePairNotMatch = FacePairNotMatch.fromJson(jsonDecode(response.body));
              setState(() {
                similarityValue = facePairNotMatch.result[1].faceMatch.similarity;
                livenessValue = facePairNotMatch.result[0].faceLiveness.liveness;
                isMatched = facePairNotMatch.result[1].faceMatch.match;
                isLive = facePairNotMatch.result[0].faceLiveness.live;
                nodefluxSelfie = true;
                changeColor = true;
              });

              double similarityPercentage = similarityValue*100;
              double livenessPercentage = livenessValue*100;
              String isLiveString = (livenessPercentage>=75)? "from live ": "not from live ";
              String isMatchedString = (similarityPercentage>=75)? "matched": "not matched";
              matchLivenessFeedback = "Selfie is taken " + isLiveString +"person ("+livenessPercentage.toStringAsFixed(2)+" %)";
              matchLivenessFeedback+= "\neKTP photo is " + isMatchedString +" with selfie ("+similarityPercentage.toStringAsFixed(2)+" %)";
            }
          } else {
            noFaceDetected = NoFaceDetected.fromJson(jsonDecode(response.body));
            matchLivenessFeedback = noFaceDetected.message;
            setState(() {
              message = noFaceDetected.message;
              noFace = true;
              changeColor = true;
            });
          }
        } else {
          dialog=nodefluxDataModelSync2.message;
          matchLivenessFeedback=nodefluxDataModelSync2.message;
          isPassed=false;
        }
    }
    catch(e){
      debugPrint('Error $e');
      dialog=e;
    }
    setState(() {
      //loading = false;

    });
  }

  _getSelfieEktpImage(BuildContext context, ImageSource source) async{
    this.setState(() {
      //loading = true;
    });
    try{
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      if (await tempDir.exists())
        tempDir.delete(recursive: false);

      Directory appdocdir= await getApplicationSupportDirectory();
      String test=appdocdir.path;

      if (await appdocdir.exists())
        appdocdir.delete(recursive: false);

      var picture =  await ImagePicker.pickImage(source: source);

      int appFileDirectory=picture.path.lastIndexOf('/');
      String resultDirectory=picture.path.substring(0,appFileDirectory+1); // = appdocdir+'/Pictures/'
      String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
      //String resultPath='/storage/emulated/0/Android/data/com.smartherd.flutter_app_section2/files/Pictures/'+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';

      int photoQuality=50;
      if(picture != null) {
        try {
          var result = await FlutterImageCompress.compressAndGetFile(
            picture.absolute.path, resultPath,
            quality: photoQuality,
          );

          int pictureLength=picture.lengthSync();
          int resultLength=result.lengthSync();

          var i = 1;

          while ((resultLength < minPhotoSize || resultLength > maxPhotoSize) && photoQuality>0 && photoQuality<100) {
            if (result!=null)
              await result.delete();
            resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
            photoQuality=(resultLength>maxPhotoSize)? photoQuality-10:photoQuality+10;
            result = await FlutterImageCompress.compressAndGetFile(
              picture.absolute.path, resultPath,
              quality: photoQuality,
            );
            resultLength=result.lengthSync();
          }

          double sizeinKb=resultLength.toDouble()/1024;
          debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');
          //print(pictureLength+resultLength);
          await picture.delete();
          this.setState(() {
            //_imageFileProfile = cropped;
            _selfieEktpImage = result;
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
    //Navigator.of(context).pop();
    uploadImage(_selfieEktpImage, "selfieEktp");
  }



  Widget showUploadEktpButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: new ElevatedButton(
            child: new Text(
                //'Ambil Foto eKTP',
              'Take eKTP Photo',
                style: new TextStyle(fontSize: 12.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed:  () {
              nodefluxSelfie? changeColor: _getEktpImage(this.context, ImageSource.camera);
            },
            style: ElevatedButton.styleFrom(
              primary: changeColor? Colors.grey : Colors.green[700]
            ),
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
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: new ElevatedButton(
            child: new Text(
              //'Ambil Foto eKTP',
                'Try again',
                style: new TextStyle(fontSize: 12.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed:  () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                primary: changeColor? Colors.red : Colors.red
            ),
          ),
        ));
  }

  Widget showUploadSelfieEktpButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new ElevatedButton(
            child: new Text('Foto Selfie dg eKTP Bawah Dagu',
                style: new TextStyle(fontSize: 12.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed:  () {
              _getSelfieEktpImage(this.context, ImageSource.camera);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue
            ),
          ),
        ));
  }

  Widget showUploadNpwpButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.lightBlue,
            child: new Text('Ambil Foto NPWP',
                style: new TextStyle(fontSize: 12.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed:  () {
              _getNpwpImage(this.context, ImageSource.camera);
            },
          ),
        ));
  }

  Future getImage() async {

    File registerSelfieimage;
    //Future<bool> faceMatchFound=Future<bool>.value(false);
    bool faceMatchFound1 = false;
    registerSelfieimage= await ImagePicker.pickImage(source: ImageSource.camera);
    if(registerSelfieimage != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: registerSelfieimage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 80,
          maxWidth: 300,
          maxHeight: 400,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.blueAccent,
            toolbarTitle: "Adjust Like Passport Photo",
            statusBarColor: Colors.blue,
            backgroundColor: Colors.white,
          )
      );

      registerSelfieimage=cropped;
      // _errorMessage='';
    }

    setState(() {
      _imageFile = registerSelfieimage;
    });

  }

  Widget showUploadPhotoButton(String photoTypeName){
    return Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: RaisedButton(
          color: Colors.orange,
          textColor: Colors.white,
          child:
          photoTypeName=='selfie'?
          Text(
            'Take Selfie',
            textScaleFactor: 1.5,
          ):
          Text(
            'Take eKTP Photo',
            textScaleFactor: 1.5,
          ),
          onPressed: () {
            getImage;
            //_getImage(this.context, ImageSource.camera);
//        setState(() {
//          debugPrint("Photo button clicked");
//
//        });
          },
        )
    );
  }

  Widget showPhotoUploadedInfo() {
    if (_imageFile != null) {
      return new Padding(
          padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
          child: new Center(
              child:
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  Text(
                    'This photo is successfully uploaded',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.green,
                        height: 1.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
          ));
    } else {
      return new Padding(
          padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
          child: new Center(
              child:
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const <Widget>[
                  Icon(
                    Icons.info,
                    color: Colors.lightBlue,
                    size: 20.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  Text(
                    ' Must upload this photo',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.lightBlue,
                        height: 1.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
          ));
    }
  }

  Widget nextButton(){
    return InkWell(
        onTap: goToResultPage,
        child:Container(
          margin: EdgeInsets.only(top: 60),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Text(
            //'Selesai',
            'Next',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body:
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      // colors: [Color(0xfffbb448), Color(0xffe46b10)]
                      colors: [Colors.green, Colors.green[600], Colors.green[700], Colors.green[800]]
                  )
              ),
              child: ListView(
                padding: EdgeInsets.all(8),
                children: <Widget>[
                  Form(
                      key: _formKey,
                      child: Column (
                        children: <Widget>[
                          SizedBox(height: 60),
                          _title(),

                          showUploadEktpButton(),
                          (ktpDetected == 'lagi proses')?Text('Processing.. Please wait a moment..',
                              style: new TextStyle(fontSize: 12.0, color: Colors.white)):Container(),

                          (ktpDetected == 'ktp ada')?Text('eKTP Processed',
                              style: new TextStyle(fontSize: 12.0, color: Colors.white)):Container(),

                          SizedBox(height: 20),
                          (ktpDetected == 'ktp ga ada')?
                          Text('eKTP not found', style: new TextStyle(fontSize: 12.0, color: Colors.red[200])) : Container(),
                          (ktpDetected == 'ktp ga ada')? tryAgainButton() : Container(
                              child: (ktpProcessed)? nextButton() : Container()
                          ),
                          // (ktpDetected == 'ktp ada' && ktpProcessed && _ektpImage != null)?



                          SizedBox(height: 20),
                          // (_ektpImage!=null && _nodefluxResult2Model!=null)?showUploadSelfieButton():Container(),
                          SizedBox(height: 20),
                          (matchLivenessFeedback!="")?
                          Text(matchLivenessFeedback,
                            style: new TextStyle(fontSize: 12.0, color: Colors.white),
                            textAlign: TextAlign.center,
                          ):Container(),
                          SizedBox(height:20),
                          // (similarityValue != null && livenessValue != null && _ektpImage!=null && _nodefluxResult2Model!=null
                          //     && _selfieImage != null && similarityValue >= 0.75 && livenessValue >= 0.75
                          // )?
                          // InkWell(
                          //     onTap: goToResultPage,
                          //     child:Container(
                          //       width: MediaQuery.of(context).size.width,
                          //       padding: EdgeInsets.symmetric(vertical: 15),
                          //       alignment: Alignment.center,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.all(Radius.circular(5)),
                          //         border: Border.all(color: Colors.white, width: 2),
                          //       ),
                          //       child: Text(
                          //         //'Selesai',
                          //         'Next',
                          //         style: TextStyle(fontSize: 20, color: Colors.white),
                          //       ),
                          //     )
                          // )
                          //     :
                          // Container(
                          //     child: (noFace && message == 'No face detected')? tryAgainButton()
                          //         :
                          //     ((nodefluxSelfie)?
                          //     ((underQualified)? tryAgainButton()
                          //         :
                          //     ((similarityValue < 75 && livenessValue < 75)? Column(
                          //       children: [
                          //         Text('Liveness or face match do not pass the requirement',
                          //           style: TextStyle(fontSize: 15.0, color: Colors.red),
                          //           textAlign: TextAlign.center,
                          //         ),
                          //         SizedBox(height: 10),
                          //         tryAgainButton()
                          //       ],
                          //     ):Container())) : Container())
                          // ),
                        ],
                      )
                  ),
                ],
              ),
            )

    );
  }

  Card buildItem(DocumentSnapshot doc) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget> [
                  Text(
                      'name: ${(doc.data() as dynamic)['name']}',
                      style: TextStyle(fontSize: 24)
                  ),
                  Text(
                      'nik: ${(doc.data() as dynamic)['nik']}',
                      style: TextStyle(fontSize: 24)
                  ),
                  Text(
                      'birthdate: ${(doc.data() as dynamic)['birthdate']}',
                      style: TextStyle(fontSize: 24)
                  ),
                  Text(
                      'birthday: ${(doc.data() as dynamic)['birthday']}',
                      style: TextStyle(fontSize: 24)
                  ),
                  Text(
                      'email: ${(doc.data() as dynamic)['email']}',
                      style: TextStyle(fontSize: 24)
                  ),
                  Text(
                      'mobilePhone: ${(doc.data() as dynamic)['mobilePhone']}',
                      style: TextStyle(fontSize: 24)
                  ),
                  SizedBox(height: 12),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: <Widget>[
                  //     FlatButton(
                  //       onPressed: () =>
                  //     )
                  //   ],
                  // )
                ]
            )
        )
    );
  }

  Widget build2(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(height: 50),
                      // _ektpFormWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      SizedBox(height: 20)
                      // Container(
                      //   padding: EdgeInsets.symmetric(vertical: 10),
                      //   alignment: Alignment.centerRight,
                      //   child: Text('Forgot Password ?',
                      //       style: TextStyle(
                      //           fontSize: 14, fontWeight: FontWeight.w500)),
                      // ),
                      //_divider(),
                      //_facebookButton(),
                      //SizedBox(height: height * .055),
                      //_createAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
              // firestore start
              ListView(
                padding: EdgeInsets.all(8),
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: buildTextFormFieldName(),
                  ),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: createData,
                        child: Text('Create', style: TextStyle(color: Colors.black)),
                        color: Colors.green,
                      ),
                      RaisedButton(
                        onPressed: firestoreId != null? readData: null,
                        child: Text('Read', style: TextStyle(color: Colors.black)),
                        color: Colors.blue,
                      )

                    ],
                  ),
                ],
              )
              // firestore end
            ],
          ),
        ));
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await Firebase.initializeApp();
      await db.collection('form').doc('user').update({'name': '$firestoreName', 'nik': '$firestoreNik', 'address': '$firestoreAddress', 'dob': '$firestoreBirthdate', 'pob': '$firestoreBirthplace', 'mobile': '$firestoreMobilePhone', 'email': '$firestoreEmail'});
      //DocumentReference ref = await db.collection('form').add({'name': '$firestoreName', 'nik': '$firestoreNik', 'address': '$firestoreAddress', 'birthdate': '$firestoreBirthdate', 'birthday': '$firestoreBirthday', 'mobilePhone': '$firestoreMobilePhone', 'email': '$firestoreEmail'});
      //setState(() => firestoreId = ref.documentID);
      //print (ref.documentID);
      Navigator.push(
          context,
          MaterialPageRoute(
              //builder: (BuildContext context) => CallSample(host: 'demo.cloudwebrtc.com')));
              builder: (BuildContext context) => WebrtcRoom()));
    }
  }

  void goToResultPage() async {
    if (_formKey.currentState.validate()) {
      //_formKey.currentState.save();
      //await db.collection('form').document('user').updateData({'name': '$firestoreName', 'nik': '$firestoreNik', 'address': '$firestoreAddress', 'dob': '$firestoreBirthdate', 'pob': '$firestoreBirthplace', 'mobile': '$firestoreMobilePhone', 'email': '$firestoreEmail'});

      Navigator.of(context).push(MaterialPageRoute(
        // builder: (context) => NodefluxOcrKtpResult(nodefluxResultModel.result[0])));
          builder: (context) => NodefluxOcrKtpResultPage(model: _nodefluxResult2Model, ektpImage: _ektpImage,)));
    }
  }

  void readData() async {
    await Firebase.initializeApp();
    DocumentSnapshot snapshot = await db.collection('form').doc(firestoreId).get();
    print ((snapshot.data() as dynamic)['name']);
  }

  TextFormField buildTextFormFieldName(){
    return TextFormField (
      controller: nameController,
      decoration: new InputDecoration(
          hintText: 'Nama',
          icon: new Icon(
            Icons.person,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreName = value,
    );
  }

  TextFormField buildTextFormFieldNik(){
    return TextFormField (
      maxLength: 16,
      controller: nikController,
      decoration: new InputDecoration(
          hintText: 'NIK',
          icon: new Icon(
            Icons.credit_card,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreNik = value,
    );
  }

  TextFormField buildTextFormFieldAddress(){
    return TextFormField (
      controller: addressController,
      decoration: new InputDecoration(
          hintText: 'Alamat',
          icon: new Icon(
            Icons.home,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreAddress = value,
    );
  }

  TextFormField buildTextFormFieldBirthdate(){
    return TextFormField (
      controller: birthdateController,
      decoration: new InputDecoration(
          hintText: 'Tanggal Lahir',
          icon: new Icon(
            Icons.calendar_today,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreBirthdate = value,
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
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreBirthplace = value,
    );
  }

  TextFormField buildTextFormFieldGender(){
    return TextFormField (
      controller: genderController,
      maxLength: 16,
      decoration: new InputDecoration(
          hintText: 'Jenis Kelamin',
          icon: new Icon(
            Icons.person,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreGender = value,
    );
  }

  TextFormField buildTextFormFieldRtRw(){
    return TextFormField (
        controller:rtrwController,
        //maxLength: 16,
      decoration: new InputDecoration(
          hintText: 'RT/RW',
          icon: new Icon(
            Icons.map,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreRtRw = value,
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
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreKecamatan = value,
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
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreReligion = value,
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
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreMaritalStatus = value,
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
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreWorkfield = value,
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
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreProvince = value,
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
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreExpiry = value,
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
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreBloodType = value,
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
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreKabupatenKota = value,
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
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreKelurahanDesa = value,
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
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreNationality = value,
    );
  }


  TextFormField buildTextFormFieldEmail(){
    return TextFormField (
        controller:emailController,
        decoration: new InputDecoration(
          hintText: 'Email',
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreEmail = value,
    );
  }

  TextFormField buildTextFormFieldMobilePhone(){
    return TextFormField (
        controller:mobilePhoneController,
        decoration: new InputDecoration(
          hintText: 'Mobile Phone Number (e.g. 08xxxx)',
          icon: new Icon(
            Icons.phone_android,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreMobilePhone = value,
    );
  }

  Future uploadImage(File fileVar, String fileName) async {
    await Firebase.initializeApp();
    Reference _reference = FirebaseStorage.instance.ref().child(fileName+'.jpg');
    UploadTask uploadTask = _reference.putFile(fileVar);
    TaskSnapshot taskSnapshot = await uploadTask; // so when the upload task is complete we can have a snapshot [Maya note]
    setState(() {
      //_uploaded = true;
    });
  }


}
