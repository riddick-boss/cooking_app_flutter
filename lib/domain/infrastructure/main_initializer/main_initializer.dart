import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/firebase/firebase_initializer.dart';
import 'package:flutter/material.dart';

class MainInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FirebaseInitializer.init();
    configureInjection();
  }
}
