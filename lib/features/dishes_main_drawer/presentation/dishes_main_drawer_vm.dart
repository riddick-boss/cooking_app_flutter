import 'dart:async';

import 'package:cooking_app_flutter/core/domain/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/core/domain/util/unit.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class DishesMainDrawerViewModel {
  final _authManager = getIt<AuthManager>();

  final _onNavigateToLogInScreenController = StreamController<Unit>.broadcast();
  Stream<Unit> get onNavigateToLogInScreenStream => _onNavigateToLogInScreenController.stream;

  String? get userDisplayValue => _authManager.currentUser?.displayName;

  Future<void> signOut() async {
    try {
      await _authManager.signOut();
      _onNavigateToLogInScreenController.add(Unit());
    } catch(e) {
      debugPrint("log out error: $e");
    }
  }

  void dispose() {
    _onNavigateToLogInScreenController.close();
  }
}
