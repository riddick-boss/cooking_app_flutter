import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class AccountViewModel {
  final _authManager = getIt<AuthManager>();

  Stream<String?> get name => _authManager.authState.map((account) => account?.displayName);

  Future<void> onLogoutClicked() async {
    try {
      await _authManager.signOut();
    } catch (e) {
      debugPrint("logout error: $e");
    }
  }
}
