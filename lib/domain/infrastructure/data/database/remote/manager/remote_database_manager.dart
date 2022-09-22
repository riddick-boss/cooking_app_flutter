import 'dart:collection';

import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';

abstract class RemoteDatabaseManager {
  Future<void> initUserCollection({
    required String userUid,
    required String firstName,
    required String lastName,
  });

  Future<UnmodifiableListView<Dish>> getAllDishes();
  
  Future<void> createDish(Dish dish);
}
