import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("dishes compareTo sorting properly", () {
    final dish1 = Dish(
        name: "AAAA",
        preparationTimeInMinutes: 5,
        category: "category",
        ingredients: List.empty(),
        preparationStepsGroups: List.empty(),
        photos: List.empty());
    final dish2 = Dish(
        name: "BBBB",
        preparationTimeInMinutes: 2,
        category: "category",
        ingredients: List.empty(),
        preparationStepsGroups: List.empty(),
        photos: List.empty());
    final dish3 = Dish(
        name: "CCCCC",
        preparationTimeInMinutes: 4,
        category: "category",
        ingredients: List.empty(),
        preparationStepsGroups: List.empty(),
        photos: List.empty());

    final list = [dish2, dish3, dish1]
      ..sort();

    expect(list.map((e) => e.name), [dish1.name, dish2.name, dish3.name]);
  });
}
