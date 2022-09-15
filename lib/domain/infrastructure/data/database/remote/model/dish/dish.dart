import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish_photo.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/ingredient.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/preparation_steps_group.dart';

class Dish extends Comparable<Dish>{
  Dish({
    required this.dishName,
    required this.preparationTimeInMinutes,
    required this.category,
    required this.ingredients,
    required this.preparationStepsGroups,
    required this.photos,
    this.dishId,
  });

  final String dishName;
  final int preparationTimeInMinutes;
  final String category;
  final List<Ingredient> ingredients;
  final List<PreparationStepsGroup> preparationStepsGroups;
  final List<DishPhoto> photos;
  final String? dishId;

  @override
  int compareTo(Dish other) => dishName.compareTo(other.dishName); //TODO: is it fine?
}
