import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

@injectable
class DishesViewModel { // TODO: add remote source
  final _dbManager = getIt<RemoteDatabaseManager>();

  final _dishesSubject = BehaviorSubject<List<Dish>>.seeded(List.empty());
  Stream<List<Dish>> get dishesStream => _dishesSubject.stream;

  // Stream<List<Dish>> get dishesStream => _dbManager.allUserDishes;

  Future<void> getDishes() async {
    final dishes = await _dbManager.getAllDishes();
    _dishesSubject.add(dishes);
  }

}
