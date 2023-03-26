import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_dish.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_dish_photo.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_ingredient.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_step.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_steps_group.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/firestore_constants.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/mapper/dish_mapper.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
@injectable
class FirestoreManager implements RemoteDatabaseManager {
  FirestoreManager(this._authManager, this._firestore);

  final FirebaseFirestore _firestore;
  final AuthManager _authManager;

  String get _userId => _authManager.currentUser!.uid;
  CollectionRef get _usersCollection => _firestore.collection(FirestoreConstants.usersCollection);
  DocRef get _userDoc => _firestore.collection(FirestoreConstants.usersCollection).doc(_userId);
  CollectionRef get _userDishesCollection => _userDoc.collection(FirestoreConstants.userAllDishesCollection);
  Reference get _storageRef => FirebaseStorage.instance.ref();
  Reference get _userDishPhotosPhotosRef => _storageRef.child(FirestoreConstants.usersCollection).child(_userId).child(FirestoreConstants.photosCollection);

  @override
  Future<void> initUserCollection({required String userUid, required String firstName, required String lastName}) async {
    if(userUid != _userId) throw ArgumentError("User ids do not match!");
    if(await _userDocExists(userUid)) throw ArgumentError("Doc with this userId ($userUid) already exists!");
    await _usersCollection.doc(userUid).set({
      FirestoreConstants.userFirstNameField: firstName,
      FirestoreConstants.userLastNameField: lastName,
    });
  }
  
  @override
  Future<UnmodifiableListView<Dish>> getAllDishes() async {
    final dishes = await _userDishesCollection.get();
    final list = List<Dish>.empty(growable: true);
    for (final dishDoc in dishes.docs) {
      list.add(
        FirestoreDish.fromFirestore(
          snapshot: dishDoc,
          ingredients: await _getIngredients(dishDoc.id),
          preparationStepsGroups: await _getPreparationStepsGroups(dishDoc.id),
          photos: await _getDishPhotos(dishDoc.id),
        ).toDish(),
      );
    }
    return UnmodifiableListView(list.sorted());
  }

  @override
  Future<Dish> getDish(String dishId) async {
    final dishSnapshot = await _userDishesCollection.doc(dishId).get();
    return FirestoreDish.fromFirestore(
      snapshot: dishSnapshot,
      ingredients: await _getIngredients(dishSnapshot.id),
      preparationStepsGroups: await _getPreparationStepsGroups(dishSnapshot.id),
      photos: await _getDishPhotos(dishSnapshot.id),
    ).toDish();
  }

  @override
  Future<void> createDish(Dish dish) async {
    final firestoreDish = dish.toFirestoreDish();
    final dishDoc = await _userDishesCollection.add(firestoreDish.toFirestore());
    await _createIngredients(dishDoc, firestoreDish.ingredients);
    await _createPreparationStepsAndGroups(dishDoc, firestoreDish.preparationStepsGroups);
    await _savePhotos(dishDoc, firestoreDish.photos);
  }
  
  // ------------------------- private helpers -------------------

  Future<bool> _userDocExists(String docId) async {
    final userDoc = await _userDishesCollection.doc(docId).get();
    return userDoc.exists;
  }

  Future<List<FirestoreDishPhoto>> _getDishPhotos(String dishId) async {
    final photos = await _userDishesCollection.doc(dishId).collection(FirestoreConstants.photosCollection).get();
    return photos.docs.map(FirestoreDishPhoto.fromFirestore).toList(growable: false).sorted();
  }

  Future<List<FirestoreIngredient>> _getIngredients(String dishId) async {
    final ingredients = await _userDishesCollection.doc(dishId).collection(FirestoreConstants.ingredientsCollection).get();
    return ingredients.docs.map(FirestoreIngredient.fromFirestore).toList(growable: false);
  }

  Future<List<FirestorePreparationStep>> _getPreparationSteps(String dishId, String stepsGroupId) async {
    final preparationSteps = await _userDishesCollection.doc(dishId).collection(FirestoreConstants.preparationStepsGroupsCollection).doc(stepsGroupId).collection(FirestoreConstants.preparationStepsCollection).get();
    return preparationSteps.docs.map(FirestorePreparationStep.fromFirestore).toList(growable: false).sorted();
  }

  Future<List<FirestorePreparationStepsGroup>> _getPreparationStepsGroups(String dishId) async {
    final stepsGroupsResponse = await _userDishesCollection.doc(dishId).collection(FirestoreConstants.preparationStepsGroupsCollection).get();
    final stepsGroups = List<FirestorePreparationStepsGroup>.empty(growable: true);

    for(final documentSnapshot in stepsGroupsResponse.docs) {
      final steps = await _getPreparationSteps(dishId, documentSnapshot.id);
      stepsGroups.add(FirestorePreparationStepsGroup.fromFirestore(snapshot: documentSnapshot, steps: steps));
    }

    return stepsGroups.sorted();
  }

  Future<void> _createIngredients(DocRef dishDoc, List<FirestoreIngredient> ingredients) async {
    final ingredientsCollection = dishDoc.collection(FirestoreConstants.ingredientsCollection);
    final batch = _firestore.batch();

    for (final ingredient in ingredients) {
      final ref = ingredientsCollection.doc();
      batch.set(ref, ingredient.toFirestore());
    }

    await batch.commit();
  }

  Future<Map<DocRef, FirestorePreparationStepsGroup>> _createPreparationStepsGroupsAndGetDocs(DocRef dishDoc, List<FirestorePreparationStepsGroup> groups) async {
    final groupsCollection = dishDoc.collection(FirestoreConstants.preparationStepsGroupsCollection);
    final batch = _firestore.batch();

    final groupsDocs = <DocRef, FirestorePreparationStepsGroup>{};

    for(final group in groups) {
      final ref = groupsCollection.doc();
      groupsDocs[ref] = group;
      batch.set(ref, group.toFirestore());
    }

    await batch.commit();
    return groupsDocs;
  }

  Future<void> _createPreparationSteps(DocRef groupDoc, List<FirestorePreparationStep> steps) async {
    final stepsCollection = groupDoc.collection(FirestoreConstants.preparationStepsCollection);
    final batch = _firestore.batch();

    for(final step in steps) {
      final ref = stepsCollection.doc();
      batch.set(ref, step.toFirestore());
    }

    await batch.commit();
  }

  Future<void> _createPreparationStepsAndGroups(DocRef dishDoc, List<FirestorePreparationStepsGroup> groups) async {
    final groupsDocs = await _createPreparationStepsGroupsAndGetDocs(dishDoc, groups);

    groupsDocs.forEach((groupDoc, group) async {
      await _createPreparationSteps(groupDoc, group.steps);
    });
  }

  Future<void> _savePhotos(DocRef dishDoc, List<FirestoreDishPhoto> photos) async {
    final photosCollection = dishDoc.collection(FirestoreConstants.photosCollection);
    final urlsBatch = _firestore.batch();

    for(final photo in photos) {
      final path = "${DateTime.now().millisecondsSinceEpoch}_android";
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
  }
}

typedef DocRef = DocumentReference<Map<String, dynamic>>;
typedef CollectionRef = CollectionReference<Map<String, dynamic>>;
