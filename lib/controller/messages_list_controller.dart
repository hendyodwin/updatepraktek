import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:praktek_app/helpers/debug.dart';

class MessagesListController extends GetxController {
  RxBool isLoading = false.obs;
  RxList messageList = [].obs;
  @override
  void onInit() async {
    super.onInit();
    getChatList();
  }

  void getChatList() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek =
    // Uri.parse('$apiUrl'+'/api/profiles/99');
    Uri.parse('$apiUrl/api/appointments?filters[users_permissions_user][0]=${Get.find<AuthController>().user_id_db.value}&filters[type][1]=chat&sort[0]=createdAt&populate[0]=*&populate[1]=doctor.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability');

    var responseCek = await http.get(urlCek, headers: headers);

    print("HI respon");
    print('$apiUrl'+'/api/profiles/99');
    print( jsonDecode(responseCek.body));

    var data = jsonDecode(responseCek.body)['data'];
    messageList.value = data;
    DebugTools().printWrapped(data.toString());
    isLoading.value = false;
  }
}
