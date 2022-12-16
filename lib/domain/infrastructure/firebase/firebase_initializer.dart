// ignore_for_file: no_default_cases

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseInitializer {
  static Future<void> init() async {
    await Firebase.initializeApp(options: await _currentPlatformOptions);
  }

  static Future<FirebaseOptions> get _currentPlatformOptions async {
    await dotenv.load();
    if (kIsWeb) {
      return _web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static final FirebaseOptions _web = FirebaseOptions(
    apiKey: dotenv.get("webApiKey", fallback: "dummy"),
    authDomain: dotenv.get("authDomain", fallback: "dummy"),
    projectId: dotenv.get("projectId", fallback: "dummy"),
    storageBucket: dotenv.get("storageBucket", fallback: "dummy"),
    messagingSenderId: dotenv.get("messagingSenderId", fallback: "dummy"),
    appId: dotenv.get("appId", fallback: "dummy"),
  );

  static final FirebaseOptions _android = FirebaseOptions(
    apiKey: dotenv.get("androidApiKey", fallback: "dummy"),
    projectId: dotenv.get("projectId", fallback: "dummy"),
    storageBucket: dotenv.get("storageBucket", fallback: "dummy"),
    messagingSenderId: dotenv.get("messagingSenderId", fallback: "dummy"),
    appId: dotenv.get("appId", fallback: "dummy"),
  );
}
