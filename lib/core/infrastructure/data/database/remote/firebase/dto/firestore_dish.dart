import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_ingredient.dart';

class FirestoreDish {
  FirestoreDish({
    required this.dishName,
    required this.preparationTimeInMinutes,
    required this.category,
    required this.ingredients,
    this.dishId,
  });

  factory FirestoreDish.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    // SnapshotOptions? options,
    List<FirestoreIngredient> ingredients,
  ) {
    final data = snapshot.data();
    if(data == null) throw ArgumentError("Dish data from firebase is null!");
    return FirestoreDish(
      dishName: data[_FirestoreDishFields.dishName] as String,
      preparationTimeInMinutes: data[_FirestoreDishFields.preparationTimeInMinutes] as int,
      category: data[_FirestoreDishFields.category] as String,
      ingredients: ingredients,
      dishId: data[_FirestoreDishFields.dishId] as String,
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
  final String? dishId;
}

class _FirestoreDishFields {
  static const dishName = 'dish_name';
  static const preparationTimeInMinutes = 'preparation_time_in_minutes';
  static const category = 'category';
  static const dishId = 'dish_id';
}
