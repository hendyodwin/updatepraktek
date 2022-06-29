import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:praktek_app/constants/api_details.dart';
import 'package:praktek_app/controller/analytics.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/controller/booking_detail_controller.dart';
import 'package:http/http.dart' as http;
import 'package:praktek_app/helpers/debug.dart';

class PaymentDetailController extends GetxController {
  late final Mixpanel _mixpanel;
  RxBool isLoading = false.obs;
  RxMap paymentInfo = {}.obs;

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }

  @override
  void onInit() {
    super.onInit();
    _initMixpanel();
    getPaymentDetails();
  }

  Future<void> copyToClipboard(text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied to clipboard',
      '${text} has been copied to your clipboard.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.greenAccent,
    );
  }

  void getPaymentDetails() async {
    isLoading.value = true;
    var token = await Get.find<AuthController>().getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    var urlCek = Uri.parse(
        '$apiUrl/api/appointments/${Get.find<BookingDetailController>().lastOrderId.value}?populate=*');
    var responseCek = await http.get(urlCek, headers: headers);

    var data = jsonDecode(responseCek.body)['data'];
    paymentInfo.value = data;
    DebugTools().printWrapped(data.toString());
    isLoading.value = false;
  }
}
