import 'dart:async';

import 'package:cooking_app_flutter/core/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/core/domain/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/core/domain/util/unit.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginViewModel {
  final _authManager = getIt<AuthManager>();

  final _onNavigateToDishesScreenController = StreamController<Unit>.broadcast();
  Stream<Unit> get onNavigateToDishesScreenStream => _onNavigateToDishesScreenController.stream;

  final _showLoginErrorSnackBarController = StreamController<String>.broadcast();
  Stream<String> get showLoginErrorSnackBarStream => _showLoginErrorSnackBarController.stream;

  void dispose() {
    _onNavigateToDishesScreenController.close();
  }

  Future<void> onSignInClicked({required String email, required String password}) async {
    try {
      await _authManager.signInWithEmailAndPassword(email: email, password: password);
      _onNavigateToDishesScreenController.add(Unit());
    } catch(e) {
      debugPrint("login failed: $e");
      _showLoginErrorSnackBarController.add(AppStrings.loginFailedToLogin);
    }
  }
}
