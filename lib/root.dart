import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:praktek_app/controller/auth_controller.dart';
import 'package:praktek_app/screens/home.dart';
import 'package:praktek_app/screens/login.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (Get.find<AuthController>().user != null) ? Home() : Login();
    });
  }
}
