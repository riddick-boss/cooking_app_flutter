import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/features/dish/data/data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

@injectable
class DishViewModel {
  final _dataSource = getIt<DataSource>();

  final _dishSubject = BehaviorSubject<Dish?>.seeded(null);
  Stream<Dish?> get dishStream => _dishSubject.stream;

  final _showSnackBarSubject = PublishSubject<String>();
  Stream<String> get showSnackBarStream => _showSnackBarSubject.stream;

  Future<void> getDish(String dishId) async {
    Dish? dish;
    try {
      dish = await _dataSource.getDish(dishId);
    } catch (e) {
      dish = null;
      _showSnackBarSubject.add(AppStrings.dishLoadingError);
    }
    _dishSubject.add(dish);
  }
}
