import 'dart:async';

import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/util/extension/string_extension.dart';
import 'package:cooking_app_flutter/domain/util/unit.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

//TODO: use RxDart

@injectable
class LoginViewModel {
  final _authManager = getIt<AuthManager>();

  final _onNavigateToDishesScreenController = StreamController<Unit>.broadcast();
  Stream<Unit> get onNavigateToDishesScreenStream => _onNavigateToDishesScreenController.stream;

  final _showLoginErrorSnackBarController = StreamController<String>.broadcast();
  Stream<String> get showLoginErrorSnackBarStream => _showLoginErrorSnackBarController.stream;

  final _progressIndicatorVisible = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get progressIndicatorVisible => _progressIndicatorVisible.stream;

  Future<void> onSignInClicked({required String email, required String password}) async {
    _progressIndicatorVisible.add(true);
    try {
      await _authManager.signInWithEmailAndPassword(email: email, password: password);
      _onNavigateToDishesScreenController.add(Unit());
    } catch(e) {
      debugPrint("login failed: $e");
      _showLoginErrorSnackBarController.add(AppStrings.loginFailedToLogin);
    }
    _progressIndicatorVisible.add(false);
  }

  bool isEmailValid({required String? email}) => email != null && EmailValidator.validate(email);

  bool isPasswordValid({required String? password}) => password != null && !password.isBlankOrEmpty;

  void dispose() {
    _onNavigateToDishesScreenController.close();
    _showLoginErrorSnackBarController.close();
  }
}
