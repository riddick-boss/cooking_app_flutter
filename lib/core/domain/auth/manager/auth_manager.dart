import 'package:cooking_app_flutter/core/domain/auth/model/auth_user.dart';

abstract class AuthManager {
  Stream<AuthUser?> get authState;

  AuthUser? get currentUser;

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> updateDisplayNameWithName({
    required String firstName,
    required String lastName,
  });

  Future<void> updateDisplayNameWithDisplayValue({
    required String displayValue,
  });

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
