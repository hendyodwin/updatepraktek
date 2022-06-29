import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:praktek_app/helpers/debug.dart';

class DoctorProfileController extends GetxController {
  RxInt doctorId = 0.obs;
  RxMap doctor = {}.obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();

    ever(doctorId, (value) {
      print('DoctorId = $doctorId');
      getDoctor(doctorId);
    });
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
    print('$apiUrl/api/doctors/$id?populate=*');
    var responseCek = await http.get(urlCek, headers: headers);

    var data = jsonDecode(responseCek.body)['data'];
    doctor.value = data;
    isLoading.value = false;
    debugPrint('-------');
    DebugTools().printWrapped(data.toString());
  }
}
