import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:injectable/injectable.dart';

@injectable
class DataSource {
  DataSource(this._dbManager);

  final RemoteDatabaseManager _dbManager;

  Future<Dish> getDish(String dishId) async => _dbManager.getDish(dishId);
}
