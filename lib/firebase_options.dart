// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyAZxK1wviaZXxWrasXD2E8XlMWxM4H0buw',
    appId: '1:1020750557862:android:a7d75eb9804dce9de4ba67',
    messagingSenderId: '1020750557862',
    projectId: 'wellness-6082a',
    databaseURL: 'https://wellness-6082a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'wellness-6082a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZmUN4nRrTqaif0fvZL5edpavBLtSQQO4',
    appId: '1:1020750557862:ios:e973356a55fc19c1e4ba67',
    messagingSenderId: '1020750557862',
    projectId: 'wellness-6082a',
    databaseURL: 'https://wellness-6082a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'wellness-6082a.appspot.com',
    androidClientId: '1020750557862-ckoldbutt84nes8vtolnvhmhjojstq7u.apps.googleusercontent.com',
    iosClientId: '1020750557862-v5mura2l3k7h8l0se9fiej4j0drvfrss.apps.googleusercontent.com',
    iosBundleId: 'com.wellness.iamok',
  );

}