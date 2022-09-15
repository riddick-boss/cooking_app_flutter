import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_dish_photo.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_ingredient.dart';

import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_steps_group.dart';

class FirestoreDish {
  FirestoreDish({
    required this.dishName,
    required this.preparationTimeInMinutes,
    required this.category,
    required this.ingredients,
    required this.preparationStepsGroups,
    required this.photos,
    this.dishId,
  });

  factory FirestoreDish.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    List<FirestoreIngredient> ingredients,
    List<FireStorePreparationStepsGroup> preparationStepsGroups,
    List<FireStoreDishPhoto> photos,
  ) {
    final data = snapshot.data();
    if(data == null) throw ArgumentError("Dish data from firebase is null!");
    return FirestoreDish(
      dishName: data[_FirestoreDishFields.dishName] as String,
      preparationTimeInMinutes: data[_FirestoreDishFields.preparationTimeInMinutes] as int,
      category: data[_FirestoreDishFields.category] as String,
      ingredients: ingredients,
      preparationStepsGroups: preparationStepsGroups,
      photos: photos,
      dishId: snapshot.id,
    );
  }

  Map<String, dynamic> toFirestore() => {
    _FirestoreDishFields.dishName: dishName,
    _FirestoreDishFields.preparationTimeInMinutes: preparationTimeInMinutes,
    _FirestoreDishFields.category: category,
  };

  final String dishName;
  final int preparationTimeInMinutes;
  final String category;
  final List<FirestoreIngredient> ingredients;
  final List<FireStorePreparationStepsGroup> preparationStepsGroups;
  final List<FireStoreDishPhoto> photos;
  final String? dishId;
}

class _FirestoreDishFields {
  static const dishName = 'dish_name';
  static const preparationTimeInMinutes = 'preparation_time_in_minutes';
  static const category = 'category';
}
