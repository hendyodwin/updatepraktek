import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MainController extends GetxController {
  late Mixpanel mixpanel;
  bool mixpanelInit = false;

  @override
  void onInit() async {
    super.onInit();
    initMixpanel();
  }

  Future<void> initMixpanel() async {
    mixpanel = await Mixpanel.init("195d9e7e1404859dd6f9373f6844b8e9",
        optOutTrackingDefault: false);
    mixpanelInit = true;
  }

  Future<void> trackEventMixPanel(name) async {
    debugPrint('MIXPANEL EVENT ====> $name');
    if (mixpanelInit == false) {
      mixpanel = await Mixpanel.init("195d9e7e1404859dd6f9373f6844b8e9",
          optOutTrackingDefault: false);
      mixpanel.track(name);
    } else {
      mixpanel.track(name);
    }
  }

  Future<void> trackPaymentMixPanel(name) async {
    debugPrint('MIXPANEL EVENT ====> $name');
    if (mixpanelInit == false) {
      mixpanel = await Mixpanel.init("195d9e7e1404859dd6f9373f6844b8e9",
          optOutTrackingDefault: false);
      mixpanel.track('Payment Selected', properties: {'Option': name});
      mixpanel.track(name);
    } else {
      mixpanel.track('Payment Selected', properties: {'Option': name});
      mixpanel.track(name);
    }
  }
}
