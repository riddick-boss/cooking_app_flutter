import 'package:cooking_app_flutter/core/domain/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/core/infrastructure/auth/firebase_auth_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AuthManagerModule {
  @singleton
  AuthManager getAuthManager(FirebaseAuth firebaseAuth) => FirebaseAuthManager(firebaseAuth);
}
