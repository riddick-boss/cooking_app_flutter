import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_app_flutter/core/domain/data/database/remote/remote_database.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/firestore_constants.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:injectable/injectable.dart';

@injectable
class FirebaseRemoteDatabase implements RemoteDatabase {
  final _fireStore = getIt<FirebaseFirestore>();

  CollectionReference get _usersReference => _fireStore.collection(FirestoreConstants.usersCollection);

  @override
  Future<void> initUserCollection({required String userUid, required String firstName, required String lastName}) async {
    await _usersReference.doc(userUid).set({
      FirestoreConstants.userFirstNameField: firstName,
      FirestoreConstants.userLastNameField: lastName,
    });
  }

  @override
  Future<void> getAllDishes() {
    // TODO: implement getAllDishes
    throw UnimplementedError();
  }
}
