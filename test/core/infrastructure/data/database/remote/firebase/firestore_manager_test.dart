import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/firestore_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/model/auth_user.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'firestore_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FirebaseFirestore>(), MockSpec<AuthManager>()])
void main() {
  late FirebaseFirestore firestore;
  late AuthManager authManager;
  late FirestoreManager manager;

  setUp(() {
    firestore = MockFirebaseFirestore();
    authManager = MockAuthManager();
    manager = FirestoreManager(authManager, firestore);
  });

  test("initUserCollection throws ArgumentError when user ids do not match", () async {
    when(authManager.currentUser).thenReturn(const AuthUser(uid: "uid", email: "email", displayName: "displayName"));
    Object? exception;
    try {
      await manager.initUserCollection(userUid: "differentUserUid", firstName: "firstName", lastName: "lastName");
    } catch(e) {
      exception = e;
    }
    expect(exception, isArgumentError);
  });
}
