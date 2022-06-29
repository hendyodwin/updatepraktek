import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/helpers/debug.dart';
import 'package:praktek_app/root.dart';
import 'package:http/http.dart' as http;

class EditProfileContactController extends GetxController {
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

  void getUserInformation() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek = Uri.parse(
        '$apiUrl/api/profiles?filters[users_permissions_user][id][\$eq]=${Get.find<AuthController>().user_id_db}&populate=*');

    var responseCek = await http.get(urlCek, headers: headers);
    if (jsonDecode(responseCek.body)['data'].length > 0) {
      var data = jsonDecode(responseCek.body)['data'][0];
      profileId.value = data['id'];
      debugPrint('======= ${profileId.value} =======');
      phoneController.text = data['attributes']['phone'] ?? '';
      emailController.text = data['attributes']['email'] ?? '';
      previousEmail = data['attributes']['email'] ?? '';
      emailValidated.value = data['attributes']['email_verified'] ?? false;
      DebugTools().printWrapped(data.toString());
    }

    isLoading.value = false;
  }

  void saveUserInformation() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var dataSave = {
      "data": {
        "email": emailController.text,
        "email_verified": previousEmail == emailController.text ? null : false,
      }
    };

    if (profileId.value == 0) {
    } else {
      var urlUpdate = Uri.parse('$apiUrl/api/profiles/${profileId.value}');
      var responseUpdate = await http.put(urlUpdate,
          headers: headers, body: jsonEncode(dataSave));
      print(jsonDecode(responseUpdate.body));
    }
    isLoading.value = false;
    Get.find<AuthController>().updateUserStrapi();
    Get.offAll(Root());
  }
}
