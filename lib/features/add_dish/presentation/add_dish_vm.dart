import 'package:cooking_app_flutter/core/domain/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/ingredient.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddDishViewModel {
  final _dbManager = getIt<RemoteDatabaseManager>();

  Future<void> onCreateDishClicked({
    required String dishName,
    required int preparationTimeInMinutes,
    required String category,
  }) async {
    final ingredient1 = Ingredient(name: "name1", quantity: "quantity1"); //TODO: del
    final ingredient2 = Ingredient(name: "name2"); // TODO: del
    final dish = Dish(
      category: category,
      preparationTimeInMinutes: preparationTimeInMinutes,
      dishName: dishName,
      ingredients: [ingredient1, ingredient2], //TODO: from user
    );
    try {
      await _dbManager.createDish(dish);
      // TODO: show info to user
    } catch(e) {
      debugPrint("error during dish creation: $e");
      //TODO: show  info to user
    }
  }

  // Future<void> onCreateDishClicked({
  //   required String dishName,
  //   required int preparationTimeInMinutes,
  //   required String category,
  // }) async {
  //   final dish = Dish(
  //       category: category,
  //       preparationTimeInMinutes: preparationTimeInMinutes,
  //       dishName: dishName,
  //       ingredients: [], //TODO
  //   );
  //   try {
  //     await _dbManager.createDish(dish);
  //     // TODO: show info to user
  //   } catch(e) {
  //     debugPrint("error during dish creation: $e");
  //     //TODO: show  info to user
  //   }
  // }
}
