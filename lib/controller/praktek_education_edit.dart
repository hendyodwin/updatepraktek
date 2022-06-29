import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:http/http.dart' as http;

import 'package:praktek_app/root.dart';

class PraktekEducationEditController extends GetxController {
  RxBool isLoading = true.obs;
  final image1 = Rxn<XFile>();
  final image2 = Rxn<XFile>();
  var image1_id;
  var image2_id;
  RxInt profileId = 0.obs;
  RxString dateToSave = ''.obs;
  RxList specialistsList = [].obs;
  final formKey = GlobalKey<FormState>();
  RxList<DropdownMenuItem<String>> specialityItems = [
    DropdownMenuItem(
      child: Text('None'),
      value: 'None',
    )
  ].obs;
  TextEditingController yearsExperienceController = TextEditingController();
  TextEditingController videoController = TextEditingController();
  TextEditingController chatController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  RxMap doctor = {}.obs;
  RxString selectedValue = "USA".obs;
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("USA"), value: "USA"),
      DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
      DropdownMenuItem(child: Text("England"), value: "England"),
    ];
    return menuItems;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getDoctorDetails();
    super.onInit();
  }

  void getDoctorDetails() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var urlCek = Uri.parse(
        '$apiUrl/api/doctors/${Get.find<AuthController>().my_doctor_id}?populate=*');

    var responseCek = await http.get(urlCek, headers: headers);
    doctor.value = jsonDecode(responseCek.body)['data'];
    print(jsonDecode(responseCek.body)['data']);
    if (jsonDecode(responseCek.body)['data'].length > 0) {}
    videoController.text = jsonDecode(responseCek.body)['data']['attributes']
            ['rate_video']
        .toString();
    chatController.text = jsonDecode(responseCek.body)['data']['attributes']
            ['rate_chat']
        .toString();
    isLoading.value = false;
  }

  void saveEducationInformation() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var dataSave = {
      "data": {
        "name": nameController.text,
        "year": int.parse(yearController.text),
        "doctor": Get.find<AuthController>().my_doctor_id.value,
      }
    };
    print(dataSave);
    // if (profileId.value == 0) {
    // } else {
    var urlUpdate = Uri.parse('$apiUrl/api/doctor-cv-educations');
    var responseUpdate = await http.post(urlUpdate,
        body: jsonEncode(dataSave), headers: headers);
    print(jsonDecode(responseUpdate.body));
    // }
    Get.find<AuthController>().updateUserStrapi();
    getDoctorDetails();
    isLoading.value = false;
  }

  void removeEducation(id) async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    // if (profileId.value == 0) {
    // } else {
    var urlUpdate = Uri.parse('$apiUrl/api/doctor-cv-educations/${id}');
    var responseUpdate = await http.delete(urlUpdate, headers: headers);
    print(jsonDecode(responseUpdate.body));
    // }
    Get.find<AuthController>().updateUserStrapi();
    getDoctorDetails();
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
        "rate_video": int.parse(videoController.text),
        "rate_chat": int.parse(chatController.text),
      }
    };
    print(dataSave);
    // if (profileId.value == 0) {
    // } else {
    var urlUpdate = Uri.parse(
        '$apiUrl/api/doctors/${Get.find<AuthController>().my_doctor_id}');
    var responseUpdate =
        await http.put(urlUpdate, headers: headers, body: jsonEncode(dataSave));
    print(jsonDecode(responseUpdate.body));
    // }
    Get.find<AuthController>().updateUserStrapi();
    isLoading.value = false;

    Get.offAll(Root());
  }
}
