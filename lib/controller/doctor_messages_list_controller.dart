import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:praktek_app/helpers/debug.dart';

class DoctorMessagesListController extends GetxController {
  RxBool isLoading = false.obs;
  RxList messageList = [].obs;
  @override
  void onInit() async {
    super.onInit();
    getChatList();
  }

  Future<String> getChatList() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek = Uri.parse(
        '$apiUrl/api/appointments?filters[doctor][0]=${Get.find<AuthController>().my_doctor_id.value}&filters[type][1]=chat&filters[paid][2]=1&sort[0]=createdAt&populate[0]=*&populate[1]=profile.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability');

    var responseCek = await http.get(urlCek, headers: headers);

    var data = jsonDecode(responseCek.body)['data'];
    messageList.value = data;
    DebugTools().printWrapped(data.toString());
    isLoading.value = false;
    return 'Done';
  }
}
