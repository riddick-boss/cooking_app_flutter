import 'dart:async';

import 'package:cooking_app_flutter/core/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/core/domain/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/core/domain/util/unit.dart';
import 'package:cooking_app_flutter/core/util/extension/string_extension.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignUpViewModel {
  final _authManager = getIt<AuthManager>();

  final _onNavigateToDishesScreenController = StreamController<Unit>.broadcast();
  Stream<Unit> get onNavigateToDishesScreenStream => _onNavigateToDishesScreenController.stream;
  
  final _showCreateAccountErrorSnackBarController = StreamController<String>.broadcast();
  Stream<String> get showLoginErrorSnackBarStream => _showCreateAccountErrorSnackBarController.stream;

  Future<void> createUserWithEmailAndPassword({required String email, required String password, required String firstName, required String lastName}) async {
    try {
      await _authManager.createUserWithEmailAndPassword(email: email, password: password);
      final userDisplayValue = (lastName.isBlankOrEmpty) ? firstName : "$firstName $lastName";
      // TODO: create user bucket in firebase db
      _onNavigateToDishesScreenController.add(Unit());
    } catch(e) {
      debugPrint("create account error: $e");
      _showCreateAccountErrorSnackBarController.add(AppStrings.signUpFailedToCreateAccount);
    }
  }

  bool isFirstNameValid({required String? firstName}) => firstName != null && !firstName.isBlankOrEmpty;

  bool isLastNameValid({required String? lastName}) => lastName != null;

  bool isEmailValid({required String? email}) => email != null && EmailValidator.validate(email);

  bool isPasswordValid({required String? password}) => password != null && !password.isBlankOrEmpty && password.length >= 6;

  void dispose() {
    _onNavigateToDishesScreenController.close();
    _showCreateAccountErrorSnackBarController.close();
  }
}
