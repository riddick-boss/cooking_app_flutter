import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_dish.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_dish_photo.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_ingredient.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_step.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_steps_group.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/firestore_constants.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/mapper/dish_mapper.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class FirestoreManager implements RemoteDatabaseManager {
  final _fireStore = getIt<FirebaseFirestore>();
  final _authManager = getIt<AuthManager>();

  String get _userId => _authManager.currentUser!.uid;
  CollectionReference<Map<String, dynamic>> get _usersCollection => _fireStore.collection(FirestoreConstants.usersCollection);
  DocumentReference<Map<String, dynamic>> get _userDoc => _fireStore.collection(FirestoreConstants.usersCollection).doc(_userId);
  CollectionReference<Map<String, dynamic>> get _userDishesCollection => _userDoc.collection(FirestoreConstants.userAllDishesCollection);
  Reference get _storageRef => FirebaseStorage.instance.ref();
  Reference get _userDishPhotosPhotosRef => _storageRef.child(FirestoreConstants.usersCollection).child(_userId).child(FirestoreConstants.photosCollection);

  // this should be done by backend, but in this project I wanted to focus on Flutter
  @override
  Future<void> initUserCollection({required String userUid, required String firstName, required String lastName}) async { // TODO: check if user collection already exists
    if(userUid != _userId) throw ArgumentError("User ids do not match!");
    await _usersCollection.doc(userUid).set({
      FirestoreConstants.userFirstNameField: firstName,
      FirestoreConstants.userLastNameField: lastName,
    });
  }

  @override
  Future<UnmodifiableListView<Dish>> getAllDishes() async { // TODO: catch exceptions
    // TODO: implement getAllDishes
    final snapshot = await _userDishesCollection.get();
    final response = snapshot.docs;
    // TODO: map to list of dishes
    final list = List<Dish>.empty(growable: true);
    for(final documentSnapshot in response) {
      final dishData = documentSnapshot.data();
      debugPrint("response");
      debugPrint("$dishData");
      final photos = await _getDishPhotos(documentSnapshot.id);
      list.add(
          FirestoreDish.fromFirestore(
            snapshot: documentSnapshot,
            ingredients: List.empty(), // TODO
            preparationStepsGroups: List.empty(), // TODO
            photos: photos,
          ).toDish(),
      );
    }
    return UnmodifiableListView(list.sorted());
  }

  Future<List<FireStoreDishPhoto>> _getDishPhotos(String dishId) async { // TODO: catch exception
    final snapshot = await _userDishesCollection.doc(dishId).collection(FirestoreConstants.photosCollection).get();
    final response = snapshot.docs;
    return response.map(FireStoreDishPhoto.fromFirestore).toList(growable: false).sorted();
  }

  @override
  Stream<UnmodifiableListView<Dish>> get allUserDishes { // TODO: catch exceptions
    final response = _userDishesCollection.snapshots();
    debugPrint("${response.first}");
    return response.map((event) {
      debugPrint("allUserDishes event");
      debugPrint("${event.docs}");
      final list = event.docs.map((e) {
        debugPrint("${e.data()}");
        return Dish(
          dishName: "dishName", // TODO
          preparationTimeInMinutes: 0, // TODO
          category: "category", // TODO
          ingredients: List.empty(), //TODO
          preparationStepsGroups: List.empty(), //TODO
          photos: List.empty(), // TODO
        );
      }).toList(growable: false).sorted();
      return UnmodifiableListView(list);
    });
  }

  @override
  Future<void> createDish(Dish dish) async {
    final fireStoreDish = dish.toFirestoreDish();

    final dishDoc = await _userDishesCollection.add(fireStoreDish.toFirestore()); // TODO: save public or not

    debugPrint("Created dish with ID: ${dishDoc.id}");

    await _createIngredients(dishDoc, fireStoreDish.ingredients);
    await _createPreparationStepsAndGroups(dishDoc, fireStoreDish.preparationStepsGroups);
    await _savePhotos(dishDoc, fireStoreDish.photos);
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

  Future<void> _createPreparationStepsAndGroups(DocumentReference<Map<String, dynamic>> dishDoc, List<FireStorePreparationStepsGroup> groups) async {
    final groupsDocs = await _createPreparationStepsGroupsAndGetDocs(dishDoc, groups);

    groupsDocs.forEach((groupDoc, group) async {
      await _createPreparationSteps(groupDoc, group.steps);
    });
  }

  Future<void> _savePhotos(DocumentReference<Map<String, dynamic>> dishDoc, List<FireStoreDishPhoto> photos) async {
    final photosCollection = dishDoc.collection(FirestoreConstants.photosCollection);
    final urlsBatch = _fireStore.batch();

    for(final photo in photos) {
      final path = "${DateTime.now().millisecondsSinceEpoch}_mobile";
      final photoRef = _userDishPhotosPhotosRef.child(path);
      await photoRef.putData(
        await photo.xFile()!.readAsBytes(),
        SettableMetadata(
          contentDisposition: "image/jpeg",
        ),
      );

      final downloadUrl = await photoRef.getDownloadURL();
      final ref = photosCollection.doc();
      urlsBatch.set(ref, photo.toFirestore(downloadUrl));
    }

    await urlsBatch.commit();
    debugPrint("Uploaded photos and committed all downloadUrls");
  }
}
