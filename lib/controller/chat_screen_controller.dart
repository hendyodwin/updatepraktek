import 'dart:convert';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/helpers/debug.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class ChatScreenController extends GetxController {
  final picker = ImagePicker();
  TextEditingController textField = TextEditingController();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  late VideoPlayerController controllerVideo;
  RxBool videoPlaying = false.obs;
  RxString orderId = '0'.obs;
  RxString chatWithName = ''.obs;
  RxString chatWithStatus = 'offline'.obs;
  RxString chatWithPP = ''.obs;
  RxInt doctorID = 0.obs;
  RxMap chatInfo = {}.obs;
  RxBool isLoading = true.obs;
  RxBool videoIsLoading = true.obs;
RxBool isDoctorScreen = false.obs;
  RxString patientToken = ''.obs;
  RxString doctorToken = ''.obs;
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void onInit() async {
    super.onInit();

    ever(orderId, (value) {
      print('ORDER =>  $orderId');
      getRoomDetail();
    });
  }

  void toggleVideoPlay() async {
    videoPlaying.value = !videoPlaying.value;
    if (videoPlaying.value) {
      controllerVideo.play();
    } else {
      controllerVideo.pause();
    }
  }

  void getRoomDetail() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek = Uri.parse(
        '$apiUrl/api/appointments/${orderId.value}?populate[0]=*&populate[1]=doctor.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability&populate[4]=video&populate[5]=profile&populate[6]=profile.profile_picture');
    var responseCek = await http.get(urlCek, headers: headers);
    print('$apiUrl/api/appointments/${orderId.value}?populate=*');
    print(responseCek.toString());
    var data = jsonDecode(responseCek.body)['data'];
    DebugTools().printWrapped(data.toString());
    print('DOCTOR ID => ${data['attributes']['appointment_doctor_id']}');
    print('PATIENT ID => ${data['attributes']['appointment_patient_id']}');
    doctorID.value = int.parse(data['attributes']['appointment_doctor_id']);
    patientToken.value =
        data['attributes']['profile']['data']['attributes']['fcmToken'] ?? '';
    doctorToken.value =
        data['attributes']['doctor']['data']['attributes']['fcmToken'] ?? '';
    chatInfo.value = data;
    if (isDoctorScreen.value == false) {
      chatWithName.value = data['attributes']['doctor']['data']['attributes']
              ['full_name'] ??
          '-';
      chatWithStatus.value = 'offline';
      chatWithPP.value = data['attributes']['doctor']['data']['attributes']
                      ['profile_picture']['data']['attributes']['formats']
                  ['medium'] ==
              null
          ? data['attributes']['doctor']['data']['attributes']
                  ['profile_picture']['data']['attributes']['formats']
              ['thumbnail']['url']
          : data['attributes']['doctor']['data']['attributes']
                  ['profile_picture']['data']['attributes']['formats']['medium']
              ['url'];
    } else {
      chatWithName.value = data['attributes']['profile']['data']['attributes']
      ['name'] ??
          '-';
      chatWithStatus.value = 'offline';
      chatWithPP.value = data['attributes']['profile']['data']['attributes']
      ['profile_picture']['data']['attributes']['formats']
      ['medium'] ==
          null
          ? data['attributes']['profile']['data']['attributes']
      ['profile_picture']['data']['attributes']['formats']
      ['thumbnail']['url']
          : data['attributes']['profile']['data']['attributes']
      ['profile_picture']['data']['attributes']['formats']['medium']
      ['url'];
    }
    var urlCekDoctor =
        Uri.parse('$apiUrl/api/doctors/${doctorID.value}?populate=*');
    var responseCekDoctor = await http.get(urlCekDoctor, headers: headers);
    var dataDoctor = jsonDecode(responseCekDoctor.body)['data'];
    print('------ Doctor -------');
    DebugTools().printWrapped(dataDoctor.toString());
    isLoading.value = false;
    if (data['attributes']['video'] != null) {
      controllerVideo = VideoPlayerController.network(
          data['attributes']['video']['data']['attributes']['url'])
        ..initialize().then((_) {
          videoIsLoading.value = false;
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          print('Video Loaded');
        });
    } else {
      controllerVideo = VideoPlayerController.network(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
        ..initialize().then((_) {
          videoIsLoading.value = false;
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          print('Video Loaded');
        });
    }
  }

  void uploadImage(roomId) async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    File _image;

    if (image != null) {
      _image = File(image.path);
      String fileName = _image.path.split('/').last;

      try {

        firebase_storage.UploadTask uploadTask = firebase_storage
            .FirebaseStorage.instance
            .ref('uploads/${fileName}')
            .putFile(_image);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref('uploads/${fileName}')
            .getDownloadURL();

        print("HELLO");
        print(downloadURL);
        if (downloadURL.length > 0) {
          await _db.collection('chatroom').doc(roomId).collection("chat").add({
            'content': downloadURL,
            'sender': Get.find<AuthController>().user_id_db.value,
            'type': 'image',
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          });
        }
      } on firebase_core.FirebaseException catch (e) {
        print(e.toString());
        // e.g, e.code == 'canceled'
      }
    } else {
      print('No image selected.');
    }
  }

  void sendMessage(roomId, type) async {
    if (textField.text.length > 0) {
      print('---- ${textField.text} ------');

      try {
        print({
          'content': textField.text,
          'sender': Get.find<AuthController>().user_id_db.value,
          'type': 'txt',
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        });
        await _db.collection('chatroom').doc(roomId).collection("chat").add({
          'content': textField.text,
          'sender': Get.find<AuthController>().user_id_db.value,
          'type': 'txt',
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        });
      } on Exception catch (e) {
        print("send exception");
        print(e);
      }

      try{
        if (type == 'patient') {
          if (doctorToken.value != '') {
            HttpsCallable callable =
            FirebaseFunctions.instanceFor(region: 'asia-southeast2')
                .httpsCallable('sendMessage');
            final resp = await callable.call(<String, dynamic>{
              'title': 'Message from ${Get.find<AuthController>().profileName.value}',
              'content': textField.text,
              'type': 'chat',
              'token': doctorToken.value,
            });
            print("result: ${resp.data}");
          }
        } else {
          if (patientToken.value != '') {
            HttpsCallable callable =
            FirebaseFunctions.instanceFor(region: 'asia-southeast2')
                .httpsCallable('sendMessage');
            final resp = await callable.call(<String, dynamic>{
              'title': 'Message from ${Get.find<AuthController>().profileName.value}',
              'content': textField.text,
              'type': 'chat',
              'token': patientToken.value,
            });
            print("result: ${resp.data}");
          }
        }
      }on Exception catch (e) {
        print("send FirebaseFunctions exception");
        print(e);
      }

      textField.text = "";
    }
  }
}
