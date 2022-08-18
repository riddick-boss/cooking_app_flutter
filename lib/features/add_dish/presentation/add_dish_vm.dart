import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish_photo.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/ingredient.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/preparation_step.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/preparation_steps_group.dart';
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
    final prepSteps1 = [PreparationStep(name: "step2", sortOrder: 2), PreparationStep(name: "step1", sortOrder: 1)]; //TODO: del
    final prepSteps2 = [PreparationStep(name: "1step", sortOrder: 1), PreparationStep(name: "2step", sortOrder: 2)]; //TODO: del
    final group1 = PreparationStepsGroup(name: "group1", sortOrder: 1, steps: prepSteps1); //TODO: del
    final group2 = PreparationStepsGroup(name: "group2", sortOrder: 2, steps: prepSteps2); //TODO: del
    final groups = [group2, group1]; //TODO: del
    final photos = <DishPhoto>[];
    final dish = Dish(
      category: category,
      preparationTimeInMinutes: preparationTimeInMinutes,
      dishName: dishName,
      ingredients: [ingredient1, ingredient2], //TODO: from user
      preparationStepsGroups: groups, //TODO: from user
      photos: photos,
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
