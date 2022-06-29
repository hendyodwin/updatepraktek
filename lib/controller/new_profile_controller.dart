import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/helpers/debug.dart';
import 'package:praktek_app/root.dart';

class NewProfileController extends GetxController {
  final picker = ImagePicker();
  RxBool isLoading = true.obs;
  RxBool isMale = false.obs;
  RxString orderId = ''.obs;
  RxInt profileId = 0.obs;
  RxString dateToSave = ''.obs;
  Rx<File> profileImageFile = File('').obs;
  RxString profileImage = ''.obs;
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
    print(urlCek.toString());
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

    String fileName = profileImage.value;
    Dio.FormData data = Dio.FormData.fromMap({
      "files": await Dio.MultipartFile.fromFile(
        profileImageFile.value.path,
        filename: fileName,
        contentType: new MediaType("image", "jpeg"),
      ),
    });
    var imageId = null;
    Dio.Dio dio = new Dio.Dio();
    dio.options.headers["authorization"] = "Bearer ${token}";
    await dio.post(apiUrl + '/api/upload', data: data).then((response) {
      List jsonResponse = response.data;
      print('======= UPLOAD =======');
      print(jsonResponse.toString());
      print(jsonResponse[0]['id']);
      imageId = jsonResponse[0]['id'];
      // imagesUploaded.add(jsonResponse[0]['id']);
    }).catchError((error) => print(error));

    print(weightController.text.length);
    debugPrint('=======${weightController.text}=======');
    var weightToUse = 0;
    var heightToUse = 0;
    if (weightController.text.isNumericOnly) {
      weightToUse = int.parse(weightController.text);
    }
    if (heightController.text.isNumericOnly) {
      heightToUse = int.parse(weightController.text);
    }
    var dataSave = {
      "data": {
        "name": fullNameController.text,
        "users_permissions_user": Get.find<AuthController>().user_id_db.value,
        "place_of_birth": PoBController.text,
        "profile_picture": imageId,
        "ktp_number": KTPNumberController.text,
        "address": AddressController.text,
        "birthday": dateToSave.value,
        "Gender": isMale.value ? "male" : "female",
        "weight": weightToUse,
        "height": heightToUse,
      }
    };

    try {
      var urlUpdate = Uri.parse('$apiUrl/api/profiles');
      var responseUpdate = await http.post(urlUpdate,
          headers: headers, body: jsonEncode(dataSave));
      print(jsonDecode(responseUpdate.body));

      isLoading.value = false;
      Get.find<AuthController>().updateUserStrapi();

      Get.offAll(Root());
    } on Exception catch (e) {
      isLoading.value = false;
      print('===== ERROR ====');
      // TODO
    }
  }

  void uploadPP() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    File _image;
    if (image != null) {
      var token = await Get.find<AuthController>().getToken();

      _image = File(image.path);
      final img.Image? capturedImage =
          img.decodeImage(await _image.readAsBytes());
      final img.Image orientedImage = img.bakeOrientation(capturedImage!);
      profileImageFile.value =
          await File(image.path).writeAsBytes(img.encodeJpg(orientedImage));
      profileImage.value = _image.path.split('/').last;
    } else {
      print('No image selected.');
    }
  }
}
