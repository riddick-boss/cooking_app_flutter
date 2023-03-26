import 'package:cooking_app_flutter/core/navigation/auth_main_nav_launcher.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/navigation/main_nav_launcher.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NavModule {
  MainNavLauncher getMainNavLauncher(
      AuthManager authManager,
      ) {
    return AuthMainNavLauncher(authManager);
  }
}
