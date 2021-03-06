// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcCiY1I3Vtm__YcjafJoCOXbUWOYOJIkU',
    appId: '1:637673285234:android:9002d2f223c8b93f81c4eb',
    messagingSenderId: '637673285234',
    projectId: 'praktek-dev',
    storageBucket: 'praktek-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCAUiXZgalsnquez1D6kyp2hR-EIvQw-p0',
    appId: '1:637673285234:ios:6e83aeadc18dc66b81c4eb',
    messagingSenderId: '637673285234',
    projectId: 'praktek-dev',
    storageBucket: 'praktek-dev.appspot.com',
    androidClientId: '637673285234-1c2q8slfl9gpdniql13gvj9fr4fub7pp.apps.googleusercontent.com',
    iosClientId: '637673285234-b0klij0mjfid9ffqf5n0d68nvb8dbvmu.apps.googleusercontent.com',
    iosBundleId: 'io.praktek.dev',
  );
}
