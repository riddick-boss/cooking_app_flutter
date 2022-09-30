import 'dart:collection';

import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';

abstract class RemoteDatabaseManager {
  // this should be done by backend, but in this project I wanted to focus on Flutter
  Future<void> initUserCollection({
    required String userUid,
    required String firstName,
    required String lastName,
  });

  Future<UnmodifiableListView<Dish>> getAllDishes();
  
  Future<void> createDish(Dish dish);
}
