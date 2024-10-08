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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDsUiE6WJcv-iooicvie2Fh6y8kkoh9ltc',
    appId: '1:119970130306:web:156454f5f56e598229c79b',
    messagingSenderId: '119970130306',
    projectId: 'gen-lang-client-0071363946',
    authDomain: 'gen-lang-client-0071363946.firebaseapp.com',
    storageBucket: 'gen-lang-client-0071363946.appspot.com',
    measurementId: 'G-ED4FHH6MYW',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD2lwTt2RTxSVgW2EtdsKWX4D6ck6PG_2A',
    appId: '1:119970130306:ios:b0c1b281dce8705629c79b',
    messagingSenderId: '119970130306',
    projectId: 'gen-lang-client-0071363946',
    storageBucket: 'gen-lang-client-0071363946.appspot.com',
    iosBundleId: 'com.example.flutterApp',
  );

}