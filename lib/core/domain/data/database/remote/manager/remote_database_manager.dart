import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/dish.dart';

abstract class RemoteDatabaseManager {
  Future<void> initUserCollection({required String userUid, required String firstName, required String lastName});

  Future<void> getAllDishes(); // TODO

  Future<void> createDish(Dish dish);
}
