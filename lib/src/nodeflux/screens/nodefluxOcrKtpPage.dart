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
  NodefluxOcrKtpPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _NodefluxOcrKtpPageState createState() => _NodefluxOcrKtpPageState();
}

class _NodefluxOcrKtpPageState extends State<NodefluxOcrKtpPage> {
  DateTime? selectedbirthdate;
  File? _imageFile;

  File? _ektpImage;
  File? _selfieImage;
  File? _npwpImage;
  File? _selfieEktpImage;

  final _formKey = GlobalKey<FormState>();

  TextEditingController nikController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController birthplaceController = TextEditingController();
  TextEditingController mobilePhoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController? addressController, genderController, rtrwController, kecamatanController, religionController, maritalStatusController, workfieldController, provinceController, expiryController,
    bloodTypeController, kabupatenKotaController, kelurahanDesaController, nationalityController;

  //firestore
   String? firestoreId;
   FirebaseFirestore? db;
   String? firestoreName;
   String? firestoreNik;
   String? firestoreAddress;
   String? firestoreBirthdate;
   String? firestoreBirthplace;
   String? firestoreGender;
   String? firestoreRtRw;
   String? firestoreKecamatan;
   String? firestoreReligion;
   String? firestoreMaritalStatus;
   String? firestoreWorkfield;
   String? firestoreProvince;
   String? firestoreExpiry;
   String? firestoreBloodType;
   String? firestoreKabupatenKota;
   String? firestoreKelurahanDesa;
   String? firestoreNationality;
   String? firestoreMobilePhone;
   String? firestoreEmail;
  final ImagePicker _picker = ImagePicker();

  int minPhotoSize=256000; // 250KB
  int maxPhotoSize=512000; // 500KB

  String? ocrNama, ocrNik, ocrTempatLahir, ocrTanggalLahir, ocrJenisKelamin, ocrAlamat, ocrRtrw, ocrKecamatan, ocrAgama, ocrStatusPerkawinan,
      ocrPekerjaan, ocrProvinsi, ocrBerlakuHingga, ocrGolonganDarah, ocrKabupatenKota, ocrKelurahanDesa, ocrKewarganegaraan;

  //NodefluxResult2Model nodefluxResult2Model =NodefluxResult2Model();
   NodefluxResult2Model? _nodefluxResult2Model;
  bool? isLive;
  bool? isMatched;
  bool nodefluxSelfie = false;
  double? livenessValue;
  double? similarityValue;
  String matchLivenessFeedback="";
  String message = '';
  bool noFace = false;
  bool underQualified = false;
  bool changeColor = false;
  String ktpDetected = '';
  bool ktpProcessed = false;
  DateTime currTime = DateTime.now();

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
          ]),
    );
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

      XFile? xFilepicture = await _picker.pickImage(source: source);
      File? picture = File(xFilepicture!.path);


      int appFileDirectory=picture.path.lastIndexOf('/');
      String resultDirectory=picture.path.substring(0,appFileDirectory+1); // = appdocdir+'/Pictures/'
      String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
      //String resultPath='/storage/emulated/0/Android/data/com.smartherd.flutter_app_section2/files/Pictures/'+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';

      int photoQuality=90;


      if(picture != null) {
        try {
          File? result = await FlutterImageCompress.compressAndGetFile(
            picture.path, resultPath,
            quality: photoQuality,
          );

          int resultLength= result!.lengthSync();

          var i = 1;

          while ((resultLength < minPhotoSize || resultLength > maxPhotoSize) && photoQuality>0 && photoQuality<100) {
            if (result!=null)
              await result.delete();
            resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
            photoQuality=(resultLength>maxPhotoSize)? photoQuality-10:photoQuality+10;
            result = await FlutterImageCompress.compressAndGetFile(
              picture.path, resultPath,
              quality: photoQuality,
            );
            resultLength=result!.lengthSync();
          }

          //comment end

          double sizeinKb=resultLength.toDouble()/1024;
          debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');
          //print(pictureLength+resultLength);
          await picture.delete();
          this.setState(() {
            //_imageFileProfile = cropped;
            _ektpImage = result!;
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
    await uploadImage(_ektpImage!, "ektp");
  }

  nodefluxOcrKtpProcess(BuildContext context) async{
    setState(() {
      //loading = true;
    });
    //String trx_id = 'Liveness_' + DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String authorization = 'NODEFLUX-HMAC-SHA256 Credential=50WNYKJBV3E4QN0BXIMJUVMKN/20220125/nodeflux.api.v1beta1.ImageAnalytic/StreamImageAnalytic, SignedHeaders=x-nodeflux-timestamp, Signature=04db27a8b1c11e5e5feff31490b73b568d7b8400475b1a48248a03f029ccd33c';
    String contentType = 'application/json';
    String xnodefluxtimestamp='20201110T135945Z';
    final imageBytes = _ektpImage?.readAsBytesSync();
    String base64Image = 'data:image/jpeg;base64,'+base64Encode(imageBytes!);
    String? dialog = "";
    bool isPassed=false;
    String currentStatus="";
    NodefluxDataModel nodefluxDataModel=NodefluxDataModel();
    NodefluxJobModel nodefluxJobModel=NodefluxJobModel();
    NodefluxResultModel nodefluxResultModel = NodefluxResultModel();
    // NodefluxResult2Model nodefluxResult2Model =NodefluxResult2Model();
    bool okValue=true;
    try{

      var url='https://api.cloud.nodeflux.io/v1/analytics/ocr-ktp';
      List<String> photoBase64List = <String>[];
      photoBase64List.add(base64Image);

      var response;
      while (currentStatus=="on going" || currentStatus=="") {
        response = await http
            .post(Uri.parse(url), body: json.encode({
          "images":photoBase64List
        }), headers: {"Accept": "application/json",  "Content-Type": "application/json",
          "x-nodeflux-timestamp": "20220125T093502Z",
          "Authorization": authorization,});

        print(response.body);

        var respbody=response.body;
        nodefluxDataModel=NodefluxDataModel.fromJson00(jsonDecode(response.body));
        okValue=nodefluxDataModel.ok!;
        if (okValue) {
          nodefluxDataModel=NodefluxDataModel.fromJson0(jsonDecode(response.body));
          nodefluxJobModel=nodefluxDataModel.job!;
          nodefluxResultModel = nodefluxJobModel.result!;

          currentStatus=nodefluxResultModel.status!;
          message = nodefluxDataModel.message!;
        } else {
          dialog=nodefluxDataModel.message!;
          isPassed=false;
        }
      }

      if (response!=null && currentStatus=="success") {
        nodefluxDataModel=NodefluxDataModel.fromJson(jsonDecode(response.body));
        nodefluxJobModel=nodefluxDataModel.job!;
        nodefluxResultModel = nodefluxJobModel.result!;
        _nodefluxResult2Model = nodefluxResultModel.result![0];
      }

      // decipherin result
      if(nodefluxResultModel.status != 'on going' && nodefluxDataModel.message != 'Job successfully submitted'){
        if (nodefluxResultModel.status=="success" && nodefluxDataModel.message=="OCR_KTP Service Success") { // if photo ktp
          dialog="OCR Process success";
          isPassed=true;
          setState(() {
            ocrNik = _nodefluxResult2Model!.nik;
            ocrNama= _nodefluxResult2Model!.nama;
            ocrTempatLahir = _nodefluxResult2Model!.tempat_lahir;
            ocrTanggalLahir = _nodefluxResult2Model!.tanggal_lahir;
            ocrJenisKelamin = _nodefluxResult2Model!.jenis_kelamin;
            ocrAlamat = _nodefluxResult2Model!.alamat;
            ocrRtrw = _nodefluxResult2Model!.rt_rw;
            ocrKecamatan = _nodefluxResult2Model!.kecamatan;
            ocrAgama = _nodefluxResult2Model!.agama;
            ocrStatusPerkawinan = _nodefluxResult2Model!.status_perkawinan;
            ocrPekerjaan = _nodefluxResult2Model!.pekerjaan;
            ocrProvinsi = _nodefluxResult2Model!.provinsi;
            ocrBerlakuHingga = _nodefluxResult2Model!.berlaku_hingga;
            ocrGolonganDarah = _nodefluxResult2Model!.golongan_darah;
            ocrKabupatenKota = _nodefluxResult2Model!.kabupaten_kota;
            ocrKelurahanDesa = _nodefluxResult2Model!.kelurahan_desa;
            ocrKewarganegaraan= _nodefluxResult2Model!.kewarganegaraan;
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
      dialog=e.toString();
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
                      colors: [Colors.green, Colors.green.shade700, Colors.green.shade900]
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

  void goToResultPage() async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NodefluxOcrKtpResultPage(model: _nodefluxResult2Model!, ektpImage: _ektpImage!)));
    }
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
