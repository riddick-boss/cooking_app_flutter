import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_app_flutter/core/domain/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/core/domain/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/firestore_constants.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/mapper/dish_mapper.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class FirestoreManager implements RemoteDatabaseManager {
  final _fireStore = getIt<FirebaseFirestore>();
  final _authManager = getIt<AuthManager>();

  String get _userId => _authManager.currentUser!.uid;
  CollectionReference get _usersReference => _fireStore.collection(FirestoreConstants.usersCollection);
  DocumentReference<Map<String, dynamic>> get _userDoc => _fireStore.collection(FirestoreConstants.usersCollection).doc(_userId);

  @override
  Future<void> initUserCollection({required String userUid, required String firstName, required String lastName}) async {
    if(userUid != _userId) throw ArgumentError("User ids do not match!");
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

  @override
  Future<void> createDish(Dish dish) async {
    final data = dish.toFirestoreDish().toFirestore();
    final allDishesCollection = _userDoc.collection(FirestoreConstants.userAllDishesCollection);
    await allDishesCollection.add(data)
        .then((documentSnapshot) => debugPrint("Created dish with ID: ${documentSnapshot.id}"));
  }
}
