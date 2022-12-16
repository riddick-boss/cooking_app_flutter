import 'package:cooking_app_flutter/core/navigation/auth_main_nav_launcher.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_main_nav_launcher_test.mocks.dart';

// class _MockAuthUser extends Mock implements AuthUser {}

@GenerateNiceMocks([MockSpec<AuthManager>()])
void main() {
  getIt.registerSingleton<AuthManager>(MockAuthManager());

  final mockAuthManager = MockAuthManager();
  final navLauncher = AuthMainNavLauncher();

  test("initialRoute is login when user not logged in", () {
    when(mockAuthManager.currentUser).thenReturn(null);

    final route = navLauncher.initialRoute;
    expect(route, MainAppNavDestinations.login.route);
  });

  // test("initialRoute is login when user logged in", () {
  //   when(mockAuthManager.currentUser).thenReturn(_MockAuthUser());
  //
  //   final route = navLauncher.initialRoute;
  //   expect(route, MainAppNavDestinations.main.route);
  // });
}
