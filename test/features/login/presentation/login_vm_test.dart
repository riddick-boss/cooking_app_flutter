import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/features/login/presentation/login_vm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'login_vm_test.mocks.dart';

@GenerateMocks([AuthManager, RemoteDatabaseManager])
void main() {
  getIt
    ..registerSingleton<AuthManager>(MockAuthManager())
    ..registerSingleton<RemoteDatabaseManager>(MockRemoteDatabaseManager());

  final viewModel = LoginViewModel(MockAuthManager());

  test("email validation returns false when is null", () {
    expect(viewModel.isEmailValid(email: null), false);
  });

  test("email validation returns false when not no email format entered", () {
    expect(viewModel.isEmailValid(email: "noemail.type"), false);
    expect(viewModel.isEmailValid(email: "noemail@type"), false);
    expect(viewModel.isEmailValid(email: "noemail.type@"), false);
  });

  test("email validation returns true when proper email typed", () {
    expect(viewModel.isEmailValid(email: "proper@email.com"), true);
    expect(viewModel.isEmailValid(email: "proper@email.pl"), true);
  });

  test("password validation returns false when is null", () {
    expect(viewModel.isPasswordValid(password: null), false);
  });

  test("password validation returns false when is empty", () {
    expect(viewModel.isPasswordValid(password: ""), false);
  });

  test("password validation returns false when is blank", () {
    expect(
      viewModel.isPasswordValid(password: "        "),
      false,
    ); // DO NOT CHANGE: intentionally left blank
  });

  test("password validation returns true when conditions met", () {
    expect(viewModel.isPasswordValid(password: "abcdefg"), true);
  });
}
