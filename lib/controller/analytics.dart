import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelManager {
  static Mixpanel? _instance;

  static Future<Mixpanel> init() async {
    if (_instance == null) {
      _instance = await Mixpanel.init("195d9e7e1404859dd6f9373f6844b8e9",
          optOutTrackingDefault: false);
    }
    return _instance!;
  }
}
