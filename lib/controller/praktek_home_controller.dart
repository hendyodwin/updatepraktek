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

class PraktekHomeController extends GetxController {
  RxBool isLoading = false.obs;
  final image1 = Rxn<XFile>();
  final image2 = Rxn<XFile>();
  var image1_id;
  var image2_id;
  final picker = ImagePicker();
  RxString profileName = ''.obs;
  RxList my_orders_user_patient_video = [].obs;

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
  void onInit() async {
    // TODO: implement onInit
    await Get.find<AuthController>().updateUserStrapi();
    getDoctorDetails();
    getMyOrders();
    super.onInit();
  }

  void getMyOrders() async {
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var query_str = '';
    int index = 0;

    var urlCek = Uri.parse(
        '$apiUrl/api/appointments?filters[doctor][0]=${Get.find<AuthController>().my_doctor_id}&filters[type][1]=video&filters[paid][2]=1&filters[doctor_availability][start][\$gt][3]=${DateTime.now().add(const Duration(minutes: -30)).toUtc()}&sort[0]=createdAt&populate[0]=*&populate[1]=doctor.profile_picture&populate[2]=doctor.doctor_specialty&populate[3]=doctor_availability&populate[4]=profile.profile_picture');
    var responseCek = await http.get(urlCek, headers: headers);
    var data = jsonDecode(responseCek.body)['data'];
    my_orders_user_patient_video.value = data;
    print(urlCek);
  }

  void getDoctorDetails() async {
    print('<<<===========>>>');
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
    print('okay we got something');
    doctorInfo.value = jsonDecode(responseCek.body)['data'];

    profileName.value =
        jsonDecode(responseCek.body)['data']['attributes']['full_name'];

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
