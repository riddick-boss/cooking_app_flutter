import 'package:cooking_app_flutter/core/infrastructure/auth/firebase_auth_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AuthManagerModule {
  @lazySingleton
  AuthManager getAuthManager(
      FirebaseAuth firebaseAuth,
      ) {
    return FirebaseAuthManager(firebaseAuth);
  }
}
