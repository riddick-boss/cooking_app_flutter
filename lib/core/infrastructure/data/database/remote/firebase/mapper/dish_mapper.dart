import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_dish.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/mapper/dish_photo_mapper.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/mapper/ingredient_mapper.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/mapper/preparation_steps_group_mapper.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';

extension DishMapper on Dish {
  FirestoreDish toFirestoreDish() => FirestoreDish(
        dishName: name,
        preparationTimeInMinutes: preparationTimeInMinutes,
        category: category,
        ingredients: ingredients.toFirestoreIngredients(),
        preparationStepsGroups: preparationStepsGroups.toFirestorePreparationStepsGroups(),
        photos: photos.toFirestoreDishPhotos(),
        dishId: dishId,
      );
}

extension FirestoreDishMapper on FirestoreDish {
  Dish toDish() => Dish(
        name: dishName,
        preparationTimeInMinutes: preparationTimeInMinutes,
        category: category,
        ingredients: ingredients.toIngredients(),
        preparationStepsGroups: preparationStepsGroups.toPreparationStepsGroups(),
        photos: photos.toDishPhotos(),
        dishId: dishId,
      );
}
