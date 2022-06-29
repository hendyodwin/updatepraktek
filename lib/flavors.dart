import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor {
  DEVELOPMENT,
  STAGING,
  PRODUCTION,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.DEVELOPMENT:
        return 'Praktek (Dev)';
      case Flavor.STAGING:
        return 'Praktek (Staging)';
      case Flavor.PRODUCTION:
        return 'Praktek';
      default:
        return 'title';
    }
  }

  static String? get baseUrl {
    try {
      return dotenv.env['BASEURL'];
    } catch (e) {
      return '';
    }
  }
}
