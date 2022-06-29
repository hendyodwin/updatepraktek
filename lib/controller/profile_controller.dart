import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:dio/dio.dart' as Dio;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/helpers/debug.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  final picker = ImagePicker();

  RxBool isLoading = true.obs;
  RxInt profileId = 0.obs;
  RxBool emailValidated = false.obs;
  String previousEmail = '';
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    getUserInformation();
  }

  void uploadPP() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    File _image;
    if (image != null) {
      var token = await Get.find<AuthController>().getToken();

      _image = File(image.path);
      final img.Image? capturedImage =
          img.decodeImage(await _image.readAsBytes()); //TODO: quest 1
      final img.Image orientedImage =
          img.bakeOrientation(capturedImage!); //TODO: quest 2
      await File(image.path)
          .writeAsBytes(img.encodeJpg(orientedImage)); //TODO: quest 3
      String fileName = _image.path.split('/').last;
      Dio.FormData data = Dio.FormData.fromMap({
        "files": await Dio.MultipartFile.fromFile(
          _image.path,
          filename: fileName,
          contentType: MediaType("image", "jpeg"),
        ),
      });

      Dio.Dio dio = new Dio.Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";
      await dio.post(apiUrl + '/api/upload', data: data).then((response) {
        List jsonResponse = response.data;
        print('======= UPLOAD ======= ${jsonResponse[0]['id']}');
        print(jsonResponse.toString());
        print(jsonResponse[0]['id']);
        saveUserInformation(jsonResponse[0]['id']);
        // imagesUploaded.add(jsonResponse[0]['id']);
      }).catchError((error) => print(error));
    } else {
      print('No image selected.');
    }
  }

  Future<String> getUserInformation() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek = Uri.parse(
        '$apiUrl/api/profiles/?filter[users_permissions_user][0]${Get.find<AuthController>().user_id_db}&populate=*');
    print(' CURRENT DB ID : ${Get.find<AuthController>().user_id_db}');
    var responseCek = await http.get(urlCek, headers: headers);
    if (jsonDecode(responseCek.body)['data'].length > 0) {
      var data = jsonDecode(responseCek.body)['data'][0];
      debugPrint(data.toString());
      debugPrint(data['id'].toString());
      profileId.value = Get.find<AuthController>().profile_id_db.value;
      debugPrint('======= ${profileId.value} =======');
      debugPrint(data['attributes'].toString());
      if (data['attributes']['phone'] != null) {
        phoneController.text = data['attributes']['phone'] ?? '';
      }
      if (data['attributes']['email'] != null) {
        emailController.text = data['attributes']['email'] ?? '-';
        previousEmail = data['attributes']['email'];
      }
      emailValidated.value = data['attributes']['email_verified'] ?? false;
      DebugTools().printWrapped(data.toString());
    }

    isLoading.value = false;
    return 'done';
  }

  void saveUserInformation(picture) async {
    print('====== PIC: ${picture} ======');
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var dataSave = {
      "data": {
        "profile_picture": picture,
      }
    };

    if (profileId.value == 0) {
      print('===== NO PROFILE ID ==== ');
    } else {
      print('=====  PROFILE ID ${profileId.value} ==== ');
      var urlUpdate = Uri.parse('$apiUrl/api/profiles/${profileId.value}');
      var responseUpdate = await http.put(urlUpdate,
          headers: headers, body: jsonEncode(dataSave));
      print(jsonDecode(responseUpdate.body));
      Get.find<AuthController>().updateUserStrapi();
    }
    isLoading.value = false;
  }
}
