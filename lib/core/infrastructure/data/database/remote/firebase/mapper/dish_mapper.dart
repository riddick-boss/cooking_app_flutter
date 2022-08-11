import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_dish.dart';

extension DishMapper on Dish {
  FirestoreDish toFirestoreDish() => FirestoreDish(
        dishName: dishName,
        category: category,
        preparationTimeInMinutes: preparationTimeInMinutes,
        dishId: dishId,
      );
}

extension FirestoreDishMapper on FirestoreDish {
  Dish toDish() => Dish(
      dishName: dishName,
      category: category,
      preparationTimeInMinutes: preparationTimeInMinutes,
      dishId: dishId,
  );
}
