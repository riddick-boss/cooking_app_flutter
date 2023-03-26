import 'dart:collection';

import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/features/dishes/data/dishes_source.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

@injectable
class DishesViewModel {
  DishesViewModel(this._dishesSource);

  final DishesSource _dishesSource;

  final _dishesSubject = BehaviorSubject<List<Dish>>.seeded(List.empty());
  Stream<List<Dish>> get dishesStream => _dishesSubject.stream;

  final _showSnackBarSubject = PublishSubject<String>();
  Stream<String> get showSnackBarStream => _showSnackBarSubject.stream;

  Future<void> getDishes() async {
    UnmodifiableListView<Dish> dishes;
    try {
      dishes = await _dishesSource.getAllDishes();
    } catch(e) {
      dishes = UnmodifiableListView(List.empty());
      _showSnackBarSubject.add(AppStrings.dishesListLoadingError);
    }
    _dishesSubject.add(dishes);
  }

  Future<void> refreshDishes() async {
    await getDishes();
  }
}
