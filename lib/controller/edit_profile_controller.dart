import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/helpers/debug.dart';
import 'package:praktek_app/root.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class EditProfileController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isMale = false.obs;
  RxString orderId = ''.obs;
  RxInt profileId = 0.obs;
  RxString dateToSave = ''.obs;

  final formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController PoBController = TextEditingController();
  TextEditingController KTPNumberController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  TextEditingController dateBirthday = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

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
      fullNameController.text = data['attributes']['name'] ?? '';
      PoBController.text = data['attributes']['place_of_birth'] ?? '';
      print(data['attributes']['Gender']);
      if (data['attributes']['Gender'] == 'male') {
        isMale.value = true;
      } else {
        isMale.value = false;
      }
      KTPNumberController.text = data['attributes']['ktp_number'] ?? '';
      AddressController.text = data['attributes']['address'] ?? '';
      dateBirthday.text = data['attributes']['birthday'] ?? '';
      dateToSave.value = data['attributes']['birthday'];
      weightController.text = data['attributes']['weight'].toString();
      heightController.text = data['attributes']['height'].toString();
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

    print(weightController.text.length);
    var dataSave = {
      "data": {
        "name": fullNameController.text,
        "users_permissions_user": Get.find<AuthController>().user_id_db.value,
        "place_of_birth": PoBController.text,
        "ktp_number": KTPNumberController.text,
        "address": AddressController.text,
        "birthday": dateToSave.value,
        "Gender": isMale.value ? "male" : "female",
        "weight": weightController.text.isEmpty
            ? 0
            : int.parse(weightController.text),
        "height": heightController.text.isEmpty
            ? 0
            : int.parse(heightController.text),
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
