import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_app_flutter/core/domain/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/core/domain/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_ingredient.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_step.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_steps_group.dart';
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
    final fireStoreDish = dish.toFirestoreDish();
    final dishData = fireStoreDish.toFirestore();
    final ingredients = fireStoreDish.ingredients;
    final preparationStepsGroups = fireStoreDish.preparationStepsGroups;
    final allDishesCollection = _userDoc.collection(FirestoreConstants.userAllDishesCollection);
    final dishDoc = await allDishesCollection.add(dishData);

    debugPrint("Created dish with ID: ${dishDoc.id}");

    await _createIngredients(dishDoc, ingredients);
    final groupsDocs = await _createPreparationStepsGroupsAndGetDocs(dishDoc, preparationStepsGroups);

    groupsDocs.forEach((groupDoc, group) async {
      await _createPreparationSteps(groupDoc, group.steps);
    });
  }

  Future<void> _createIngredients(DocumentReference<Map<String, dynamic>> dishDoc, List<FirestoreIngredient> ingredients) async {
    final ingredientsCollection = dishDoc.collection(FirestoreConstants.ingredientsCollection);
    final batch = _fireStore.batch();

    for (final ingredient in ingredients) {
      final ref = ingredientsCollection.doc();
      debugPrint("Created ingredient ref: $ref");
      batch.set(ref, ingredient.toFirestore());
    }

    await batch.commit();
    debugPrint("Committed all ingredients");
  }
  
  Future<Map<DocumentReference<Map<String, dynamic>>, FireStorePreparationStepsGroup>> _createPreparationStepsGroupsAndGetDocs(DocumentReference<Map<String, dynamic>> dishDoc, List<FireStorePreparationStepsGroup> groups) async {
    final groupsCollection = dishDoc.collection(FirestoreConstants.preparationStepsGroupsCollection);
    final batch = _fireStore.batch();
    
    final groupsDocs = <DocumentReference<Map<String, dynamic>>, FireStorePreparationStepsGroup>{};
    
    for(final group in groups) {
      final ref = groupsCollection.doc();
      groupsDocs[ref] = group;
      debugPrint("Created group ref: $ref");
      batch.set(ref, group.toFireStore());
    }
    
    await batch.commit();
    debugPrint("Committed all groups");
    return groupsDocs;
  }

  Future<void> _createPreparationSteps(DocumentReference<Map<String, dynamic>> groupDoc, List<FireStorePreparationStep> steps) async {
    final stepsCollection = groupDoc.collection(FirestoreConstants.preparationStepsCollection);
    final batch = _fireStore.batch();

    for(final step in steps) {
      final ref = stepsCollection.doc();
      debugPrint("Created step ref: $ref");
      batch.set(ref, step.toFirestore());
    }

    await batch.commit();
    debugPrint("Committed all steps");
  }
}
