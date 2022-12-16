import 'package:cooking_app_flutter/domain/infrastructure/auth/model/auth_user.dart';

abstract class AuthManager {
  Stream<AuthUser?> get authState;

  AuthUser? get currentUser;

  Future<void> createUserWithEmailAndPassword({
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
