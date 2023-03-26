import 'dart:async';

import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/util/unit.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainViewModel {
  MainViewModel(this._authManager);

  final AuthManager _authManager;

  Stream<Unit> get logoutStream =>
      _authManager.authState.where((user) => user == null).map((_) => Unit());
}
