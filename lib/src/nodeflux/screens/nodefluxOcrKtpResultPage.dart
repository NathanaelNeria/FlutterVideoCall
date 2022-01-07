import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Widget/bezierContainer.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/nodeflux_data_model.dart';
import '../models/nodeflux_job_model.dart';
import '../models/nodeflux_result_model.dart';
import '../models/nodeflux_result2_model.dart';
import 'dart:convert';
import '../../webrtc_room/webrtc_room.dart';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import '../../../Widget/datetime_picker_widget.dart';
import 'package:intl/date_symbol_data_local.dart';

class NodefluxOcrKtpResultPage extends StatefulWidget {

  final NodefluxResult2Model model;
  File _ektpImage;
  File _selfieImage;

  NodefluxOcrKtpResultPage(this.model, this._ektpImage, this._selfieImage);

  @override
  _NodefluxOcrKtpResultPageState createState() => _NodefluxOcrKtpResultPageState();
}

class _NodefluxOcrKtpResultPageState extends State<NodefluxOcrKtpResultPage> {
  DateTime selectedbirthdate=null;
  File _imageFile;

  // File _ektpImage;
  // File _selfieImage;
  File _npwpImage;
  File _selfieEktpImage;

  bool isEmail = false;

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
  final db = FirebaseFirestore.instance;
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


  TextEditingController scheduledDateTimeController = new TextEditingController(text: 'Anonymous');
  DatetimePickerWidget datetimePickerWidget = DatetimePickerWidget();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
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

    //datetimePickerWidget = DatetimePickerWidget();
    initializeDateFormatting();
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
            color: Color(0xffe46b10),
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


  Widget showUploadSelfieButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.lightBlue,
            child: new Text('Ambil Foto Selfie',
                style: new TextStyle(fontSize: 12.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed: () {
              _getSelfieImage(this.context, ImageSource.camera);
            },
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
//        setState(() {
//          debugPrint("Photo button clicked");
//
//        });
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
          widget._ektpImage = cropped;
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

      int photoQuality=80;
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
            widget._ektpImage = result;
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
    //uploadImage(_ektpImage, "ektp");
    await nodefluxOcrKtpProcess(context);
  }

  nodefluxOcrKtpProcess(BuildContext context) async{
    setState(() {
      //loading = true;
    });
    //String trx_id = 'Liveness_' + DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String authorization = 'NODEFLUX-HMAC-SHA256 Credential=ZZC8MB2EHH01G3FX60ZNZS7KA/20201110/nodeflux.api.v1beta1.ImageAnalytic/StreamImageAnalytic, SignedHeaders=x-nodeflux-timestamp, Signature=5a6b903b95b8f3c9677169d69b13b4f790799ffba897405b7826770f51fd4a21';
    String contentType = 'application/json';
    String xnodefluxtimestamp='20201110T135945Z';
    final imageBytes = widget._ektpImage.readAsBytesSync();
    String base64Image = 'data:image/jpeg;base64,'+base64Encode(imageBytes);
    String dialog = "";
    bool isPassed=false;
    String currentStatus='';
    NodefluxDataModel nodefluxDataModel=NodefluxDataModel();
    NodefluxJobModel nodefluxJobModel=NodefluxJobModel();
    NodefluxResultModel nodefluxResultModel = NodefluxResultModel();
    NodefluxResult2Model nodefluxResult2Model =NodefluxResult2Model();
    bool okValue=true;
    try{
      // var data = "images: ["+ base64Image +"]";

      //var uri = Uri.parse('https://api.cloud.nodeflux.io/v1/analytics/ocr-ktp');
      var url='https://api.cloud.nodeflux.io/v1/analytics/ocr-ktp';
      // var response = http.post(uri, headers: {
      //   "Content-Type": "application/json",
      //   "x-nodeflux-timestamp": "20201110T135945Z",
      //       "Authorization": authorization,
      // }, body:data).then((http.Response response) {});
      List<String> photoBase64List=List<String>();
      photoBase64List.add(base64Image);

      var response;
      while (currentStatus!='success' && okValue) {
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
        } else {
          dialog=nodefluxDataModel.message;
          isPassed=false;
        }
      }

      if (response!=null && currentStatus=="success") {
        nodefluxDataModel=NodefluxDataModel.fromJson(jsonDecode(response.body));
        nodefluxJobModel=nodefluxDataModel.job;
        nodefluxResultModel = nodefluxJobModel.result;
        nodefluxResult2Model = nodefluxResultModel.result[0];
      }

      // decipherin result
      if (nodefluxResultModel.status=="success" && nodefluxDataModel.message=="OCR_KTP Service Success") { // if photo ktp
        // process
        dialog="OCR Process success";
        isPassed=true;
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => NodefluxOcrKtpResult(nodefluxResultModel.result[0]))); MAYA NOTES: dicomment
        //NodefluxResult2Model result2Model=nodefluxResultModel.result[0];
        setState(() {
          //loading = false;
          ocrNik = nodefluxResult2Model.nik;
          ocrNama= nodefluxResult2Model.nama;
          ocrTempatLahir = nodefluxResult2Model.tempat_lahir;
          ocrTanggalLahir = nodefluxResult2Model.tanggal_lahir;
          ocrJenisKelamin = nodefluxResult2Model.jenis_kelamin;
          ocrAlamat = nodefluxResult2Model.alamat;
          ocrRtrw = nodefluxResult2Model.rt_rw;
          ocrKecamatan = nodefluxResult2Model.kecamatan;
          ocrAgama = nodefluxResult2Model.agama;
          ocrStatusPerkawinan = nodefluxResult2Model.status_perkawinan;
          ocrPekerjaan = nodefluxResult2Model.pekerjaan;
          ocrProvinsi = nodefluxResult2Model.provinsi;
          ocrBerlakuHingga = nodefluxResult2Model.berlaku_hingga;
          ocrGolonganDarah = nodefluxResult2Model.golongan_darah;
          ocrKabupatenKota = nodefluxResult2Model.kabupaten_kota;
          ocrKelurahanDesa = nodefluxResult2Model.kelurahan_desa;
          ocrKewarganegaraan= nodefluxResult2Model.kewarganegaraan;
        });

      } else if (nodefluxDataModel.message=="The image might be in wrong orientation") { // if photo not ktp/ wrong orientation
        dialog=nodefluxDataModel.message+" or photo is not KTP";
      }
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
            widget._selfieImage = result;
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
    uploadImage(widget._selfieImage, "selfie");
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
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.lightBlue,
            child: new Text('Ambil Foto eKTP',
                style: new TextStyle(fontSize: 12.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed:  () {
              _getEktpImage(this.context, ImageSource.camera);
            },
          ),
        ));
  }

  Widget showUploadSelfieEktpButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.lightBlue,
            child: new Text(
              //'Foto Selfie bersama eKTP',
                'Take Selfie Photo with eKTP',
                style: new TextStyle(fontSize: 12.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed:  () {
              _getSelfieEktpImage(this.context, ImageSource.camera);
            },
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

  // _getImage(BuildContext context, ImageSource source) async{
  //   this.setState(() {
  //     loading = true;
  //   });
  //   try{
  //     Directory tempDir = await getTemporaryDirectory();
  //     String tempPath = tempDir.path;
  //
  //     if (await tempDir.exists())
  //       tempDir.delete(recursive: false);
  //
  //     Directory appdocdir= await getApplicationSupportDirectory();
  //     String test=appdocdir.path;
  //
  //     if (await appdocdir.exists())
  //       appdocdir.delete(recursive: false);
  //
  //     var picture =  await ImagePicker.pickImage(source: source);
  //
  //     int appFileDirectory=picture.path.lastIndexOf('/');
  //     String resultDirectory=picture.path.substring(0,appFileDirectory+1); // = appdocdir+'/Pictures/'
  //     String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
  //     //String resultPath='/storage/emulated/0/Android/data/com.smartherd.flutter_app_section2/files/Pictures/'+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
  //
  //     int photoQuality=50;
  //     if(picture != null) {
  //       try {
  //         var result = await FlutterImageCompress.compressAndGetFile(
  //           picture.absolute.path, resultPath,
  //           quality: photoQuality,
  //         );
  //
  //         int pictureLength=picture.lengthSync();
  //         int resultLength=result.lengthSync();
  //
  //         var i = 1;
  //
  //         while ((resultLength < professionalMinPhotoSize || resultLength > professionalMaxPhotoSize) && photoQuality>0 && photoQuality<100) {
  //           if (result!=null)
  //             await result.delete();
  //           resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
  //           photoQuality=(resultLength>professionalMaxPhotoSize)? photoQuality-10:photoQuality+10;
  //           result = await FlutterImageCompress.compressAndGetFile(
  //             picture.absolute.path, resultPath,
  //             quality: photoQuality,
  //           );
  //           resultLength=result.lengthSync();
  //         }
  //
  //         double sizeinKb=resultLength.toDouble()/1024;
  //         debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');
  //         //print(pictureLength+resultLength);
  //         await picture.delete();
  //         this.setState(() {
  //           //_imageFileProfile = cropped;
  //           _professionalImage = result;
  //           loading = false;
  //         });
  //       } catch (e) {
  //         print (e);
  //         debugPrint("Error $e");
  //       }
  //     }else{
  //       this.setState(() {
  //         loading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print (e);
  //     debugPrint("Error $e");
  //   }
  //   //Navigator.of(context).pop();
  // }

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                    Row (
                        children: <Widget> [
                          showUploadSelfieEktpButton(),
                        ]
                    ),
                  ],
                )


            ),
            SizedBox(height: 15),
            (_selfieEktpImage != null) ?
            Column (
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Text("I want to have Video Call :"),
                //Text("Please choose below: "),
                RaisedButton(
                  onPressed: createData,
                  child: Text(
                    //'Ok Saya Siap Melakukan Video Call',
                    //'OK, I am ready to have Video Call',
                      'Have Video Call now',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  color: Colors.orange,
                ),
                //SizedBox(height: 10),
                //     Text("- or -"),
                // //SizedBox(height: 10),
                // Text("Please choose date and time when we will contact you:"),
                // DatetimePickerWidget(),
                // RaisedButton(
                //   onPressed: createData, // MAYA: SCHEDULE
                //   child: Text(
                //     //'Ok Saya Siap Melakukan Video Call',
                //     //'OK, I am ready to have Video Call',
                //       'Yes, call me at above time',
                //       style: TextStyle(color: Colors.white, fontSize: 20)),
                //   color: Colors.orange,
                // ),
                //(DateTimePickerWidget!=null)?Text(DateTimePickerWidget.toString()):Container(),
                //Text(scheduledDateTimeController.text),
                //     RaisedButton(
                //       onPressed: () {
                //         showDatePicker(
                //           context:this.context,
                //           initialDate:DateTime.now(),
                //           firstDate: DateTime.now(),
                //           lastDate: DateTime(DateTime.now().month+1),
                //           //lastDate:DateTime.now(),
                //         ).then((selectedDate){
                //           //selectedcertificatedate=selectedDate;
                //           scheduledDateTimeController.text= DateFormat('dd-MM-yyyy').format(selectedDate).toString();
                //           //new DateFormat.yMMMd().format(selectedDate);
                //
                //         });
                //
                //       },
                //       //onPressed:
                //       // DateTimePicker(
                //       //   type: DateTimePickerType.dateTime,
                //       //   dateMask: 'd MMMM yyyy - hh:mm',
                //       //   controller: _scheduledDateTimeController,
                //       //   //initialValue: _initialValue,
                //       //   firstDate: DateTime(2000),
                //       //   lastDate: DateTime(2100),
                //       //   //icon: Icon(Icons.event),
                //       //   dateLabelText: 'Date Time',
                //       //   use24HourFormat: false,
                //       //   locale: Locale('en', 'US'),
                //       //   onChanged: (val) => setState(() => _scheduledDateTimeValueChanged = val),
                //       //   validator: (val) {
                //       //     setState(() => _scheduledDateTimeValueToValidate = val ?? '');
                //       //     return null;
                //       //   },
                //       //   onSaved: (val) => setState(() => _scheduledDateTimeValueSaved = val ?? ''),
                //       // )
                //       child: Text(
                //           'Call me at my chosen date and time',
                //           style: TextStyle(color: Colors.white, fontSize: 20)),
                //       color: Colors.orange,
                //     ),
              ],
            ) : Container()
          ],
        )
      // firestore end
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => WebrtcRoom()));
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('form').doc(firestoreId).get();
    print ((snapshot.data as dynamic)['name']);
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input nama';
        }
        return null;
      },
      onSaved: (value) => firestoreName = value,
    );
  }

  TextFormField buildTextFormFieldNik(){
    return TextFormField (
      maxLength: 16,
      controller: nikController,
      keyboardType: TextInputType.number,
      decoration: new InputDecoration(
          hintText: 'NIK',
          icon: new Icon(
            Icons.credit_card,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value.isEmpty || value.length < 16) {
          return 'Please input NIK';
        }
        return null;
      },
      onSaved: (value) => firestoreNik = value,
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
        if (value.isEmpty) {
          return 'Please input alamat';
        }
        return null;
      },
      onSaved: (value) => firestoreAddress = value,
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
        if (value.isEmpty) {
          return 'Please input tanggal lahir';
        }
        return null;
      },
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input tempat lahir';
        }
        return null;
      },
      onSaved: (value) => firestoreBirthplace = value,
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
        if (value.isEmpty) {
          return 'Please input gender';
        }
        return null;
      },
      onSaved: (value) => firestoreGender = value,
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
        if (value.isEmpty) {
          return 'Please input RT/RW';
        }
        return null;
      },
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input Kecamatan';
        }
        return null;
      },
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input agama';
        }
        return null;
      },
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input status perkawinan';
        }
        return null;
      },
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input pekerjaan';
        }
        return null;
      },
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input provinsi';
        }
        return null;
      },
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input tanggal berlaku';
        }
        return null;
      },
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please gol. darah';
        }
        return null;
      },
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input kabupaten/kota';
        }
        return null;
      },
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input kelurahan/desa';
        }
        return null;
      },
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input kewarganegaraan';
        }
        return null;
      },
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
      validator: (value){
        isEmail = EmailValidator.validate(value);

        if (value.isEmpty || !isEmail) {
          return 'Please input a valid email address';
        }
        return null;
      },
      onSaved: (value) => firestoreEmail = value,
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
        if (value.isEmpty && value.length < 11 && value.length > 12) {
          return 'Input a proper phone number';
        }
        return null;
      },
      onSaved: (value) => firestoreMobilePhone = value,
    );
  }

  Future uploadImage(File fileVar, String fileName) async {
    Reference _reference = FirebaseStorage.instance.ref().child(fileName+'.jpg');
    UploadTask uploadTask = _reference.putFile(fileVar);
    TaskSnapshot taskSnapshot = await uploadTask; // so when the upload task is complete we can have a snapshot [Maya note]
    setState(() {
      //_uploaded = true;
    });
  }


}
