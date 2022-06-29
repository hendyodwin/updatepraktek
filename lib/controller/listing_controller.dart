import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:praktek_app/helpers/debug.dart';

class ListingController extends GetxController {
  RxList doctorList = [].obs;
  RxBool isLoading = false.obs;
  @override
  void getDoctors() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek = Uri.parse(
        '$apiUrl/api/doctors?filters[full_name][\$containsi][0]=${Get.find<AuthController>().mySearch.text}&filters[approved][\$eq][1]=1&populate=*');

    var responseCek = await http.get(urlCek, headers: headers);

    var data = jsonDecode(responseCek.body)['data'];
    doctorList.value = data;
    isLoading.value = false;
    debugPrint('-------');
    debugPrint(data.toString());
  }

  void saveDoctor(int doctor_id, bool add) async {
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var urlCek = Uri.parse('$apiUrl/api/me/update');
    var doctorAll = Get.find<AuthController>().user_doctors_ids.value;
    doctorAll.add(doctor_id);
    Map _response = {
      'data': {'doctors': doctorAll}
    };

    var dataPackage = jsonEncode(_response);
    var responseCek =
        await http.post(urlCek, headers: headers, body: dataPackage);

    var data = responseCek.body;
    Get.find<AuthController>().updateUserStrapi();
    // DebugTools().printWrapped(data.toString());
  }

  void onInit() async {
    // TODO: implement onInit
    debugPrint('======== Loaded Listing Controller ========');
    getDoctors();
    super.onInit();
  }
}
