import 'package:cooking_app_flutter/core/infrastructure/auth/mapper/user_mapper.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/model/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
@injectable
class FirebaseAuthManager implements AuthManager {
  FirebaseAuthManager(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Stream<AuthUser?> get authState => _firebaseAuth.authStateChanges().map((user) => user?.toAuthUser());

  @override
  AuthUser? get currentUser => _firebaseAuth.currentUser?.toAuthUser();

  @override
  Future<void> createUserWithEmailAndPassword({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> updateDisplayNameWithName({required String firstName, required String lastName}) async {
    await _firebaseAuth.currentUser?.updateDisplayName("$firstName $lastName");
  }

  @override
  Future<void> updateDisplayNameWithDisplayValue({required String displayValue}) async {
    await _firebaseAuth.currentUser?.updateDisplayName(displayValue);
  }

  @override
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
