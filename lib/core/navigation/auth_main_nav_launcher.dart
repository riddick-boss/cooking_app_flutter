import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/domain/navigation/main_nav_launcher.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthMainNavLauncher implements MainNavLauncher {
  final _authManager = getIt<AuthManager>();
  
  @override
  String get initialRoute => _authManager.currentUser == null
      ? MainAppNavDestinations.login.route
      : MainAppNavDestinations.main.route;
}
