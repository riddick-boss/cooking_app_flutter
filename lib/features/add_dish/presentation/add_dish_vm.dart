import 'package:cooking_app_flutter/core/domain/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/dish.dart';
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
    final dish = Dish(
        category: category,
        preparationTimeInMinutes: preparationTimeInMinutes,
        dishName: dishName,
    );
    try {
      await _dbManager.createDish(dish);
      // TODO: show info to user
    } catch(e) {
      debugPrint("error during dish creation: $e");
      //TODO: show  info to user
    }
  }
}
