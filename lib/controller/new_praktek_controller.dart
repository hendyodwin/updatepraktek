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

//TODO: 1 dipakek buat kalo orang mau buat as a doctor
class NewPraktekController extends GetxController {
  RxBool isLoading = false.obs;
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
    getSpecialities();
    super.onInit();
  }

  void getSpecialities() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var urlCek = Uri.parse('$apiUrl/api/doctor-specialties?sort[0]=name');

    var responseCek = await http.get(urlCek, headers: headers);
    if (jsonDecode(responseCek.body)['data'].length > 0) {
      var data = jsonDecode(responseCek.body)['data'];
      for (var i = 0; i < data.length; i++) {
        if (i == 0) {
          selectedValue.value = data[i]['id'].toString();
        }
        specialityItems.add(DropdownMenuItem(
            child: Text(data[i]['attributes']['name']),
            value: data[i]['id'].toString()));
        print(data[i]);
      }

      specialistsList.value = data;
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
    if (image1.value != null) {
      File file = File(image1.value!.path);
      String fileName = file.path.split('/').last;
      print(fileName);
      print(file.path);
      final img.Image? capturedImage =
          img.decodeImage(await file.readAsBytes());
      final img.Image orientedImage = img.bakeOrientation(capturedImage!);
      await File(file.path).writeAsBytes(img.encodeJpg(orientedImage));
      Dio.FormData data = Dio.FormData.fromMap({
        "files": await Dio.MultipartFile.fromFile(
          file.path,
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
        image1_id = jsonResponse[0]['id'];
      }).catchError((error) => print(error));
    }
    if (image2.value != null) {
      File file = File(image2.value!.path);
      String fileName = file.path.split('/').last;
      print(fileName);
      print(file.path);
      final img.Image? capturedImage =
          img.decodeImage(await file.readAsBytes());
      final img.Image orientedImage = img.bakeOrientation(capturedImage!);
      await File(file.path).writeAsBytes(img.encodeJpg(orientedImage));
      Dio.FormData data = Dio.FormData.fromMap({
        "files": await Dio.MultipartFile.fromFile(
          file.path,
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
        image2_id = jsonResponse[0]['id'];
      }).catchError((error) => print(error));
    }

    var dataSave = {
      "data": {
        "full_name": Get.find<AuthController>().profileName.value,
        "profile_picture":
            Get.find<AuthController>().profileImage['id'].toString(),
        "doctor_specialty": selectedValue.value.toString(),
        "users_permissions_user":
            Get.find<AuthController>().user_id_db.value.toString(),
        "rate_video": int.parse(videoController.text),
        "rate_chat": int.parse(chatController.text),
        "years_experience": int.parse(yearsExperienceController.text),
        "about": aboutController.text,
        "STR": image1_id,
        "SIP": image2_id,
      }
    };
    print(dataSave);
    // if (profileId.value == 0) {
    // } else {
    var urlUpdate = Uri.parse('$apiUrl/api/doctors');
    var responseUpdate = await http.post(urlUpdate,
        body: jsonEncode(dataSave), headers: headers);
    print(jsonDecode(responseUpdate.body));
    // }
    Get.find<AuthController>().updateUserStrapi();
    isLoading.value = false;

    Get.offAll(Root());
  }
}
