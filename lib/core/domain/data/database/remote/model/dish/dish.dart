import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/ingredient.dart';
import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/preparation_steps_group.dart';

class Dish {

  Dish({
    required this.dishName,
    required this.preparationTimeInMinutes,
    required this.category,
    required this.ingredients,
    required this.preparationStepsGroups,
    this.dishId,
  });

  final String dishName;
  final int preparationTimeInMinutes;
  final String category;
  final List<Ingredient> ingredients;
  final List<PreparationStepsGroup> preparationStepsGroups;
  final String? dishId;
}
