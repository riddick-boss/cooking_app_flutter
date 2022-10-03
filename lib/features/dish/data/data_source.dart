import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:injectable/injectable.dart';

@injectable
class DataSource {
  final _dbManager = getIt<RemoteDatabaseManager>();

  Future<Dish> getDish(String dishId) async => _dbManager.getDish(dishId);
}
