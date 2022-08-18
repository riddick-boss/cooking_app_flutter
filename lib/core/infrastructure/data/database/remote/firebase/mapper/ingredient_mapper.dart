import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_ingredient.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/ingredient.dart';

extension IngredientMapper on Ingredient {
  FirestoreIngredient toFirestoreIngredient() => FirestoreIngredient(
        name: name,
        quantity: quantity,
        id: id,
      );
}

extension ListIngredientMapper on List<Ingredient> {
  List<FirestoreIngredient> toFireStoreIngredients() => map((ingredient) => ingredient.toFirestoreIngredient()).toList();
}

extension FirestoreIngredientMapper on FirestoreIngredient {
  Ingredient toIngredient() => Ingredient(
        name: name,
        quantity: quantity,
        id: id,
      );
}

extension ListFirestoreIngredientMapper on List<FirestoreIngredient> {
  List<Ingredient> toIngredients() => map((ingredient) => ingredient.toIngredient()).toList();
}
