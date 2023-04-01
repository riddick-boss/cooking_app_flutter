import 'package:cooking_app_flutter/core/navigation/auth_main_nav_launcher.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/model/auth_user.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_main_nav_launcher_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthManager>()])
void main() {
  late AuthManager mockAuthManager;
  late AuthMainNavLauncher navLauncher;

  setUp(() {
    mockAuthManager = MockAuthManager();
    navLauncher = AuthMainNavLauncher(mockAuthManager);
  });

  test("initialRoute is login when user not logged in", () {
    when(mockAuthManager.currentUser).thenReturn(null);

    final route = navLauncher.initialRoute;
    expect(route, MainAppNavDestinations.login.route);
  });

  test("initialRoute is main screen when user logged in", () {
    when(mockAuthManager.currentUser).thenReturn(const AuthUser(uid: "uid", email: "email", displayName: "displayName"));

    final route = navLauncher.initialRoute;
    expect(route, MainAppNavDestinations.main.route);
  });
}
