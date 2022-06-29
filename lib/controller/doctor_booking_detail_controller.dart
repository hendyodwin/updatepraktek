import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/analytics.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:praktek_app/controller/main_controller.dart';
import 'package:praktek_app/helpers/debug.dart';
import 'package:praktek_app/root.dart';
import 'package:praktek_app/screens/doctor_booking_payment_confirmation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:image/image.dart' as img;

class DoctorBookingDetailController extends GetxController {
  var uuid = Uuid();

  RxInt doctorId = 0.obs;
  RxInt lastOrderId = 0.obs;
  RxInt slotId = 0.obs;
  RxDouble currentRate = 0.0.obs;
  RxString selectedDate = ''.obs;
  RxString selectedTime = ''.obs;
  RxString bookingType = ''.obs;
  RxString paymentOptionSelected = ''.obs;
  final video = Rxn<XFile>();
  final image1 = Rxn<XFile>();
  final image2 = Rxn<XFile>();
  final image3 = Rxn<XFile>();
  final image4 = Rxn<XFile>();
  final FocusScopeNode node = FocusScopeNode();
  TextEditingController editTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late VideoPlayerController controllerVideo;
  RxBool videoReady = false.obs;

  RxMap doctor = {}.obs;
  RxMap slot = {}.obs;
  RxBool isLoading = false.obs;
  late final Mixpanel _mixpanel;

  @override
  void onInit() {
    super.onInit();
    _initMixpanel();

    ever(doctorId, (value) {
      print('DoctorId = $doctorId');
      getDoctor(doctorId);
    });
    ever(slotId, (value) {
      print('slotId = $slotId');
      getSlot(slotId);
    });
  }

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }

  void getDoctor(id) async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek = Uri.parse('$apiUrl/api/doctors/$id?populate=*');

    var responseCek = await http.get(urlCek, headers: headers);

    var data = jsonDecode(responseCek.body)['data'];
    doctor.value = data;
    isLoading.value = false;
  }

  void getSlot(id) async {
    debugPrint('==== Get Slot Info ====');
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek = Uri.parse('$apiUrl/api/doctor-availabilities/$id');

    var responseCek = await http.get(urlCek, headers: headers);

    var data = jsonDecode(responseCek.body)['data'];
    slot.value = data;
    var utc = DateTime.parse(data['attributes']['start']);
    selectedDate.value = DateFormat('dd/MM/yyyy').format(utc.toLocal());
    selectedTime.value = DateFormat('hh:mm a').format(utc.toLocal());
    DebugTools().printWrapped(data.toString());
    isLoading.value = false;
  }

  void getPaymentDetails() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek =
        Uri.parse('$apiUrl/api/appointments/${lastOrderId.value}?populate=*');
    var responseCek = await http.get(urlCek, headers: headers);

    var data = jsonDecode(responseCek.body)['data'];

    DebugTools().printWrapped(data.toString());
    isLoading.value = false;
  }

  void placeOrder() async {
    isLoading.value = true;
    int videoId = 0;
    String videoUrl = '';
    List imagesUploaded = [];
    _mixpanel.timeEvent("Push Order");
    var token = await Get.find<AuthController>().getToken();
    if (video.value != null) {
      File file = File(video.value!.path);
      String fileName = file.path.split('/').last;
      print(fileName);
      print(file.path);

      Dio.FormData data = Dio.FormData.fromMap({
        "files": await Dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: new MediaType("video", "mp4"),
        ),
      });

      Dio.Dio dio = new Dio.Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";
      await dio.post(apiUrl + '/api/upload', data: data).then((response) {
        List jsonResponse = response.data;
        print('======= UPLOAD =======');
        print(jsonResponse.toString());
        videoId = jsonResponse[0]['id'];
        videoUrl = jsonResponse[0]['url'];
      }).catchError((error) => print(error));
    }

    if (image1.value != null) {
      File file = File(image1.value!.path);
      String fileName = file.path.split('/').last;
      print(fileName);
      print(file.path);
      final img.Image? capturedImage =
          img.decodeImage(await file.readAsBytes());
      final img.Image orientedImage = img.bakeOrientation(capturedImage!);
      await File(file.path).writeAsBytes(img.encodeJpg(orientedImage));
      Dio.FormData data = Dio.FormData.fromMap({
        "files": await Dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: new MediaType("image", "jpeg"),
        ),
      });

      Dio.Dio dio = new Dio.Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";
      await dio.post(apiUrl + '/api/upload', data: data).then((response) {
        List jsonResponse = response.data;
        print('======= UPLOAD =======');
        print(jsonResponse.toString());
        imagesUploaded.add(jsonResponse[0]['id']);
      }).catchError((error) => print(error));
    }
    if (image2.value != null) {
      File file = File(image2.value!.path);
      String fileName = file.path.split('/').last;
      print(fileName);
      print(file.path);
      final img.Image? capturedImage =
          img.decodeImage(await file.readAsBytes());
      final img.Image orientedImage = img.bakeOrientation(capturedImage!);
      await File(file.path).writeAsBytes(img.encodeJpg(orientedImage));
      Dio.FormData data = Dio.FormData.fromMap({
        "files": await Dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: new MediaType("image", "jpeg"),
        ),
      });

      Dio.Dio dio = new Dio.Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";
      await dio.post(apiUrl + '/api/upload', data: data).then((response) {
        List jsonResponse = response.data;
        print('======= UPLOAD =======');
        print(jsonResponse.toString());
        imagesUploaded.add(jsonResponse[0]['id']);
      }).catchError((error) => print(error));
    }

    var uniqueRoom = uuid.v4().toString();

    Map dataOrder = {};
    if (bookingType.value == 'chat') {
      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(uniqueRoom)
          .collection("chat")
          .add({
        'content': videoUrl,
        'sender': Get.find<AuthController>().user_id_db.value,
        'type': 'video',
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });
      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(uniqueRoom)
          .collection("chat")
          .add({
        'content': editTextController.text,
        'sender': Get.find<AuthController>().user_id_db.value,
        'active': true,
        'type': 'txt',
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });
      dataOrder = {
        "data": {
          "amount": doctor['attributes']['rate_chat'],
          "paid": false,
          "room_id": uniqueRoom,
          "video": videoId.toString(),
          "profile": Get.find<AuthController>().profile_id_db.value,
          "doctor": doctorId.value,
          "users_permissions_user": Get.find<AuthController>().user_id_db.value,
          "type": "chat",
          "patient_notes": editTextController.text,
          "appointment_doctor_id": doctorId.value.toString(),
          "appointment_patient_id":
              Get.find<AuthController>().user_id_db.value.toString(),
        }
      };
    }

    if (bookingType.value == 'video') {
      dataOrder = {
        "data": {
          "amount": slot['attributes']['price'],
          "paid": false,
          "doctor_availability": slot['id'],
          "room_id": uniqueRoom,
          "images": imagesUploaded,
          "doctor": doctorId.value,
          "profile": Get.find<AuthController>().profile_id_db.value,
          "users_permissions_user": Get.find<AuthController>().user_id_db.value,
          "type": "video",
          "patient_notes": editTextController.text,
          "appointment_doctor_id": doctorId.value.toString(),
          "appointment_patient_id":
              Get.find<AuthController>().user_id_db.value.toString(),
        }
      };
    }
    // "images": ["string or id", "string or id"],
    // "video": "string or id",
    debugPrint(dataOrder.toString());
    if (bookingType.value == 'video') {
      DocumentReference ref =
          FirebaseFirestore.instance.collection('video').doc(uniqueRoom);

      var userUpdate = {
        'doctor': doctorId.value,
        'patient': Get.find<AuthController>().user_id_db.value,
        'doctor_joined': false,
        'patient_joined': false,
        'room_id': uniqueRoom,
        'active': true
      };

      await ref.set(userUpdate, SetOptions(merge: true));
    } else {
      DocumentReference ref =
          FirebaseFirestore.instance.collection('chatroom').doc(uniqueRoom);

      var userUpdate = {
        'doctor': doctorId.value,
        'patient': Get.find<AuthController>().user_id_db.value,
        'room_id': uniqueRoom,
        'active': true
      };

      await ref.set(userUpdate, SetOptions(merge: true));
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek = Uri.parse('$apiUrl/api/appointments');

    try {
      var responseCek = await http.post(urlCek,
          body: jsonEncode(dataOrder), headers: headers);

      var data = jsonDecode(responseCek.body)['data'];

      DebugTools().printWrapped(data.toString());
      var orderId = data['id'];
      lastOrderId.value = orderId;
      var orderAmount = data['attributes']['amount'];
      Get.find<MainController>()
          .trackPaymentMixPanel(paymentOptionSelected.value);
      if (paymentOptionSelected.value == 'gopay') {
        debugPrint('----------- GOPAY -----------');
        var dataPackageQris = {
          "payment_type": "gopay",
          "gross_amount": orderAmount,
          "order_id": orderId.toString()
        };

        var urlPostGopay = Uri.parse('${apiMidtrans}/midtrans');
        var responsePostGoPay = await http.post(urlPostGopay,
            headers: headers, body: jsonEncode(dataPackageQris));
        final goPayDetail = jsonDecode(responsePostGoPay.body);

        debugPrint(goPayDetail.toString());
        debugPrint(goPayDetail['actions'][1]['url']);
        await launch(goPayDetail['actions'][1]['url']);
        Get.offAll(Root());
      }
      if (paymentOptionSelected.value == 'shopeepay') {
        debugPrint('----------- shopeepay -----------');
        var dataPackageQris = {
          "payment_type": "shopeepay",
          "gross_amount": orderAmount,
          "order_id": orderId.toString()
        };

        var urlPostGopay = Uri.parse('${apiMidtrans}/midtrans');
        var responsePostGoPay = await http.post(urlPostGopay,
            headers: headers, body: jsonEncode(dataPackageQris));
        final goPayDetail = jsonDecode(responsePostGoPay.body);

        debugPrint(goPayDetail.toString());
        debugPrint(goPayDetail['actions'][0]['url']);
        await launch(goPayDetail['actions'][0]['url']);
        Get.offAll(Root());
      }
      if (paymentOptionSelected.value == 'bca' ||
          paymentOptionSelected.value == 'bni' ||
          paymentOptionSelected.value == 'bri') {
        debugPrint('----------- ${paymentOptionSelected.value} -----------');
        var dataPackageQris = {
          "payment_type": "bank_transfer",
          "gross_amount": orderAmount,
          "order_id": orderId.toString(),
          "bank": paymentOptionSelected.value
        };

        var urlPostGopay = Uri.parse('${apiMidtrans}/midtrans');
        var responsePostGoPay = await http.post(urlPostGopay,
            headers: headers, body: jsonEncode(dataPackageQris));
        final goPayDetail = jsonDecode(responsePostGoPay.body);

        debugPrint(goPayDetail.toString());
      }
      if (paymentOptionSelected.value == 'echannel') {
        debugPrint('----------- Mandiri -----------');
        var dataPackageQris = {
          "payment_type": "echannel",
          "gross_amount": orderAmount,
          "order_id": orderId.toString(),
        };

        var urlPostGopay = Uri.parse('${apiMidtrans}/midtrans');
        var responsePostGoPay = await http.post(urlPostGopay,
            headers: headers, body: jsonEncode(dataPackageQris));
        final goPayDetail = jsonDecode(responsePostGoPay.body);

        debugPrint(goPayDetail.toString());
      }

      if (paymentOptionSelected.value == 'permata' ||
          paymentOptionSelected.value == 'other') {
        debugPrint('----------- permata -----------');
        var dataPackageQris = {
          "payment_type": "permata",
          "gross_amount": orderAmount,
          "order_id": orderId.toString(),
        };

        var urlPostGopay = Uri.parse('${apiMidtrans}/midtrans');
        var responsePostGoPay = await http.post(urlPostGopay,
            headers: headers, body: jsonEncode(dataPackageQris));
        final goPayDetail = jsonDecode(responsePostGoPay.body);

        debugPrint(goPayDetail.toString());
      }
      Get.find<AuthController>().getMyOrders();
      if (paymentOptionSelected.value != 'shopeepay' &&
          paymentOptionSelected.value != 'gopay') {
        Get.to(() => DoctorBookingPaymentConfirmation());
      }

      // var dataPackageQris = {
      //   "payment_type": "gopay",
      //   "gross_amount": orderAmount,
      //   "order_id": orderId,
      //   "item_details": [
      //     {
      //       "id": "1",
      //       "price": orderAmount,
      //       "quantity": 1,
      //       "name":
      //       "Chat consult with ${doctor['attributes']['full_name']}"
      //     }
      //   ],
      //   "customer_details": {
      //     "first_name": Get.find<AuthController>().profileName.value,
      //     "last_name": "",
      //     "email": Get.find<AuthController>().profileEmail.value,
      //     "phone": Get.find<AuthController>().profilePhone.value
      //   }
      // };

    } on Exception catch (e) {
      isLoading.value = false;
    }
    _mixpanel.track("Push Order");
    isLoading.value = false;
  }
}
