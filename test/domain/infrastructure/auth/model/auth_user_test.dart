import 'package:cooking_app_flutter/domain/infrastructure/auth/model/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("auth user constructor initialized class properly", () {
    const uid = "uid";
    const email = "email";
    const displayName = "displayName";
    const authUser = AuthUser(uid: uid, email: email, displayName: displayName);
    expect(authUser.uid, uid);
    expect(authUser.email, email);
    expect(authUser.displayName, displayName);
  });
}
