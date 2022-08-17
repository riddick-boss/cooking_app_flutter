import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_dish.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/mapper/dish_photo_mapper.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/mapper/ingredient_mapper.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/mapper/preparation_steps_group_mapper.dart';

extension DishMapper on Dish {
  FirestoreDish toFirestoreDish() => FirestoreDish(
        dishName: dishName,
        preparationTimeInMinutes: preparationTimeInMinutes,
        category: category,
        ingredients: ingredients.toFireStoreIngredients(),
        preparationStepsGroups: preparationStepsGroups.toFirestorePreparationStepsGroups(),
        photos: photos.toFireStoreDishPhotos(),
        dishId: dishId,
      );
}

extension FirestoreDishMapper on FirestoreDish {
  Dish toDish() => Dish(
        dishName: dishName,
        preparationTimeInMinutes: preparationTimeInMinutes,
        category: category,
        ingredients: ingredients.toIngredients(),
        preparationStepsGroups: preparationStepsGroups.toPreparationStepsGroups(),
        photos: photos.toDishPhotos(),
        dishId: dishId,
      );
}
