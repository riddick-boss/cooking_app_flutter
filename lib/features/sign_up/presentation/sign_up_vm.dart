import 'dart:async';

import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/domain/util/extension/string_extension.dart';
import 'package:cooking_app_flutter/domain/util/unit.dart';
import 'package:cooking_app_flutter/features/sign_up/data/sign_up_step.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

// TODO: use rxDart

@injectable
class SignUpViewModel {
  final _authManager = getIt<AuthManager>();
  final _remoteDatabase = getIt<RemoteDatabaseManager>();

  final _onNavigateToDishesScreenController = StreamController<Unit>.broadcast();
  Stream<Unit> get onNavigateToDishesScreenStream => _onNavigateToDishesScreenController.stream;

  final _showCreateAccountErrorSnackBarController = StreamController<String>.broadcast();
  Stream<String> get showLoginErrorSnackBarStream => _showCreateAccountErrorSnackBarController.stream;

  final _progressIndicatorStatus = BehaviorSubject<SignUpStep?>.seeded(null);
  Stream<SignUpStep?> get progressIndicatorState => _progressIndicatorStatus.stream;

  Future<void> createUserWithEmailAndPassword({required String email, required String password, required String firstName, required String lastName}) async {
    try {
      _progressIndicatorStatus.add(SignUpStep.collectingIngredients);
      await _authManager.createUserWithEmailAndPassword(email: email, password: password);
      _progressIndicatorStatus.add(SignUpStep.mixing);
      final userDisplayValue = (lastName.isBlankOrEmpty) ? firstName : "$firstName $lastName";
      await _authManager.updateDisplayNameWithDisplayValue(displayValue: userDisplayValue);
      _progressIndicatorStatus.add(SignUpStep.tastingWonderfulDishes);
      final userUid = _authManager.currentUser!.uid;
      await _remoteDatabase.initUserCollection(userUid: userUid, firstName: firstName, lastName: lastName);
      _progressIndicatorStatus.add(SignUpStep.done);
      await Future.delayed(const Duration(seconds: 3), () {});
      _progressIndicatorStatus.add(null);
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
