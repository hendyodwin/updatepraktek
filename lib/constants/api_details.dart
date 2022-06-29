import 'package:praktek_app/flavors.dart';

// const apiMidtrans =
//     'https://8p2ovi57el.execute-api.ap-southeast-1.amazonaws.com/dev/';
const apiMidtrans =
    'https://qko0jx6bf5.execute-api.ap-southeast-1.amazonaws.com/development/';
const kImageURL = 'https://storage.googleapis.com/tokita-app.appspot.com/';

String get apiUrl {
  switch (F.appFlavor) {
    case Flavor.DEVELOPMENT:

      // return 'http://172.31.232.180:1338';

      return 'https://admin-dev.praktek.io';
    case Flavor.STAGING:
      return 'https://10.0.2.2:1338';
    case Flavor.PRODUCTION:
      return 'https://admin.praktek.io';
    default:
      return 'https://admin.praktek.io';
  }
}
