import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:http/http.dart' as http;

class DoctorHistoryController extends GetxController {
  RxList my_orders_user_patient_video_upcoming = [].obs;
  RxList my_orders_user_patient_video_done = [].obs;
  RxList my_orders_user_patient_video_cancelled = [].obs;
  RxList my_orders_user_patient_video_waiting = [].obs;
  RxInt selectedIndex = 0.obs;

  @override
  void onInit() async {
    getMyOrdersScreenData();
    super.onInit();
  }

  void updateIndex(index) async {
    selectedIndex.value = index;
  }

  void getMyOrdersScreenData() async {
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek = Uri.parse(
        '$apiUrl/api/appointments?filters[doctor][0]=${Get.find<AuthController>().my_doctor_id.value}&filters[type][1]=video&filters[paid][2]=1&filters[doctor_availability][start][\$gt][3]=${DateTime.now().add(const Duration(minutes: -30)).toUtc()}&sort[0]=createdAt&populate[0]=*&populate[1]=doctor.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability&populate[4]=profile.profile_picture');
    var responseCek = await http.get(urlCek, headers: headers);
    var data = jsonDecode(responseCek.body)['data'];
    my_orders_user_patient_video_upcoming.value = data;
    urlCek = Uri.parse(
        '$apiUrl/api/appointments?filters[doctor][0]=${Get.find<AuthController>().my_doctor_id.value}&filters[type][1]=video&filters[paid][2]=1&filters[doctor_availability][start][\$lt][3]=${DateTime.now().add(const Duration(minutes: -30)).toUtc()}&sort[0]=createdAt&populate[0]=*&populate[1]=doctor.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability&populate[4]=profile.profile_picture');
    responseCek = await http.get(urlCek, headers: headers);
    data = jsonDecode(responseCek.body)['data'];
    my_orders_user_patient_video_done.value = data;
    urlCek = Uri.parse(
        '$apiUrl/api/appointments?filters[doctor][0]=${Get.find<AuthController>().my_doctor_id.value}&filters[type][1]=video&filters[paid][2]=0&filters[doctor_availability][start][\$lt][3]=${DateTime.now().toUtc()}&sort[0]=createdAt&populate[0]=*&populate[1]=doctor.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability&populate[4]=profile.profile_picture');
    responseCek = await http.get(urlCek, headers: headers);

    data = jsonDecode(responseCek.body)['data'];
    my_orders_user_patient_video_cancelled.value = data;
  }
}
