import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:overlay_support/overlay_support.dart';

class MainController extends GetxController {
  late Mixpanel mixpanel;
  bool mixpanelInit = false;

  late final FirebaseMessaging _messaging;

  @override
  void onInit() async {
    super.onInit();
    initMixpanel();
    registerNotification();
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications


      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received

        print("MEssage data");
        print(message.data.toString());

        if (message != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(message.from.toString()),

            subtitle: Text("Hi its me "),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }

      });
    } else {
      print('User declined or has not accepted permission');
    }




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
