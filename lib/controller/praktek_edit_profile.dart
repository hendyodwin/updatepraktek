import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as Dio;
import 'package:image/image.dart' as img;
import 'package:praktek_app/helpers/debug.dart';
import 'package:praktek_app/root.dart';

class PraktekEditProfileController extends GetxController {
  RxBool isLoading = false.obs;
  final image1 = Rxn<XFile>();
  final image2 = Rxn<XFile>();
  var image1_id; //not yet use
  var image2_id; //not yet use
  final picker = ImagePicker();

  RxInt profileId = 0.obs;
  RxString dateToSave = ''.obs;
  RxList specialistsList = [].obs;
  RxMap doctorInfo = {}.obs;
  final formKey = GlobalKey<FormState>();
  RxList<DropdownMenuItem<String>> specialityItems = [
    DropdownMenuItem(
      child: Text('None'),
      value: 'None',
    )
  ].obs;
  TextEditingController yearsExperienceController = TextEditingController();
  TextEditingController videoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

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
    print(jsonDecode(responseCek.body)['data']);
    if (jsonDecode(responseCek.body)['data'].length > 0) {
      print('okay we got something');
      doctorInfo.value = jsonDecode(responseCek.body)['data'];
    }
    nameController.text = jsonDecode(responseCek.body)['data']['attributes']
            ['full_name']
        .toString();
    aboutController.text =
        jsonDecode(responseCek.body)['data']['attributes']['about'].toString();
    isLoading.value = false;
  }

  Future saveUserInformation() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var dataSave = {
      "data": {
        "full_name": nameController.text,
        "about": aboutController.text,
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
    return true;
  }

  Future saveUserInformationPP(id) async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var dataSave = {
      "data": {
        "profile_picture": id,
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
    getDoctorDetails();

    return true;
  }

  void uploadPP() async {
    isLoading.value = true;

    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    File _image;
    if (image != null) {
      var token = await Get.find<AuthController>().getToken();

      _image = File(image.path);
      final img.Image? capturedImage =
          img.decodeImage(await _image.readAsBytes());
      final img.Image orientedImage = img.bakeOrientation(capturedImage!);
      await File(image.path).writeAsBytes(img.encodeJpg(orientedImage));
      String fileName = _image.path.split('/').last;
      Dio.FormData data = Dio.FormData.fromMap({
        "files": await Dio.MultipartFile.fromFile(
          _image.path,
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
        print(jsonResponse[0]['id']);
        saveUserInformationPP(jsonResponse[0]['id']);
        // imagesUploaded.add(jsonResponse[0]['id']);
      }).catchError((error) => print(error));
    } else {
      print('No image selected.');
    }
    isLoading.value = false;
  }
}
